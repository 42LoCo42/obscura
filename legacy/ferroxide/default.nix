pkgs: pkgs.buildGoModule rec {
  pname = "ferroxide";
  version = "0.5.0";

  src = pkgs.fetchFromGitHub {
    owner = "acheong08";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-GShbqcsfM2Wx4Ge4pmdgAUhXIsQSxlG+WE3VKda8ZoU=";
  };

  vendorHash = "sha256-YjJdC0ZXNLAUbCoK4L2h0B4EG4y+iYKcTudJkAiOItU=";

  subPackages = [ "cmd/${pname}" ];

  meta = {
    description = "A community fork of https://github.com/emersion/hydroxide";
    homepage = "https://github.com/acheong08/ferroxide";
    mainProgram = pname;
  };
}
