{
  description = "A personal collection of unusual things";

  inputs = {
    nixpkgs-pin.url = "github:nixos/nixpkgs/a0c9e3aee1000ac2bfb0e5b98c94c946a5d180a9";
    nixpkgs-new.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs-pin, nixpkgs-new }:
    let
      inherit (nixpkgs-pin.lib) mapAttrsToList pipe recursiveUpdate;

      nyx = builtins.getFlake "github:notashelf/nyxpkgs/a9c2ef2ea7c4b7e5036f7c60108df2bbcfc9a3c4?narHash=sha256-NiL7KfpHhUx7zLVFKtwPz7d9uJq/ABQEqf1y/lTWSGI=";

      mkPackages = system:
        let pkgs = import nixpkgs-pin { inherit system; }; in rec {
          "9mount" = pkgs.callPackage ./packages/9mount { };
          agregore = pkgs.callPackage ./packages/agregore { };
          argtable2 = pkgs.callPackage ./packages/argtable2.nix { };
          bedrockdb = pkgs.callPackage ./packages/bedrockdb { };
          capnp-go = pkgs.callPackage ./packages/capnp-go.nix { };
          comskip = pkgs.callPackage ./packages/comskip.nix { inherit argtable2; };
          e2eirc = pkgs.callPackage ./packages/e2eirc { };
          flameshot-fixed = pkgs.callPackage ./packages/flameshot-fixed.nix { };
          fusepod = pkgs.callPackage ./packages/fusepod.nix { };
          jade = pkgs.callPackage ./packages/jade.nix { };
          libhpke = pkgs.callPackage ./packages/libhpke { };
          lone = pkgs.callPackage ./packages/lone { };
          m9u = pkgs.callPackage ./packages/m9u.nix { };
          msp-cgt = pkgs.callPackage ./packages/msp-cgt.nix { };
          mspgcc-ti = pkgs.callPackage ./packages/mspgcc-ti.nix { };
          photoview = pkgs.callPackage ./packages/photoview.nix { };
          prettier-plugin-go-template = pkgs.callPackage ./packages/prettier-plugin-go-template.nix { };
          pug = pkgs.callPackage ./packages/pug { };
          redis-json = pkgs.callPackage ./packages/redis-json { };
          sae_pk_gen = pkgs.callPackage ./packages/sae_pk_gen.nix { };
          samloader = pkgs.callPackage ./packages/samloader.nix { };
          wayland-shell = pkgs.callPackage ./packages/wayland-shell.nix { };

          foot-transparent = nyx.packages.${system}.foot-transparent // {
            meta.description = "A patched version of the foot terminal emulator that brings back fullscreen transparency";
            meta.homepage = "https://github.com/NotAShelf/nyxpkgs/blob/main/pkgs/applications/terminal-emulators/foot-transparent/default.nix";
          };

          my-htop = pkgs.htop.overrideAttrs (old: rec {
            version = "5d778ea";
            src = pkgs.fetchFromGitHub {
              inherit (old.src) owner repo;
              rev = version;
              hash = "sha256-EAqirkDle0VbG4VEaiWwIAgISP8JsUAkgfkGQWAAXkc=";
            };
            meta = old.meta // {
              description = "htop with sorting in tree mode fixed";
            };
          });

          my-ncmpcpp = pkgs.ncmpcpp.overrideAttrs (old: {
            patches = [ ./packages/my-ncmpcpp.patch ];
            meta = old.meta // {
              description = "ncmpcpp except the media library always shows Albums - Songs";
            };
          });
        };

      mkPackageSet = system: { packages.${system} = mkPackages system; };

      pkgs = import nixpkgs-pin { system = "x86_64-linux"; };
      merge = builtins.foldl' recursiveUpdate { };

      mkCi = attr: pkgs.writeShellApplication {
        name = "ci";
        runtimeInputs = with pkgs; [ attic-client jq nix-eval-jobs ];
        text = ''
          attic login eleonora https://attic.eleonora.gay "$ATTIC_TOKEN"

          nix-eval-jobs                                       \
            --check-cache-status                              \
            --force-recurse                                   \
            --workers "$(nproc)"                              \
            --flake ".#${attr}"                               \
          | jq -r 'if .isCached then empty else .drvPath end' \
          | xargs -P "$(nproc)" -I% nix-store --realise %     \
          | tee /dev/stderr                                   \
          | xargs attic push default
        '';
      };
    in
    merge [
      (mkPackageSet "x86_64-linux")
      (mkPackageSet "aarch64-linux") # opportunistic, not all packages will build
      {
        overlay = _: prev: mkPackages prev.system;

        nixosModules = {
          "9mount" = import ./packages/9mount/module.nix {
            packages = self.outputs.packages;
          };
        };

        templates = let dir = ./templates; in pipe dir [
          builtins.readDir
          builtins.attrNames
          (map (name: {
            inherit name;
            value = {
              description = "A flake template for ${name}";
              path = "${dir}/${name}";
            };
          }))
          builtins.listToAttrs
        ];

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

        ci = mkCi "packages.${pkgs.system}";

        nvidia =
          let
            pkgs-new = import nixpkgs-new {
              inherit (pkgs) system;
              config.allowUnfree = true;
            };

            nvidia = pkgs-new.zfs.latestCompatibleLinuxPackages.nvidiaPackages;

            targets = pipe [
              nvidia.stable
              nvidia.stable.persistenced
              nvidia.stable.settings
              pkgs-new.nvtopPackages.nvidia
            ] [
              (map (x: { inherit (x) name; value = x; }))
              builtins.listToAttrs
            ];

            ci = mkCi "nvidia.targets";
          in
          { inherit targets ci; };
      }
    ];
}
