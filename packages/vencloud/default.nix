pkgs: pkgs.buildGoModule rec {
  pname = "vencloud";
  version = "0.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "vencord";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u++1qWH04MKipnTGo04FVS+HYcx52AWZpBcjiFMp+mY=";
  };

  vendorHash = "sha256-4g3mGMhsBaJ4N8SEj56sjAgfH5v8J2RD5c5tMLk5hGU=";

  postInstall = ''
    mv $out/bin/backend $out/bin/${pname}
  '';

  meta = {
    description = "Vencord API";
    homepage = "https://github.com/Vencord/Vencloud";
    mainProgram = pname;
  };
}
