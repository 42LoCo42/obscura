pkgs: pkgs.gcc14Stdenv.mkDerivation rec {
  pname = "m9u";
  version = "0-unstable-2021-09-12";

  src = pkgs.fetchFromGitHub {
    owner = "sqweek";
    repo = pname;
    rev = "36493de8237856855f3ebf7678e6168fb55f495d";
    hash = "sha256-TKV8lgGttCMCfTiMPb90kWJ57vr8VkNVEzy6pMx3yXk=";
  };

  enableParallelBuilding = true;

  buildInputs = with pkgs; [
    libixp
  ];

  installPhase = "make prefix=$out install";

  meta = {
    description = "A 9P music server";
    homepage = "https://sqweek.net/code/m9u/";
    mainProgram = pname;
  };
}
