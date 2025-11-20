{
  outputs = { flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        typst-env = pkgs.typst.withPackages (p: with p; [
          codly
          codly-languages

          (pkgs.buildTypstPackage rec {
            pname = "iu";
            version = "1.0.0";

            src = pkgs.fetchFromGitHub {
              owner = "42LoCo42";
              repo = "typkg";
              rev = "eka/atoms/${pname}/${version}";
              hash = "sha256-5NSxN3sU8o/Gv8axohrZcSfcn4w9C1yWwiAftOufEBI=";
            };
          })
        ]);
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "pdf";
          src = ./.;

          env = {
            SOURCE_DATE_EPOCH = 1742943600 + 3600; # 2025-03-26
            TYPST_PACKAGE_CACHE_PATH = "${typst-env}/lib/typst/packages";
            TYPST_FONT_PATHS = builtins.concatStringsSep ":" (with pkgs; [
              liberation_ttf
            ]);
          };

          nativeBuildInputs = with pkgs; [
            typst-env
          ];

          installPhase = ''
            mkdir $out
            for i in ./*.typ; do
              typst compile "$i" "$out/''${i%typ}pdf"
            done
          '';
        };
      });
}
