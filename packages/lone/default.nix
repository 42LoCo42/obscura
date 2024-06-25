pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "lone";
  version = "fca96b0";

  src = pkgs.fetchFromGitHub {
    owner = "lone-lang";
    repo = pname;
    rev = version;
    hash = "sha256-RdWDxPMQ4A6fO3DRDL7Z21NkXxdXf/dkaJsHEoR1LSM=";
  };
  patches = [ ./shebang.patch ];

  buildPhase = ''
    make                                                       \
      CC="${pkgs.clang}/bin/clang"                                  \
      LD="${pkgs.mold}/bin/mold"                                    \
      CFLAGS="-fstack-protector -Wl,--spare-program-headers,2" \
      lone
    make tools
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp build/x86_64/{lone,tools/lone-embed} $out/bin
  '';

  meta = {
    description = "The standalone Linux Lisp";
    homepage = "https://github.com/lone-lang/lone";
  };
}
