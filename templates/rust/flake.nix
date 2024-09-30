{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        cargoNix = import ./Cargo.nix {
          inherit pkgs;

          buildRustCrateForPkgs = _: args: pkgs.buildRustCrate (args // {
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
        };
      });
}
