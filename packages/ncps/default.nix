pkgs: pkgs.buildGoModule rec {
  pname = "ncps";
  version = "0.0.15";

  src = (pkgs.fetchFromGitHub {
    owner = "kalbasit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-f1JXUkalDiZDJZ2uvJ4+5twTtYfBW7n8H7ta3chpP6w=";
  }).overrideAttrs (old: {
    postFetch = old.postFetch + ''
      cd $out
      find -name '*_test.go' -delete
      rm -rf testdata
    '';
  });

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-8PnrhLhFOrhVnP2uhVAQYCGfxRBzMYOGSJ7Vvvkrp2k=";

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
