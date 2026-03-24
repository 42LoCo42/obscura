pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "nchess";
  version = "0.0";

  src = pkgs.fetchFromGitHub {
    owner = "spinojara";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-9YdpJ2A9yrYp6X0AXtWWzXsnz8X8Tj7BUxg5CRPeopw=";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ ncurses ];

  makeFlags = [ "BINDIR=$(out)/bin" ];

  meta = {
    description = "A curses based, UCI compatible, chess gui";
    homepage = "https://github.com/spinojara/nchess";
    mainProgram = pname;
  };
}
