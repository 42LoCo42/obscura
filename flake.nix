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
      pkgs = import nixpkgs { inherit system; };
    in
    allPackages // {
      overlay = _: prev: self.packages.${prev.system};

      githubActions = nix-github-actions.lib.mkGithubMatrix {
        checks = getAttrs [ system ] self.packages;
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

      ci = pkgs.writeShellApplication {
        name = "ci";
        runtimeInputs = with pkgs; [ attic-client curl ];
        text = ''
          attic login eleonora https://attic.eleonora.gay "$ATTIC_TOKEN"

          nar="$(nix eval -L --raw ".#$1" | cut -b 12-43)"
          echo "$1 is $nar"
          if curl -fs "https://attic.eleonora.gay/default/$nar.narinfo" > /dev/null; then
            echo "$1 is already cached!"
          else
            nix build -L --no-link --print-out-paths ".#$1" \
            | xargs attic push default
          fi
        '';
      };
    };

  #     ci = mkCi "packages.${pkgs.system}";

  #     nvidia =
  #       let
  #         pkgs-new = import nixpkgs-new {
  #           inherit (pkgs) system;
  #           config.allowUnfree = true;
  #         };

  #         nvidia = pkgs-new.zfs.latestCompatibleLinuxPackages.nvidiaPackages;

  #         targets = pipe [
  #           nvidia.stable
  #           nvidia.stable.persistenced
  #           nvidia.stable.settings
  #           pkgs-new.nvtopPackages.nvidia
  #         ] [
  #           (map (x: { inherit (x) name; value = x; }))
  #           builtins.listToAttrs
  #         ];

  #         ci = mkCi "nvidia.targets";
  #       in
  #       { inherit targets ci; };
  #   }
  # ];
}
