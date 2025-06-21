pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "statsite";
  version = "0.8.0-unstable-2019-10-22";

  src = pkgs.fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "bf68fa2d3d107edcface16571e90ce71d3ede0f8";
    hash = "sha256-Qnc4ml+/GDeyj0IckKWmrYGhfe4OLwRBSBPi73UzoZk=";
  };

  patches = [
    # don't hardcode paths to configdir (would be created during install) or gcc
    ./nix.patch
  ];

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
  ];

  enableParallelBuilding = true;

  meta = {
    description = "C implementation of statsd";
    homepage = "https://github.com/statsite/statsite";
    mainProgram = pname;
  };
}
