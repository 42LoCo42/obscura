{ fetchurl
, stdenv
}: stdenv.mkDerivation rec {
  pname = "9mount";
  version = "1.3";

  src = fetchurl {
    url = "http://sqweek.net/9p/9mount-${version}.tar.gz";
    hash = "sha256-gg2AubR40F7LAirWWEd7N8/CQUqGacOvF9GSpSIGTBc=";
  };

  patches = [ ./unpriv.patch ];
  installPhase = "make prefix=$out install";
}
