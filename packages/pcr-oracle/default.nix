pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "pcr-oracle";
  version = "0.5.4";

  src = pkgs.fetchFromGitHub {
    owner = "okirch";
    repo = pname;
    rev = version;
    hash = "sha256-RcKxpmXWv/XJTVauDuykjIvUOO5TwqsKEqykEO6b3pk=";
  };
  patches = [
    # use json-c instead of ambiguous "json" library
    # specify man directory
    # don't crash on unknown distro
    # obtain CPU arch from uname -m
    ./fix.patch
  ];

  nativeBuildInputs = with pkgs; [
    getopt
    pkg-config
  ];

  buildInputs = with pkgs; [
    json_c
    openssl
    tpm2-tss
  ];

  makeFlags = [ "DESTDIR=$(out)" ];
  enableParallelBuilding = true;

  meta = {
    description = "Predict TPM PCR values for future boot";
    homepage = "https://github.com/okirch/pcr-oracle";
    mainProgram = pname;
  };
}
