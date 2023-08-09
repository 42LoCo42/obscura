{ fetchurl
, stdenv
}: stdenv.mkDerivation rec {
  pname = "msp-cgt";
  version = "21.6.1";

  src = fetchurl {
    url = "https://dr-download.ti.com/software-development/ide-configuration-compiler-or-debugger/MD-p4jWEYpR8n/21.6.1.LTS/ti_cgt_msp430_21.6.1.LTS_linux-x64_installer.bin";
    hash = "sha256-Ja/V3T1MxWDR76UcLUkqUIVIgt42YDejIpHbEfHFd94=";
  };
  dontUnpack = true;

  patchPhase = ''
    cp ${src} installer
    chmod 755 installer
    patchelf --set-interpreter "$(< "$NIX_CC/nix-support/dynamic-linker")" installer
  '';

  installPhase = ''
    ./installer --mode unattended --prefix $out
    dir="$(echo "$out/"*)"
    mv "$dir/"* "$out/"
    rmdir "$dir"
    rm "$out/"*"_uninstaller."{dat,run}
  '';

  meta = {
    description = "MSP430 code generation tools";
    homepage = "https://www.ti.com/tool/MSP-CGT";
  };
}
