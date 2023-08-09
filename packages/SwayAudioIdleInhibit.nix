{ fetchFromGitHub
, stdenv

, meson
, ninja
, pkg-config

, libpulseaudio
, wayland
, wayland-protocols
}: stdenv.mkDerivation rec {
  pname = "SwayAudioIdleInhibit";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "v${version}";
    hash = "sha256-XUUUUeaXO7GApwe5vA/zxBrR1iCKvkQ/PMGelNXapbA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libpulseaudio
    wayland
    wayland-protocols
  ];

  meta = {
    description = "Prevent swayidle from sleeping while any application is outputting or receiving audio";
    homepage = "https://github.com/ErikReider/SwayAudioIdleInhibit";
    mainProgram = "sway-audio-idle-inhibit";
  };
}
