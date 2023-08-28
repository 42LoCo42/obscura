{
  description = "Example Rust flake";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
      in
      rec {
        defaultPackage = pkgs.rustPlatform.buildRustPackage {
          pname = toml.package.name;
          version = toml.package.version;
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        devShell = pkgs.mkShell {
          inputsFrom = [ defaultPackage ];
          packages = with pkgs; [
            bashInteractive
            clippy
            rust-analyzer
            rustfmt
          ];
        };
      });
}
