pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "hq";
  version = "3.2";

  src = pkgs.fetchFromGitHub {
    owner = "coderobe";
    repo = pname;
    rev = version;
    hash = "sha256-0ZqIQYi5r4PbMWgxbo6OViNxbsAwyq8XNzrWu42qxB4=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
  ];

  buildInputs = with pkgs; [
    fmt
    modest
  ];

  installPhase = ''
    install -Dm755 {,$out/bin/}${pname}
  '';

  meta = {
    description = "A HTML processor inspired by jq";
    homepage = "https://github.com/coderobe/hq";
    mainProgram = pname;
  };
}
