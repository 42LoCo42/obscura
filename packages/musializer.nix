{ fetchFromGitHub
, stdenv

, autoPatchelfHook
, makeBinaryWrapper

, libglvnd
, xorg
}: stdenv.mkDerivation rec {
  pname = "musializer";
  version = "d971539";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = pname;
    rev = version;
    hash = "sha256-s2NnoSNNe0iWAPfIgfUNqLp6ArbRHGNsicm/bHE5EPU=";
  };

  nativeBuildInputs = [
    autoPatchelfHook
    makeBinaryWrapper
  ];

  buildInputs = [
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXinerama
    xorg.libXrandr
  ];

  runtimeDependencies = [
    xorg.libX11
    libglvnd
  ];

  buildPhase = ''
    cc -Wall -Wextra nob.c -o nob
    ./nob
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r resources $out
    cp build/musializer $out/bin
    wrapProgram $out/bin/musializer --chdir $out/resources
  '';

  meta = {
    description = " Music Visualizer";
    homepage = "https://github.com/tsoding/musializer";
  };
}
