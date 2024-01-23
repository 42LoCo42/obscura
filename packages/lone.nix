{ fetchFromGitHub
, stdenv

, clang
, mold
}: stdenv.mkDerivation rec {
  pname = "lone";
  version = "fca96b0";

  src = fetchFromGitHub {
    owner = "lone-lang";
    repo = pname;
    rev = version;
    hash = "sha256-RdWDxPMQ4A6fO3DRDL7Z21NkXxdXf/dkaJsHEoR1LSM=";
  };
  patches = [ ./lone.patch ];

  buildPhase = ''
    make                                                       \
      CC="${clang}/bin/clang"                                  \
      LD="${mold}/bin/mold"                                    \
      CFLAGS="-fstack-protector -Wl,--spare-program-headers,2" \
      lone
    make tools
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/x86_64/{lone,tools/lone-embed} $out/bin
  '';
}
