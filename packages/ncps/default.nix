pkgs: pkgs.buildGoModule rec {
  pname = "ncps";
  version = "0.0.13";

  src = (pkgs.fetchFromGitHub {
    owner = "kalbasit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PEylbJRZudBToIkXtVDk/rSQL9LUd8IGiRfa5qQ4aUk=";
  }).overrideAttrs (old: {
    postFetch = old.postFetch + ''
      cd $out
      find -name '*_test.go' -delete
      rm -rf testdata devbox.lock
    '';
  });

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-RRbiiSo8n/Xtms80rSbXuU8X1Rxe+XYWC6gk2lmhz/8=";

  postInstall =
    let inherit (pkgs.lib) getExe pipe; in
    pipe ./db-helper.sh [
      (x: pkgs.writeShellApplication {
        name = "${pname}-db-helper";
        runtimeInputs = with pkgs; [ coreutils dbmate ];
        text = builtins.readFile x;
      })
      (x: ''
        cd $out/bin
        sed '
          s|@bin@|${placeholder "out"}/bin/${pname}|g;
          s|@src@|${src}|g;
        ' < ${getExe x} > ${pname}-db-helper
        chmod +x ${pname}-db-helper
      '')
    ];

  meta = {
    description = "Nix binary cache proxy service -- with local caching and signing";
    homepage = "https://github.com/kalbasit/ncps";
    mainProgram = pname;
  };
}
