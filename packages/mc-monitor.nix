pkgs: pkgs.buildGoModule rec {
  pname = "mc-monitor";
  version = "0.15.0";

  src = pkgs.fetchFromGitHub {
    owner = "itzg";
    repo = pname;
    rev = version;
    hash = "sha256-HUxrzJULwcFMaoRxF9W+OK4POvbrB2dpPngyDmJDWEU=";
  };

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-nF+RdW+95H1Az5fUWp0pe7k6R6tLcAK5EbRYapo0dEU=";

  meta = {
    description = "Monitor the status of Minecraft servers";
    homepage = "https://github.com/itzg/mc-monitor";
    mainProgram = pname;
  };
}
