{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        python = pkgs.python3;
        pyenv = python.withPackages (p: with p; [
        ]);
      in
      rec {
        packages.default = python.pkgs.buildPythonApplication {
          pname = "example";
          version = "1";
          src = ./.;
          buildInputs = [
            pyenv
          ];
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; with python.pkgs; [
            black
            ipython
            python-lsp-server
          ];
        };
      });
}
