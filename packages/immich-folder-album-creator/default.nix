pkgs:
let
  inherit (pkgs.lib) getExe;

  python = pkgs.python3.withPackages (p: with p; [
    requests
    urllib3
    pyyaml
    regex
  ]);
in
pkgs.stdenv.mkDerivation rec {
  pname = "immich-folder-album-creator";
  version = "0.18.5";

  src = pkgs.fetchFromGitHub {
    owner = "Salvoxia";
    repo = pname;
    tag = version;
    hash = "sha256-mtKXkCysjseaKE++Ijcynio4fc55iRSpIMae0gLZyRQ=";
  };

  buildPhase = ''
    {
      echo "#!${getExe python}"
      cat immich_auto_album.py
    } > bin
  '';

  installPhase = ''
    install -Dm755 bin $out/bin/${pname}
  '';

  meta = {
    description = " Automatically create and populate albums in Immich from a folder structure in external libraries";
    homepage = "https://github.com/Salvoxia/immich-folder-album-creator";
    mainProgram = pname;
  };
}
