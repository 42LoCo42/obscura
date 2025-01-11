pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "knock";
  version = "0.8";

  src = pkgs.fetchFromGitHub {
    owner = "jvinet";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-GOg6wovyr6J5qHm5EsOxrposFtwwx/FyJs7g0dagFmk=";
  };

  nativeBuildInputs = with pkgs; [
    autoreconfHook
  ];

  buildInputs = with pkgs; [
    libpcap
  ];

  enableParallelBuilding = true;

  postFixup = "rm $out/sbin";

  meta = {
    description = "A port-knocking daemon";
    homepage = "https://github.com/jvinet/knock";
    mainProgram = "knockd";
  };
}
