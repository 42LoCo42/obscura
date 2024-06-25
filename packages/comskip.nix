pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "comskip";
  version = "2ef8684";

  src = pkgs.fetchFromGitHub {
    owner = "erikkaashoek";
    repo = pname;
    rev = version;
    hash = "sha256-4ef/YZpaiSp3VeSiU6mRR38GjkrzxboI0/VXQ5QQiUM=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
  ];

  buildInputs = with pkgs; [
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
