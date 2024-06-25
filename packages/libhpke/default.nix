pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "hpke";
  version = "4eef470";

  src = pkgs.fetchFromGitHub {
    owner = "oktaysm";
    repo = pname;
    rev = version;
    hash = "sha256-Sd/Ih3EWNEo3JrWejd51b6t/TStK+ZYlSEgAz48Pc5Y=";
  };

  patches = [ ./fix-include.patch ];

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
