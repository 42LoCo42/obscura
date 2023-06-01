{
  description = "Example haskell flake";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = (import nixpkgs { inherit system; });
        hpkgs = pkgs.haskellPackages;
      in
      {
        defaultPackage = hpkgs.developPackage {
          root = ./.;
          returnShellEnv = true;
          modifier = drv: pkgs.haskell.lib.addBuildTools drv (with hpkgs; [
            cabal-install
            haskell-language-server
          ]);
        };
      });
}
