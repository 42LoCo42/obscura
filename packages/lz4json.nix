pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "lz4json";
  version = "c44c510";

  src = pkgs.fetchFromGitHub {
    owner = "andikleen";
    repo = pname;
    rev = version;
    hash = "sha256-rLjJ7qy7Tx0htW1VxrfCCqVbC6jNCr9H2vdDAfosxCA=";
  };

  nativeBuildInputs = with pkgs; [
    installShellFiles
    pkg-config
  ];

  buildInputs = with pkgs; [
    lz4
  ];

  installPhase = ''
    install -Dm555 lz4jsoncat $out/bin/lz4jsoncat
    installManPage lz4jsoncat.1
  '';

  meta = {
    description = "C decompress tool for mozilla lz4json format";
    homepage = "https://github.com/andikleen/lz4json";
    mainProgram = "lz4jsoncat";
  };
}
