{
  description = "A personal collection of unusual things";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, ... }: rec {
    packages = self.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        "9mount" = pkgs.callPackage ./packages/9mount { };
        SwayAudioIdleInhibit = pkgs.callPackage ./packages/SwayAudioIdleInhibit.nix { };
        XWaylandVideoBridge = pkgs.callPackage ./packages/XWaylandVideoBridge.nix { };
        certbot-dns-duckdns = pkgs.callPackage ./packages/certbot-dns-duckdns.nix { };
        msp-cgt = pkgs.callPackage ./packages/msp-cgt.nix { };
        mspgcc-ti = pkgs.callPackage ./packages/mspgcc-ti.nix { };
      }
    );

    nixosModules = {
      "9mount" = import ./packages/9mount/module.nix {
        pkgs9mount = packages."9mount";
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
