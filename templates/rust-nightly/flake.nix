{
  inputs = {
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { flake-utils, nixpkgs, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ (import rust-overlay) ];
        };

        rustToolchain = pkgs.rust-bin.selectLatestNightlyWith (t: t.default);

        cargoNix = import ./Cargo.nix {
          inherit pkgs;

          buildRustCrateForPkgs = _: args: pkgs.buildRustCrate (args // {
            rustc = rustToolchain;
            cargo = rustToolchain;

            extraRustcOpts = args.extraRustcOpts ++
              [ "-C" "link-arg=-fuse-ld=mold" ];

            nativeBuildInputs = with pkgs; [ mold ];
          });
        };
      in
      rec {
        packages.default = cargoNix.rootCrate.build;

        devShells.default = pkgs.mkShell {
          inputsFrom = [ packages.default ];
          packages = [
            rustToolchain
          ];
        };
      });
}
