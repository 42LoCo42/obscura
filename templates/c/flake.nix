{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (pkgs.lib.fileset) toSource unions;
        stdenv = pkgs.gccStdenv; # pkgs.clangStdenv;
      in
      rec {
        packages.default = stdenv.mkDerivation {
          pname = "example";
          version = "0.0.1";

          src = toSource {
            root = ./.;
            fileset = unions [
              ./meson.build
              ./src
            ];
          };

          nativeBuildInputs = with pkgs; [
            meson
            ninja
          ];

          buildInputs = with pkgs; [
          ];

          mesonBuildType = "release";
          mesonFlags = [ "--werror" ];
        };

        devShells.default = (pkgs.mkShell.override {
          inherit stdenv;
        }) {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            clang-tools
            just
          ];
        };
      });
}
