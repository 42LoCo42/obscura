pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "modest";
  version = "0.0.6-unstable-2021-08-03";

  src = pkgs.fetchFromGitHub {
    owner = "lexborisov";
    repo = pname;
    rev = "2540a03259fc62fe15f47e85c20b2eedd5af66de";
    hash = "sha256-o3asVErtc9CYRb3ZZFE5DYyT/Pjr7TZ79BLPnh6CCT0=";
  };

  enableParallelBuilding = true;
  makeFlags = [ "prefix=$(out)" ];

  meta = {
    description = "A fast HTML renderer implemented as a pure C99 library with no outside dependencies";
    homepage = "https://github.com/lexborisov/Modest";
  };
}
