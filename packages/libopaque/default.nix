pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "libopaque";
  version = "0.99.8";

  src = pkgs.fetchFromGitHub {
    owner = "stef";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-DK2HcWWys7EaKLIYJayt2e7nA9q9miLLTt41CS5iC3E=";
  };

  enableParallelBuilding = true;

  makeFlags = [ "-C src" "PREFIX=$(out)" ];

  nativeBuildInputs = with pkgs; [
    # for manpages
    pandoc
    which

    pkgconf
  ];

  buildInputs = with pkgs; [
    liboprf
    libsodium
  ];

  postInstall = ''
    install -Dm444 {,$out/lib/pkgconfig/}libopaque.pc
  '';

  meta = {
    description = "c implementation of the OPAQUE protocol";
    homepage = "https://github.com/stef/libopaque";
    mainProgram = "opaque";
  };
}
