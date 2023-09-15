{
  description = "Example Rust flake";

  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  inputs.rust-overlay.inputs.flake-utils.follows = "flake-utils";

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import self.inputs.rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        rustToolchain = pkgs.rust-bin.selectLatestNightlyWith (t: t.default);
        rustPlatform = pkgs.makeRustPlatform {
          rustc = rustToolchain;
          cargo = rustToolchain;
        };
      in
      rec {
        defaultPackage = rustPlatform.buildRustPackage {
          pname = toml.package.name;
          version = toml.package.version;
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        devShell = pkgs.mkShell {
          inputsFrom = [ defaultPackage ];
          packages = with pkgs; [
            bashInteractive
            rust-analyzer
            rustToolchain
          ];
        };
      });
}
