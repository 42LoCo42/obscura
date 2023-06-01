{
  description = "A personal collection of unusual things";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, ... }: {
    packages = let
      dir = ./packages;
      # TODO
      result = {};
    in result;

    templates = let
      dir    = ./templates;

      mkPair = name: {
        inherit name;
        value = {
          description = "A flake template for ${name}";
          path = ./${dir}/${name};
        };
      };

      subdirs = builtins.readDir dir;
      names   = builtins.attrNames subdirs;
      pairs   = builtins.map mkPair names;
      result  = builtins.listToAttrs pairs;
    in result;
  };
}
