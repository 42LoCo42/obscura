pkgs: pkgs.buildGoModule rec {
  pname = "anubis";
  version = "0-unstable-2025-03-18";

  src = pkgs.fetchFromGitHub {
    owner = "TecharoHQ";
    repo = pname;
    rev = "726221c5c62391d2c4d9792532e23b328d14fe5a";
    hash = "sha256-CPMnv7N4eNn1Ol0ZDv2vKRzn7hB4rUT7Chr5MeuWsCY=";
  };

  subPackages = [ "cmd/anubis" ];

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-jw/iDhOYxx82sO3o9G5c6HfSpm1hAl6f3y5Y7vbfA7U=";

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://github.com/TecharoHQ/anubis";
    mainProgram = pname;
  };
}
