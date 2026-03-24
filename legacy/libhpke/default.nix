pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "hpke";
  version = "0.1-unstable-2023-07-28";

  src = pkgs.fetchFromGitHub {
    owner = "oktaysm";
    repo = pname;
    rev = "4eef470f7f73beac6a2b71aee8621c00f49f6718";
    hash = "sha256-Sd/Ih3EWNEo3JrWejd51b6t/TStK+ZYlSEgAz48Pc5Y=";
  };

  patches = [
    # include stdarg.h src/hpke/hpke.c to fix build
    ./fix-include.patch
  ];

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
  ];

  buildInputs = with pkgs; [
    libressl
  ];

  meta = {
    description = "HPKE implementation in C";
    homepage = "https://github.com/oktaysm/hpke";
    pkgConfigModules = [ "libhpke" ];
  };
}
