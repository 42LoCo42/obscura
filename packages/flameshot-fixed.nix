pkgs: pkgs.stdenv.mkDerivation {
  pname = "flameshot";
  version = "master";

  src = pkgs.fetchFromGitHub {
    owner = "lbatalha";
    repo = "flameshot";
    rev = "84acbdafd0a81839e9e98351eb339bbe1ba1bf54";
    hash = "sha256-O3hvWVyOD+YJU8ZfkcGPRBN2gYOqfS9rixtJyxLA3Tk=";
  };

  nativeBuildInputs = with pkgs; [
    cmake
    libsForQt5.qttools
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = with pkgs.libsForQt5; [
    kguiaddons
    qtbase
  ];

  cmakeFlags = [
    "-DUSE_WAYLAND_CLIPBOARD=true"
    "-DUSE_WAYLAND_GRIM=true"
  ];

  meta = {
    description = "A fork of Flameshot without selection lag, configured to work with Wayland";
    homepage = "https://github.com/lbatalha/flameshot";
  };
}
