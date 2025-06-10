pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "liboprf";
  version = "0.6.1-unstable-2025-01-25";

  src = pkgs.fetchFromGitHub {
    owner = "stef";
    repo = pname;
    rev = "0f53529450748753a63cce5405c425a3fa2525f8";
    hash = "sha256-NfTyVKeIc/LtzQpVJNn0AKabyJ2AUG7tJ47xO2Brayk=";
  };

  enableParallelBuilding = true;

  makeFlags = [ "-C src" "PREFIX=$(out)" ];

  buildInputs = with pkgs; [ libsodium ];

  meta = {
    description = "library providing OPRF and Threshold OPRF based on libsodium";
    homepage = "https://github.com/stef/liboprf";
  };
}
