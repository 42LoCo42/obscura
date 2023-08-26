{ fetchFromGitHub
, stdenv

, pkg-config

, glfw
, raylib
}: stdenv.mkDerivation rec {
  pname = "musializer";
  version = "be42432";

  src = fetchFromGitHub {
    owner = "tsoding";
    repo = pname;
    rev = version;
    hash = "sha256-1uxsgG8t6WhgkHe2QhdyYeALP2e6+4to7LWu0OK8qmg=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glfw
    raylib
  ];

  patchPhase = ''
    substituteInPlace build.sh \
      --replace clang gcc

    substituteInPlace src/plug.c              \
      --replace                               \
        '"./fonts/Alegreya-Regular.ttf"'      \
        '"${src}/fonts/Alegreya-Regular.ttf"' \
      --replace                               \
        '"./shaders/circle.fs"'               \
        '"${src}/shaders/circle.fs"'          \
      --replace                               \
        '"./shaders/smear.fs"'                \
        '"${src}/shaders/smear.fs"'
  '';

  buildPhase = "./build.sh";

  installPhase = ''
    mkdir $out
    cp -r build $out/bin
  '';

  meta = {
    description = " Music Visualizer";
    homepage = "https://github.com/tsoding/musializer";
  };
}
