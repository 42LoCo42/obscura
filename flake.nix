{
  description = "A personal collection of unusual things";

  inputs.argon-kg.url = "github:42loco42/argon-kg";
  inputs.argon-kg.inputs.nixpkgs.follows = "nixpkgs";
  inputs.argon-kg.inputs.flake-utils.follows = "flake-utils";

  # inputs.nimble.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # nimblePkgs = self.inputs.nimble.packages.${system};
    in
    {
      packages.${system} = rec {
        # boomer = pkgs.callPackage ./packages/boomer.nix { inherit nimblePkgs; };
        # certbot-dns-duckdns = pkgs.callPackage ./packages/certbot-dns-duckdns.nix { };
        # musializer = pkgs.callPackage ./packages/musializer.nix { };
        # vulnix = pkgs.callPackage ./packages/vulnix.nix { };

        "9mount" = pkgs.callPackage ./packages/9mount { };
        SwayAudioIdleInhibit = pkgs.callPackage ./packages/SwayAudioIdleInhibit.nix { };
        XWaylandVideoBridge = pkgs.callPackage ./packages/XWaylandVideoBridge.nix { };
        argon-kg = self.inputs.argon-kg.outputs.defaultPackage.${system};
        capnp-go = pkgs.callPackage ./packages/capnp-go.nix { };
        e2eirc = pkgs.callPackage ./packages/e2eirc.nix { };
        flameshot-fixed = pkgs.callPackage ./packages/flameshot-fixed.nix { };
        foot-transparent = pkgs.callPackage ./packages/foot-transparent.nix { };
        fusepod = pkgs.callPackage ./packages/fusepod.nix { };
        gtk4-layer-shell = pkgs.callPackage ./packages/gtk4-layer-shell.nix { };
        k0s-bin = pkgs.callPackage ./packages/k0s-bin.nix { };
        libhpke = pkgs.callPackage ./packages/libhpke.nix { };
        m9u = pkgs.callPackage ./packages/m9u.nix { };
        msp-cgt = pkgs.callPackage ./packages/msp-cgt.nix { };
        mspgcc-ti = pkgs.callPackage ./packages/mspgcc-ti.nix { };
        prettier-plugin-go-template = pkgs.callPackage ./packages/prettier-plugin-go-template.nix { };
        redis-json = pkgs.callPackage ./packages/redis-json.nix { };
        samloader = pkgs.callPackage ./packages/samloader.nix { };
        wayland-shell = pkgs.callPackage ./packages/wayland-shell.nix { inherit gtk4-layer-shell; };
      };

      nixosModules = {
        "9mount" = import ./packages/9mount/module.nix {
          packages = self.outputs.packages;
        };
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
    };
}
