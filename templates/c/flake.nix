{
  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; }; in rec {
        defaultPackage = pkgs.stdenv.mkDerivation {
          pname = "example";
          version = "0.0.1";
          src = ./.;

          nativeBuildInputs = with pkgs; [
            pkg-config
          ];
        };

        devShell = pkgs.mkShell {
          inputsFrom = [ defaultPackage ];
          packages = with pkgs; [
            bear
            clang-tools
          ];
        };
      });
}
