{ fetchFromGitHub, stdenv, pkg-config, openssl }:
stdenv.mkDerivation rec {
  pname = "sae_pk_gen";
  version = "72e2975";

  src = fetchFromGitHub {
    owner = "vanhoefm";
    repo = "hostap-wpa3";
    rev = version;
    hash = "sha256-zveLNcZN7+L1iw3i9tq8fOgCh7VdMTg8B2PEoJ2fGwQ=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

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
