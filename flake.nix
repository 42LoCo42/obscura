{
  description = "A personal collection of unusual things";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nix-github-actions.url = "github:nix-community/nix-github-actions";
    nix-github-actions.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nix-github-actions }:
    let
      inherit (nixpkgs.lib)
        getAttrs
        mapAttrs'
        mapAttrsToList
        pipe
        recursiveUpdate
        ;

      merge = builtins.foldl' recursiveUpdate { };

      ##########################################

      mkPackages = system:
        let
          dir = ./packages;

          pkgs = import nixpkgs {
            inherit system;
            overlays = [ (_: _: packages) ];
          };

          packages = pipe dir [
            builtins.readDir
            (mapAttrs' (file: _: {
              name = builtins.replaceStrings [ ".nix" ] [ "" ] file;
              value = import "${dir}/${file}" pkgs;
            }))
          ];
        in
        { packages.${system} = packages; };

      allPackages = merge (map mkPackages
        [ "x86_64-linux" "aarch64-linux" ]);

      ##########################################

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      nvidia =
        let
          nvidia = pkgs.zfs.latestCompatibleLinuxPackages.nvidiaPackages;
        in
        pkgs.linkFarmFromDrvs "nvidia" [
          nvidia.stable
          nvidia.stable.persistenced
          nvidia.stable.settings
          pkgs.nvtopPackages.nvidia
        ];

      rawMatrix = pipe self.githubActions.matrix [
        builtins.toJSON
        (pkgs.writeText "rawMatrix")
      ];
    in
    allPackages // {
      overlay = _: prev: self.packages.${prev.system};

      githubActions = nix-github-actions.lib.mkGithubMatrix {
        checks = merge [
          (getAttrs [ system ] self.packages)
          { ${system} = { inherit nvidia; }; }
        ];
      };

      nixosModules."9mount" = import ./packages/9mount/module.nix {
        packages = self.packages;
      };

      templates = let dir = ./templates; in pipe dir [
        builtins.readDir
        builtins.attrNames
        (map (name: {
          inherit name;
          value = {
            description = "${name} template";
            path = "${dir}/${name}";
          };
        }))
        builtins.listToAttrs
      ];

      ##########################################

      readme = pipe self.packages.${pkgs.system} [
        (mapAttrsToList (name: p:
          "|`${name}`|${p.meta.description or ""}|${p.meta.homepage or ""}|"))
        (builtins.concatStringsSep "\n")
        (s: pkgs.writeText "readme"
          (builtins.readFile ./README.md.in + s + "\n"))
        (s: pkgs.writeShellScriptBin "readme" ''
          install -m644 ${s} README.md
        '')
      ];

      matrix = pkgs.writeShellApplication {
        name = "matrix";
        runtimeInputs = with pkgs; [ curl jq parallel ];
        text = ''
          check() {
            read -r attr os <<< "$1"
            nar="$(nix eval --raw ".#$attr" | cut -b 12-43)"

            if curl -fs "https://attic.eleonora.gay/default/$nar.narinfo" > /dev/null; then
              state="[1;32mCACHE[m"
            else
              state="[1;31mBUILD[m"
              printf '{"attr":"%s","os":["%s"]}\n' "$attr" "$os"
            fi

            echo "[$state] $nar $attr" >&3
          }
          export -f check

          < ${rawMatrix}                             \
            jq -r '.include[] | "\(.attr) \(.os[])"' \
          | parallel check 3>&2 2>/dev/null          \
          | jq -cs 'if . == [] then empty else {"include": .} end'
        '';
      };

      build = pkgs.writeShellApplication {
        name = "build";
        runtimeInputs = with pkgs; [ attic-client ];
        text = ''
          attic login eleonora https://attic.eleonora.gay "$ATTIC_TOKEN"

          nix build -L --no-link --print-out-paths ".#$1" \
          | xargs attic push default
        '';
      };
    };
}
