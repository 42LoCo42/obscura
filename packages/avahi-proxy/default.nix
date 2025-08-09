pkgs: pkgs.buildGoModule rec {
  pname = "avahi-proxy";
  version = "1.0.2-unstable-2025-06-24";

  nativeBuildInputs = with pkgs; [
    installShellFiles
  ];

  src = pkgs.fetchFromGitHub {
    owner = "muhammadn";
    repo = pname;
    rev = "6848c35259ea7717b3af53150b0b01751c5cb039";
    hash = "sha256-wqHOL4Gws3Z+UPR4rVEus/L3N7eEvIMml+lW1pEaGqw=";
  };

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-F8l9taDrG4UBr/V7peSxiP5hvbCA58jcBAZkdgDh0A4=";

  postInstall = ''
    installShellCompletion --cmd ${pname}         \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh  <($out/bin/${pname} completion zsh)
  '';

  meta = {
    description = "Multicast DNS Proxy written in Go";
    homepage = "https://github.com/muhammadn/avahi-proxy";
    mainProgram = pname;
  };
}
