pkgs: pkgs.buildGoModule rec {
  pname = "ncps";
  version = "0.0.12";

  src = (pkgs.fetchFromGitHub {
    owner = "kalbasit";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-cEI+Jten5pyrHi1rEh/YYL9akeekp7CP6/1xOqC5cUs=";
  }).overrideAttrs (old: {
    postFetch = old.postFetch + ''
      cd $out
      find -name '*_test.go' -delete
      rm -rf testdata devbox.lock
    '';
  });

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-4aqS54T1iA4U0B3TATj+a6+inIKUg7XQLvq6U1P5mBs=";

  meta = {
    description = "Nix binary cache proxy service -- with local caching and signing";
    homepage = "https://github.com/kalbasit/ncps";
    mainProgram = pname;
  };
}
