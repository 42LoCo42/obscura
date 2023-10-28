{ fetchFromGitHub
, stdenv

, meson
, ninja
, pkg-config

, libressl
}: stdenv.mkDerivation rec {
  pname = "hpke";
  version = "4eef470";

  src = fetchFromGitHub {
    owner = "oktaysm";
    repo = pname;
    rev = version;
    hash = "sha256-Sd/Ih3EWNEo3JrWejd51b6t/TStK+ZYlSEgAz48Pc5Y=";
  };

  patches = [ ./libhpke.patch ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libressl
  ];

  meta = {
    description = "HPKE implementation in C";
    homepage = "https://github.com/oktaysm/hpke";
    pkgConfigModules = [ "libhpke" ];
  };
}
