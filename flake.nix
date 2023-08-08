{
  description = "A personal collection of unusual things";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, ... }: {
    packages = self.inputs.flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        SwayAudioIdleInhibit = pkgs.callPackage ./packages/SwayAudioIdleInhibit.nix { };
      }
    );

    templates =
      let
        dir = ./templates;

        mkPair = name: {
          inherit name;
          value = {
            description = "A flake template for ${name}";
            path = ./${dir}/${name};
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
