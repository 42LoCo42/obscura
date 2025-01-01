pkgs: pkgs.buildGoModule rec {
  pname = "ncps";
  version = "0.0.19-unstable-2025-01-01";

  src = (pkgs.fetchFromGitHub {
    owner = "kalbasit";
    repo = pname;
    # rev = "v${version}";
    rev = "53c506ce62d3a1c04b440a0ba53c5704fc14ae85";
    hash = "sha256-UvOadj7c7+UBZxS9418brEAhxb5lok3B/fFOx8hFwWI=";
  }).overrideAttrs (old: {
    postFetch = old.postFetch + ''
      cd $out
      find -name '*_test.go' -delete
      rm -rf testdata
    '';
  });

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-Lp7CY2/una+P+kDTQohffKFjOx48F6bwYebm7YmMopA=";

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
