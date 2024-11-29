pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "nvflash";
  version = "5.833.0";

  src = pkgs.fetchzip {
    url = "https://de1-dl.techpowerup.com/files/nvflash_5.833_linux.zip";
    curlOptsList = [ "-H" "user-agent: winget" ];
    hash = "sha256-D9u+ahAz4ye7ybdtciI47uqoNqKGEq9tvPw5cC1c7i0=";
  };

  nativeBuildInputs = with pkgs; [ autoPatchelfHook ];
  buildInputs = with pkgs; [ libgcc ];

  installPhase = "install -Dm755 {,$out/bin/}nvflash";

  meta = {
    description = "NVIDIA NVFlash is used to flash the graphics card BIOS on Ampere, Turing, Pascal and all older NVIDIA cards";
    homepage = "https://www.techpowerup.com/download/nvidia-nvflash";
    mainProgram = pname;
  };
}
