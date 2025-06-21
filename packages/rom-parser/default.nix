pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "rom-parser";
  version = "0-unstable-2017-03-31";

  src = pkgs.fetchFromGitHub {
    owner = "awilliam";
    repo = pname;
    rev = "94a615302f89b94e70446270197e0f5138d678f3";
    hash = "sha256-SSG959zEgFzQpGqMZsX3KXrGKUt7AaSqk2/pux8By+4=";
  };

  installPhase = ''
    for i in rom-parser rom-fixer; do
      install -Dm755 $i $out/bin/$i
    done
  '';

  meta = {
    description = "Parse & change GPU VBIOS files";
    homepage = "https://github.com/awilliam/rom-parser";
    mainProgram = pname;
  };
}
