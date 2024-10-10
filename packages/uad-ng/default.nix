pkgs: pkgs.universal-android-debloater.overrideAttrs (old: rec {
  version = "1.1.0";

  src = pkgs.fetchFromGitHub {
    inherit (old.src) owner repo;
    rev = "v${version}";
    hash = "sha256-o54gwFl2x0/nE1hiE5F8D18vQSNCKU9Oxiq8RA+yOoE=";
  };
  patches = [ ./remove-nightly.patch ];

  cargoDeps = pkgs.rustPlatform.fetchCargoTarball {
    inherit src;
    hash = "sha256-EmUiyqczVuajGxoNnhXY5p/El/54z2zjyPrI58yL/zE=";
  };

  inherit (old) meta;
})
