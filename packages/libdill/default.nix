pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "libdill";
  version = "2.14-unstable-2022-08-10";

  src = pkgs.fetchFromGitHub {
    owner = "sustrik";
    repo = pname;
    rev = "32d0e8b733416208e0412a56490332772bc5c6e1";
    hash = "sha256-K/p6SDItGM5bI0f35/Wgh9UYlixr47Xuu51z9uhMEVA=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
    pkg-config
  ];

  buildInputs = with pkgs; [
    openssl
  ];

  configureFlags = [
    "--enable-static"
    "--enable-tls"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Structured concurrency in C";
    homepage = "https://sustrik.github.io/libdill";
  };
}
