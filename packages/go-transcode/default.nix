pkgs: pkgs.buildGoModule rec {
  pname = "go-transcode";
  version = "2024-09-22";

  src = pkgs.fetchFromGitHub {
    owner = "m1k1o";
    repo = pname;
    rev = "6f49701823737f0ae0ba510334d390cfa0d45f8c";
    hash = "sha256-FJu6K+4wdl+CQBxaLxoZhgHiZQ2HXhhHfM+Qb931nEY=";
  };
  vendorHash = "sha256-y1qLY3OM64yeTCdGnTaD2nkgkqunY5V61WfsqvzZptg=";

  env.CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" ];
  stripAllList = [ "bin" ];

  nativeBuildInputs = with pkgs; [ makeBinaryWrapper ];

  postInstall = ''
    wrapProgram $out/bin/${pname} \
      --prefix PATH : ${pkgs.ffmpeg-headless}/bin
  '';

  meta = {
    description = "On-demand transcoding origin server for live inputs and static files in Go using ffmpeg";
    homepage = "https://github.com/m1k1o/go-transcode";
    mainProgram = pname;
  };
}
