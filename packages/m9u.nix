{ fetchgit
, stdenv

, libixp
}: stdenv.mkDerivation rec {
  pname = "m9u";
  version = "36493de";

  # src = fetchFromGitHub {
  #   owner = "sqweek";
  #   repo = pname;
  #   rev = version;
  #   hash = null;
  # };

  src = fetchgit {
    url = "https://github.com/sqweek/m9u/";
    rev = version;
    hash = "sha256-TKV8lgGttCMCfTiMPb90kWJ57vr8VkNVEzy6pMx3yXk=";
  };

  buildInputs = [
    libixp
  ];

  installPhase = "make prefix=$out install";

  meta = {
    description = "A 9P music server";
    homepage = "https://sqweek.net/code/m9u/";
  };
}
