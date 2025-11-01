pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "lone";
  version = "0-unstable-2024-12-26";

  src = pkgs.fetchFromGitHub {
    owner = "lone-lang";
    repo = pname;
    rev = "27f9e5c9dd2915feb316b1a7738b51170485175f";
    hash = "sha256-rIsAGrRSZ6iBAjrmFi0II8LTgT3uF0rRjEVkQ17G4do=";
  };

  enableParallelBuilding = true;

  patchPhase = "patchShebangs scripts";
  buildPhase = "make all";

  installPhase = ''
    mkdir -p $out/bin
    cp build/${pkgs.stdenv.hostPlatform.uname.processor}/{lone,tools/lone-embed} $out/bin
  '';

  meta = {
    description = "The standalone Linux Lisp";
    homepage = "https://github.com/lone-lang/lone";
    mainProgram = pname;
  };
}
