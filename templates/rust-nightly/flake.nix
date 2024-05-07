{
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";
  inputs.rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  inputs.rust-overlay.inputs.flake-utils.follows = "flake-utils";

  outputs = { flake-utils, nixpkgs, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs { inherit system overlays; };
        toml = builtins.fromTOML (builtins.readFile ./Cargo.toml);
        rustToolchain = pkgs.rust-bin.selectLatestNightlyWith (t: t.default);
        rustPlatform = pkgs.makeRustPlatform {
          rustc = rustToolchain;
          cargo = rustToolchain;
        };
      in
      rec {
        packages.default = rustPlatform.buildRustPackage {
          pname = toml.package.name;
          version = toml.package.version;
          src = ./.;
          cargoLock.lockFile = ./Cargo.lock;
        };

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = with pkgs; [
            rust-analyzer
            rustToolchain
          ];
        };
      });
}
