{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        inherit (builtins) elemAt length;
        inherit (pkgs.lib) flip splitString;

        deps = (xs: pkgs.linkFarm "deps" (flip map xs (x:
          let
            parts = splitString "/" x;
            owner = elemAt parts 0;
            repo = elemAt parts 1;
            rev = elemAt parts 2;
            hash = if length parts < 4 then "" else elemAt parts 3;
          in
          {
            name = "${repo}/${rev}";
            path = pkgs.fetchFromGitHub { inherit owner repo rev hash; };
          }))) [
          # put typst packages here e.g. "touying-typ/touying/0.5.5/<hash>"
          # if last part is missing, the hash will be calculated
        ];
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "typst-compile";
          src = ./.;

          nativeBuildInputs = with pkgs; [ typst ];

          buildPhase = ''
            mkdir packages $out
            ln -s ${deps} packages/preview
            export TYPST_PACKAGE_CACHE_PATH="$PWD/packages"

            for i in ./*.typ; do typst compile "$i" "$out/''${i%typ}pdf"; done
          '';
        };
      });
}
