pkgs: pkgs.buildGoModule rec {
  pname = "anubis";
  version = "1.14.2";

  src = pkgs.fetchFromGitHub {
    owner = "TecharoHQ";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-K4VXTO8F3GTOA9jOrI0OF6CYTRaDUlUT9/HujYmnHpM=";
  };

  ldflags = [ "-s" "-w" ];
  subPackages = [ "cmd/anubis" ];
  vendorHash = "sha256-t+E3sILEwXGkTaBtKLO2kFEntivY9fVK8o86arvMaOU=";

  meta = {
    description = "Weighs the soul of incoming HTTP requests using proof-of-work to stop AI crawlers";
    homepage = "https://github.com/TecharoHQ/anubis";
    mainProgram = pname;
  };
}
