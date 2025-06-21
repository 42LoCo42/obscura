pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "sae_pk_gen";
  version = "0-unstable-2022-07-17";

  src = pkgs.fetchFromGitHub {
    owner = "vanhoefm";
    repo = "hostap-wpa3";
    rev = "72e297507b896702e6635540f5b241ec5e02ed06";
    hash = "sha256-zveLNcZN7+L1iw3i9tq8fOgCh7VdMTg8B2PEoJ2fGwQ=";
  };

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ openssl ];

  buildPhase = ''
    cd hostapd
    cp defconfig .config
    make -j $(nproc) ${pname}
  '';

  installPhase = ''
    install -Dm755 ${pname} $out/bin/${pname}
  '';

  meta = {
    mainProgram = pname;
    description = "SAE-PK key generator";
    homepage = "https://github.com/vanhoefm/hostap-wpa3";
  };
}
