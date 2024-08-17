pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "pcr-oracle";
  version = "0.5.4";

  src = pkgs.fetchFromGitHub {
    owner = "okirch";
    repo = pname;
    rev = version;
    hash = "sha256-RcKxpmXWv/XJTVauDuykjIvUOO5TwqsKEqykEO6b3pk=";
  };
  patches = [ ./fix.patch ];

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
