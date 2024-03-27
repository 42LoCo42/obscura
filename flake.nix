{
  description = "A personal collection of unusual things";

  outputs = { self, nixpkgs }:
    let
      mkLanza030 = pkgs: import (pkgs.fetchFromGitHub {
        owner = "nix-community";
        repo = "lanzaboote";
        rev = "v0.3.0";
        hash = "sha256-Fb5TeRTdvUlo/5Yi2d+FC8a6KoRLk2h1VE0/peMhWPs=";
      });

      mkPackages = system:
        let
          pkgs = import nixpkgs { inherit system; };
          lanza030 = mkLanza030 pkgs;
        in
        rec {
          # argon-kg = self.inputs.argon-kg.outputs.defaultPackage.${system};
          # boomer = pkgs.callPackage ./packages/boomer.nix { inherit nimblePkgs; };
          # certbot-dns-duckdns = pkgs.callPackage ./packages/certbot-dns-duckdns.nix { };
          # musializer = pkgs.callPackage ./packages/musializer.nix { };
          # vulnix = pkgs.callPackage ./packages/vulnix.nix { };

          "9mount" = pkgs.callPackage ./packages/9mount { };
          SwayAudioIdleInhibit = pkgs.callPackage ./packages/SwayAudioIdleInhibit.nix { };
          XWaylandVideoBridge = pkgs.callPackage ./packages/XWaylandVideoBridge.nix { };
          agregore = pkgs.callPackage ./packages/agregore { };
          capnp-go = pkgs.callPackage ./packages/capnp-go.nix { };
          e2eirc = pkgs.callPackage ./packages/e2eirc { };
          flameshot-fixed = pkgs.callPackage ./packages/flameshot-fixed.nix { };
          foot-transparent = pkgs.callPackage ./packages/foot-transparent { };
          fusepod = pkgs.callPackage ./packages/fusepod.nix { };
          gtk4-layer-shell = pkgs.callPackage ./packages/gtk4-layer-shell.nix { };
          k0s-bin = pkgs.callPackage ./packages/k0s-bin.nix { };
          libhpke = pkgs.callPackage ./packages/libhpke { };
          lone = pkgs.callPackage ./packages/lone { };
          m9u = pkgs.callPackage ./packages/m9u.nix { };
          msp-cgt = pkgs.callPackage ./packages/msp-cgt.nix { };
          mspgcc-ti = pkgs.callPackage ./packages/mspgcc-ti.nix { };
          prettier-plugin-go-template = pkgs.callPackage ./packages/prettier-plugin-go-template.nix { };
          pug = pkgs.callPackage ./packages/pug { };
          redis-json = pkgs.callPackage ./packages/redis-json { };
          samloader = pkgs.callPackage ./packages/samloader.nix { };
          wayland-shell = pkgs.callPackage ./packages/wayland-shell.nix { inherit gtk4-layer-shell; };

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

          my-lzbt = lanza030.packages.${system}.lzbt.overrideAttrs (_: {
            meta = {
              description = "Secure Boot for NixOS - pinned to v0.3.0";
              homepage = "https://github.com/nix-community/lanzaboote";
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

      pkgs = import nixpkgs { system = "x86_64-linux"; };
      merge = builtins.foldl' nixpkgs.lib.recursiveUpdate { };
    in
    merge [
      (mkPackageSet "x86_64-linux")

      (
        let
          system = "aarch64-linux";
          packages = mkPackages system;
        in
        {
          packages.${system} = {
            inherit (packages)
              my-htop
              pug
              ;
          };
        }
      )

      {
        nixosModules = {
          "9mount" = import ./packages/9mount/module.nix {
            packages = self.outputs.packages;
          };

          inherit ((mkLanza030 pkgs).nixosModules) lanzaboote;
        };

        templates = let dir = ./templates; in nixpkgs.lib.pipe dir [
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

        ci = pkgs.writeShellScriptBin "ci" ''
          set -euo pipefail
          ${pkgs.nixci}/bin/nixci | ${pkgs.cachix}/bin/cachix push 42loco42
        '';

        readme = nixpkgs.lib.pipe self.packages.${pkgs.system} [
          (nixpkgs.lib.mapAttrsToList (name: p:
            "- `${name}`: ${p.meta.description or "no description"} - ${p.meta.homepage or "no homepage"}"))
          (builtins.concatStringsSep "\n")
          (s: "# Packages\n" + s + "\n")
          (s: pkgs.writeShellScriptBin "readme" ''
            cat <<\EOF | grep . > README.md
            ${s}
            EOF
          '')
        ];
      }
    ];
}
