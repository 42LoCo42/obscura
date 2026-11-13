pkgs: pkgs.buildGoModule (drv: {
  pname = "leveldb-cli";
  version = "1.5.4";

  src = pkgs.fetchFromGitHub {
    owner = "cions";
    repo = drv.pname;
    tag = "v${drv.version}";
    hash = "sha256-ui2SVRuMf4WNJjI3plv/vyyYInAQggv+KsRVJ0aXucY=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  ldflags = [ "-s" ];
  vendorHash = "sha256-Q4rDYjEgDIfuS7pKzfbZ+wVYeVIcibWpdgTTaFgZkVM=";

  meta = {
    description = "A command-line interface for LevelDB";
    homepage = "https://github.com/cions/leveldb-cli";
    mainProgram = "leveldb";
  };
})
