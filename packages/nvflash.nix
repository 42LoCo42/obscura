pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "nvflash";
  version = "5.833.0";

  src = (pkgs.runCommand "nvflash" {
    nativeBuildInputs = with pkgs; [ curl ];
    outputHashAlgo = "sha256";
    outputHash = "sha256-0fgLsOXFOrszkbV52zOGHkMxkg4NfYOfWbpk8DHBIcM=";
  }) ''
    export SSL_CERT_FILE="${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
    curl https://de1-dl.techpowerup.com/files/nvflash_5.833_linux.zip \
      -H "user-agent: winget" | zcat > $out
  '';
  dontUnpack = true;

  nativeBuildInputs = with pkgs; [ autoPatchelfHook ];
  buildInputs = with pkgs; [ libgcc ];

  installPhase = "install -Dm755 $src $out/bin/nvflash";

  meta = {
    description = "NVIDIA NVFlash is used to flash the graphics card BIOS on Ampere, Turing, Pascal and all older NVIDIA cards";
    homepage = "https://www.techpowerup.com/download/nvidia-nvflash";
    mainProgram = pname;
  };
}
