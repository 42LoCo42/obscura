{ fetchFromGitHub
, stdenv

, meson
, ninja
, pkg-config

, libpulseaudio
, wayland
, wayland-protocols
}: stdenv.mkDerivation {
  pname = "SwayAudioIdleInhibit";
  version = "master";

  src = fetchFromGitHub {
    owner = "ErikReider";
    repo = "SwayAudioIdleInhibit";
    rev = "c850bc4812216d03e05083c69aa05326a7fab9c7";
    hash = "sha256-MKzyF5xY0uJ/UWewr8VFrK0y7ekvcWpMv/u9CHG14gs=";
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
