{ pkgs, python }: python.pkgs.buildPythonPackage rec {
  pname = "climlab-emanuel-convection";
  version = "0.3-unstable-2024-11-15";

  src = pkgs.fetchFromGitHub {
    owner = "climlab";
    repo = pname;
    rev = "902fee7300902a67e6fba511bf702bbcbe0dc347";
    hash = "sha256-4YtFGU66cNBWcXDW+EJL5VJL/wzpAtDAh1BjpHnYrVM=";
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
  ];

  meta = {
    description = "A stand-alone Python wrapper for the Emanuel convection scheme";
    homepage = "https://github.com/climlab/climlab-emanuel-convection";
  };
}
