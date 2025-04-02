{ pkgs, python }: python.pkgs.buildPythonPackage rec {
  pname = "climlab-cam3-radiation";
  version = "0.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "climlab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+ek0sgkmewqWZAFls9WVgtQC78iFVfJfs1nOLU+EdZw=";
  };

  pyproject = true;

  nativeBuildInputs = with pkgs; [
    gfortran
  ];

  build-system = with python.pkgs; [
    meson-python
  ];

  dependencies = with python.pkgs; [
    numpy
    pooch
    scipy
    xarray
  ];

  meta = {
    description = "A stand-alone Python wrapper for the NCAR CAM3 radiation scheme";
    homepage = "https://github.com/climlab/climlab-cam3-radiation";
  };
}
