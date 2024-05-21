{
  description = "A personal collection of unusual things";

  inputs = {
    # nce.url = "github:snowfallorg/nixos-conf-editor";
    # nce.inputs.nixpkgs.follows = "nixpkgs";

    # nsc.url = "github:snowfallorg/nix-software-center";
    # nsc.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs.url = "github:nixos/nixpkgs/a0c9e3aee1000ac2bfb0e5b98c94c946a5d180a9";
    nixpkgs-new.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-new }:
    let
      inherit (nixpkgs.lib) mapAttrsToList pipe recursiveUpdate;

      mkLanza030 = pkgs: import (pkgs.fetchFromGitHub {
        owner = "nix-community";
        repo = "lanzaboote";
        rev = "v0.3.0";
        hash = "sha256-Fb5TeRTdvUlo/5Yi2d+FC8a6KoRLk2h1VE0/peMhWPs=";
      });

      nyx = builtins.getFlake "github:notashelf/nyxpkgs/a9c2ef2ea7c4b7e5036f7c60108df2bbcfc9a3c4?narHash=sha256-NiL7KfpHhUx7zLVFKtwPz7d9uJq/ABQEqf1y/lTWSGI=";

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
          fusepod = pkgs.callPackage ./packages/fusepod.nix { };
          gtk4-layer-shell = pkgs.callPackage ./packages/gtk4-layer-shell.nix { };
          jade = pkgs.callPackage ./packages/jade.nix { };
          # k0s-bin = pkgs.callPackage ./packages/k0s-bin.nix { };
          libhpke = pkgs.callPackage ./packages/libhpke { };
          lone = pkgs.callPackage ./packages/lone { };
          m9u = pkgs.callPackage ./packages/m9u.nix { };
          msp-cgt = pkgs.callPackage ./packages/msp-cgt.nix { };
          mspgcc-ti = pkgs.callPackage ./packages/mspgcc-ti.nix { };
          prettier-plugin-go-template = pkgs.callPackage ./packages/prettier-plugin-go-template.nix { };
          pug = pkgs.callPackage ./packages/pug { };
          redis-json = pkgs.callPackage ./packages/redis-json { };
          sae_pk_gen = pkgs.callPackage ./packages/sae_pk_gen.nix { };
          samloader = pkgs.callPackage ./packages/samloader.nix { };
          wayland-shell = pkgs.callPackage ./packages/wayland-shell.nix { inherit gtk4-layer-shell; };

          foot-transparent = nyx.packages.${system}.foot-transparent // {
            meta.description = "A patched version of the foot terminal emulator that brings back fullscreen transparency";
            meta.homepage = "https://github.com/NotAShelf/nyxpkgs/blob/main/pkgs/applications/terminal-emulators/foot-transparent/default.nix";
          };

          # nixos-conf-editor = nce.packages.${system}.nixos-conf-editor // {
          #   meta.description = "A libadwaita/gtk4 app for editing NixOS configurations";
          #   meta.homepage = "https://github.com/snowfallorg/nixos-conf-editor";
          # };

          # nix-software-center = nsc.packages.${system}.nix-software-center // {
          #   meta.description = "A simple gtk4/libadwaita software center to easily install and manage nix packages";
          #   meta.homepage = "https://github.com/snowfallorg/nix-software-center";
          # };

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
      merge = builtins.foldl' recursiveUpdate { };
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

        ci = pkgs.writeShellApplication {
          name = "ci";
          runtimeInputs = with pkgs; [
            cachix
            jq
            nix-eval-jobs
          ];
          text = ''
            nix-eval-jobs                                       \
              --check-cache-status                              \
              --force-recurse                                   \
              --workers "$(nproc)"                              \
              --flake .#packages.${pkgs.system}                 \
            | jq -r 'if .isCached then empty else .drvPath end' \
            | xargs -P "$(nproc)" -I% nix-store --realise %     \
            | cachix push 42loco42
          '';
        };

        nvidia =
          let
            targets = with (import nixpkgs-new { inherit (pkgs) system; }); [
              linuxPackages.nvidiaPackages.stable
              linuxPackages.nvidiaPackages.stable.persistenced
              linuxPackages.nvidiaPackages.stable.settings
              nvtopPackages.nvidia
            ];

            paths = pipe targets [
              (pkgs.linkFarmFromDrvs "nvidia")
              (x: pipe x [
                builtins.readDir
                builtins.attrNames
                (map (n: x + "/" + n))
                (builtins.concatStringsSep " ")
              ])
            ];
          in
          pkgs.writeShellApplication {
            name = "nvidia";
            runtimeInputs = with pkgs; [ cachix ];
            text = ''
              cachix push 42loco42 ${paths}
            '';
          };
      }
    ];
}
