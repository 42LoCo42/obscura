pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "eepers";
  version = "1.3-unstable-2024-05-26";

  src = pkgs.fetchFromGitHub {
    owner = "tsoding";
    repo = pname;
    rev = "90a6ff6644cbc507588f193a7a7d8300da06e6fa";
    hash = "sha256-mijoNPm7A4bvNiNyl7Ydn/WMdnRm/kCeLhDpIagwp14=";
  };

  nativeBuildInputs = with pkgs; [
    gnat-bootstrap14 # regular gnat fails on aarch64
  ];

  buildInputs = with pkgs; [
    raylib
  ];

  buildPhase = ''
    gnatmake                      \
      -Wall -Wextra -O3 -gnat2012 \
      -o eepers eepers.adb        \
      -largs -lraylib -lm
  '';

  installPhase = ''
    install -Dm555 eepers $out/bin/${pname}
    cp -r assets $out/bin/assets
  '';

  meta = {
    description = "Simple Turn-based Game";
    homepage = "https://github.com/tsoding/eepers";
    mainProgram = pname;
  };
}
