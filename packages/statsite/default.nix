{ autoreconfHook
, fetchFromGitHub
, pkg-config
, stdenv
}: stdenv.mkDerivation rec {
  pname = "statsite";
  version = "bf68fa2";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    hash = "sha256-Qnc4ml+/GDeyj0IckKWmrYGhfe4OLwRBSBPi73UzoZk=";
  };
  patches = [ ./nix.patch ];

  nativeBuildInputs = [
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
