pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "comskip";
  version = "0.83-unstable-2024-06-07";

  src = pkgs.fetchFromGitHub {
    owner = "erikkaashoek";
    repo = pname;
    rev = "2ef86841cd84df66fe0e674f300ee49cef6e097a";
    hash = "sha256-4ef/YZpaiSp3VeSiU6mRR38GjkrzxboI0/VXQ5QQiUM=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
  ];

  buildInputs = with pkgs; [
    argtable2
    ffmpeg_6-headless
  ];

  enableParallelBuilding = true;

  meta = {
    description = "A free commercial detector";
    homepage = "https://github.com/erikkaashoek/Comskip";
    mainProgram = pname;
  };
}
