pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "mwxml2sql";
  version = "2017-11-02";

  src = pkgs.fetchgit {
    url = "https://gerrit.wikimedia.org/r/operations/dumps/import-tools";
    rev = "2e3e5ec62e22bba7e7599512019d44dd4e8d005a";
    hash = "sha256-EL1rAfJXg0bqKiCefxjbUlZUgfYMPydGp3cCQ4qzJe8=";
  };

  patches = [
    ./0001-Makefile-remove-hardcoded-tool-paths.patch
    ./0002-Makefile-dont-install-into-usr.patch
  ];

  makeFlags = [
    "--directory=xmlfileutils"
    "PREFIX=$(out)"
  ];

  nativeBuildInputs = with pkgs; [
    help2man
  ];

  buildInputs = with pkgs; [
    bzip2
    libz
  ];

  meta = {
    description = "Convert Mediawiki XML dumps to SQL";
    homepage = "https://gerrit.wikimedia.org/g/operations/dumps/import-tools";
    mainProgram = pname;
  };
}
