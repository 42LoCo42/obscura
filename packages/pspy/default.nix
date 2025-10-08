pkgs: pkgs.buildGoModule rec {
  pname = "pspy";
  version = "1.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "DominicBreuker";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-7R4Tp0Q7wjAuTDukiehtRZOcTABr0YTnvrod9Jdwjok=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
    "-X main.commit=n/a"
  ];
  vendorHash = "sha256-mgAsy2ufMDNpeCXG/cZ10zdmzFoGfcpCzPWIABnvJWU=";

  meta = {
    description = "Monitor linux processes without root permissions";
    homepage = "https://github.com/DominicBreuker/pspy";
    mainProgram = pname;
  };
}
