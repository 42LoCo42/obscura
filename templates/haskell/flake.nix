{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        root = ./.;
      in
      {
        packages.default = pkgs.haskellPackages.developPackage {
          inherit root;
        };

        devShells.default = pkgs.haskellPackages.developPackage {
          inherit root;
          returnShellEnv = true;
          withHoogle = false;
          modifier = drv: pkgs.haskell.lib.addBuildTools drv (with pkgs; [
            cabal-install
            ghcid
            haskell-language-server
            hpack
          ]);
        };
      });
}
