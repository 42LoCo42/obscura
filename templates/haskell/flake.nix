{
  description = "Example haskell flake";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
        root = ./.;
      in
      {
        defaultPackage = pkgs.haskellPackages.developPackage {
          inherit root;
        };

        devShell = pkgs.haskellPackages.developPackage {
          inherit root;
          returnShellEnv = true;
          withHoogle = false;
          modifier = drv: pkgs.haskell.lib.addBuildTools drv (with pkgs; [
            bashInteractive
            cabal-install
            ghcid
            haskell-language-server
            hpack
          ]);
        };
      });
}
