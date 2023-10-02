{
  description = "A personal collection of unusual things";

  inputs.argon-kg.url = "github:42loco42/argon-kg";
  inputs.argon-kg.inputs.nixpkgs.follows = "nixpkgs";
  inputs.argon-kg.inputs.flake-utils.follows = "flake-utils";

  inputs.nimble.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, nimble, flake-utils, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      nimblePkgs = nimble.packages.${system};
    in
    {
      packages.${system} = rec {
        "9mount" = pkgs.callPackage ./packages/9mount { };
        SwayAudioIdleInhibit = pkgs.callPackage ./packages/SwayAudioIdleInhibit.nix { };
        XWaylandVideoBridge = pkgs.callPackage ./packages/XWaylandVideoBridge.nix { };
        argon-kg = self.inputs.argon-kg.outputs.defaultPackage.${system};
        boomer = pkgs.callPackage ./packages/boomer.nix { inherit nimblePkgs; };
        certbot-dns-duckdns = pkgs.callPackage ./packages/certbot-dns-duckdns.nix { };
        flameshot-fixed = pkgs.callPackage ./packages/flameshot-fixed.nix { };
        fusepod = pkgs.callPackage ./packages/fusepod.nix { };
        gtk4-layer-shell = pkgs.callPackage ./packages/gtk4-layer-shell.nix { };
        k0s-bin = pkgs.callPackage ./packages/k0s-bin.nix { };
        m9u = pkgs.callPackage ./packages/m9u.nix { };
        msp-cgt = pkgs.callPackage ./packages/msp-cgt.nix { };
        mspgcc-ti = pkgs.callPackage ./packages/mspgcc-ti.nix { };
        musializer = pkgs.callPackage ./packages/musializer.nix { };
        samloader = pkgs.callPackage ./packages/samloader.nix { };
        vulnix = pkgs.callPackage ./packages/vulnix.nix { };
        wayland-shell = pkgs.callPackage ./packages/wayland-shell.nix {
          inherit gtk4-layer-shell;
        };
      };

      nixosModules = {
        "9mount" = import ./packages/9mount/module.nix {
          packages = self.outputs.packages;
        };
      };

      templates =
        let
          dir = "${self}/templates";

          mkPair = name: {
            inherit name;
            value = {
              description = "A flake template for ${name}";
              path = "${dir}/${name}";
            };
          };

          subdirs = builtins.readDir dir;
          names = builtins.attrNames subdirs;
          pairs = builtins.map mkPair names;
          result = builtins.listToAttrs pairs;
        in
        result;
    };
}
