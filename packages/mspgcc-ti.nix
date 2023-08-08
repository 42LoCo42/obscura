{ fetchzip
, stdenv
}:
let
  baseURL = "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-LlCjWuAbzH/9.3.1.2";
in
stdenv.mkDerivation {
  pname = "mspgcc-ti";
  version = "9.3.1.11";

  srcs = [
    (fetchzip {
      name = "toolchain";
      url = "${baseURL}/msp430-gcc-9.3.1.11_linux64.tar.bz2";
      hash = "sha256-wq81AtUoFx34VtvfaJM7Y3vIwQmJg08uGjpSmloL28k=";
    })
    (fetchzip {
      name = "headers";
      url = "${baseURL}/msp430-gcc-support-files-1.212.zip";
      hash = "sha256-/M7g7wP+c2ul+qQ1WCp3sDPc8veSZlhyX5KAW3AyK20=";
    })
  ];
  sourceRoot = ".";

  installPhase = ''
    mkdir $out
    cp -ar toolchain/* headers/* $out/
    mv $out/include/*.ld $out/msp430-elf/lib/
  '';
}
