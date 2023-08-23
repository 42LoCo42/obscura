{ fetchFromGitHub
, nimPackages
, nimblePkgs

, xorg
}: nimPackages.buildNimPackage rec {
  pname = "boomer";
  version = "fa6660f";
  src = fetchFromGitHub {
    owner = "tsoding";
    repo = pname;
    rev = version;
    hash = "sha256-lm1rHa7y7XZ055TBJxg2UXswJeG9q1JfEAWcEvuZVYQ=";
  };

  buildInputs = [
    nimblePkgs.opengl
    nimblePkgs.x11
    xorg.libX11
    xorg.libXrandr
  ];

  meta = {
    description = "Zoomer application for Linux";
    homepage = "https://github.com/tsoding/boomer";
  };
}
