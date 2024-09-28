pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "sfnt2woff-zopfli";
  version = "1.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "bramstein";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wMB5B7kpARsZEXKF7XTdQP0+zbz97WS9GTI16hIQtxo=";
  };

  nativeBuildInputs = with pkgs; [ installShellFiles ];
  buildInputs = with pkgs; [ zlib ];

  installPhase = ''
    installBin     sfnt2woff-zopfli   woff2sfnt-zopfli
    installManPage sfnt2woff-zopfli.1 woff2sfnt-zopfli.1
  '';

  meta = {
    description = "WOFF utilities with Zopfli compression";
    homepage = "https://github.com/bramstein/sfnt2woff-zopfli";
    mainProgram = pname;
  };
}
