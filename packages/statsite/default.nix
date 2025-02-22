pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "statsite";
  version = "bf68fa2";

  src = pkgs.fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
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
    mainProgram = "statsite";
  };
}
