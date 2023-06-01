{
  description = "Example python flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python311;
        pyenv = python.withPackages (ps: with ps; [
          # put your python packages here
        ]);
      in
      {
        defaultPackage = python.pkgs.buildPythonApplication {
          pname = "example";
          version = "1";
          src = ./.;
          buildInputs = [
            pyenv
          ];
        };
      });
}
