pkgs:
let
  python = pkgs.python312;
  tools = { inherit pkgs python; };
in
python.pkgs.buildPythonPackage rec {
  pname = "climlab";
  version = "0.9.1";

  src = pkgs.fetchFromGitHub {
    owner = "climlab";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-xN3VZTuIMqCB/5wprlMpkIB5WSafO3MbkpXoQItG2+w=";
  };

  pyproject = true;

  build-system = with python.pkgs; [
    setuptools
  ];

  dependencies = with python.pkgs; [
    numpy

    (import ./cam3-radiation.nix tools)
    (import ./emanuel-convection.nix tools)
    (import ./rrtmg.nix tools)
    (import ./sbm-convection.nix tools)
  ];

  meta = {
    description = "Python package for process-oriented climate modeling";
    homepage = "https://github.com/climlab/climlab";
  };
}
