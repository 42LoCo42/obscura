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
          nvidia = pkgs.linuxPackages_zen.nvidiaPackages;
          mkNvidia = nvidia: [
            nvidia
            nvidia.persistenced
            nvidia.settings
          ];
        in
        pipe [
          (mkNvidia nvidia.production)
          # (mkNvidia nvidia.stable)
          [ pkgs.nvtopPackages.nvidia ]
        ] [
          builtins.concatLists
          (pkgs.linkFarmFromDrvs "nvidia")
        ];

      rawMatrix = pipe self.githubActions.matrix [
        builtins.toJSON
        (pkgs.writeText "rawMatrix")
      ];
    in
    allPackages // {
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
          "|`${name}`|`${p.version or ""}`|${p.meta.description or ""}|${p.meta.homepage or ""}|"))
        (x: pipe x [
          (builtins.concatStringsSep "\n")
          (s: pipe ./README.md.in [
            builtins.readFile
            (builtins.replaceStrings
              [ "@NUM@" ]
              [ (toString (builtins.length x)) ])
            (x: x + s + "\n")
          ])
          (s: pkgs.writeShellScriptBin "readme" ''
            cat <<\EOF > README.md
            ${s}
            EOF
          '')
        ])
      ];

      matrix = pkgs.writeShellApplication {
        name = "matrix";
        runtimeInputs = with pkgs; [ curl jq parallel ];
        text = ''
          getnar() {
            { nix eval --quiet --raw ".#$1" 2>&1 1>&3 3>&- \
            | grep -Ev "warning|ignored"; } 3>&1 1>&2 | cut -b 12-43
          }
          export -f getnar

          check() {
            read -r attr os <<< "$1"
            nar="$(getnar "$attr")"
            if [ -z "$nar" ]; then
              echo "FATAL: empty NAR for '$attr'" >&2
              exit 1
            fi

            if curl -fs "https://attic.eleonora.gay/default/$nar.narinfo" > /dev/null; then
              state="[1;32mCACHE[m"
            else
              state="[1;31mBUILD[m"
              jq -cn '{attr: $ARGS.positional[0], os: $ARGS.positional[1]}' \
                --args "$attr" "$os"
            fi

            echo "[$state] $nar $attr" >&2
          }
          export -f check

          < ${rawMatrix}                             \
            jq -r '.include[] | "\(.attr) \(.os[])"' \
          | parallel check                           \
          | jq -cs 'if . == [] then empty else {"include": .} end'
        '';
      };

      hammer = pkgs.writeShellApplication {
        name = "hammer";
        runtimeInputs = with pkgs; [ jq nixpkgs-hammering parallel ];
        text = pipe self.packages.${pkgs.system} [
          (mapAttrsToList (n: _: n))
          (builtins.concatStringsSep "\n")
          (x: ''
            if [ -n "''${1-}" ]; then
              parallel nix build -L --no-link '.#{}' << EOF
            ${x}
            EOF
            fi

            xargs nixpkgs-hammer -f \
              ${pkgs.writeText "default.nix" ''
                _: (builtins.getFlake "git+file://''${builtins.getEnv "PWD"}").packages.''${builtins.currentSystem}
              ''} \
            << EOF |& grep -Ev '^error: build log' | less
            ${x}
            EOF
          '')
        ];
      };
    };
}
