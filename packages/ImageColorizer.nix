pkgs:
let py = pkgs.python3Packages; in
py.buildPythonPackage rec {
  pname = "ImageColorizer";
  version = "2021-10-31";

  src = pkgs.fetchFromGitHub {
    owner = "kiddae";
    repo = pname;
    rev = "48623031e3106261093723cd536a4dae74309c5d";
    hash = "sha256-ucwo5DOMUON9HgQzXmh39RLQH4sWtSfYH7+UWfGIJCo=";
  };

  pyproject = true;

  build-system = with py; [
    setuptools
  ];

  dependencies = with py; [
    pillow
  ];

  meta = {
    description = "Make any wallpaper fit any terminal colorscheme";
    homepage = "https://github.com/kiddae/ImageColorizer";
    mainProgram = pname;
  };
}
