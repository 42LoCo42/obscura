{ argtable2
, autoreconfHook
, fetchFromGitHub
, ffmpeg-headless
, pkg-config
, stdenv
}: stdenv.mkDerivation rec {
  pname = "comskip";
  version = "2ef8684";

  src = fetchFromGitHub {
    owner = "erikkaashoek";
    repo = pname;
    rev = version;
    hash = "sha256-4ef/YZpaiSp3VeSiU6mRR38GjkrzxboI0/VXQ5QQiUM=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    argtable2
    ffmpeg-headless
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A free commercial detector";
    homepage = "https://github.com/erikkaashoek/Comskip";
    mainProgram = "comskip";
  };
}
