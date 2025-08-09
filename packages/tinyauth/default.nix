pkgs:
let
  pname = "tinyauth";
  version = "3.6.2";

  src = pkgs.fetchFromGitHub {
    owner = "steveiliop56";
    repo = pname;
    tag = "v${version}";
    hash = "sha256-nJoo/CojxHuX/jmFfATqQbozxCaUA95auxulKKlLpiY=";
  };

  frontend = pkgs.stdenv.mkDerivation (x: {
    pname = "${pname}-frontend";
    inherit version;

    src = "${src}/frontend";
    patchPhase = "cp ${./pnpm-lock.yaml} pnpm-lock.yaml";

    nativeBuildInputs = with pkgs; [
      nodejs
      pnpm.configHook
    ];

    pnpmDeps = pkgs.pnpm.fetchDeps {
      inherit (x) pname version src patchPhase;
      fetcherVersion = 2;
      hash = "sha256-6pGMzkEsv6wI0yR0qUBu3P802Pkm75R+Sp6csVe5Ub4=";
    };

    buildPhase = "pnpm run build";
    installPhase = "cp -r dist $out";
  });
in
pkgs.buildGoModule {
  inherit pname version src;

  nativeBuildInputs = with pkgs; [
    installShellFiles
  ];

  preBuild = "cp -r ${frontend} internal/assets/dist";

  ldflags = [
    "-s"
    "-w"
    "-X tinyauth/internal/constants.Version=${version}"
  ];

  vendorHash = "sha256-f/tzq+G6MIqNemQCp38iBJ1b5RBwf2HM7CZr//z9Bt0=";

  postInstall = ''
    installShellCompletion --cmd ${pname}         \
      --bash <($out/bin/${pname} completion bash) \
      --fish <($out/bin/${pname} completion fish) \
      --zsh  <($out/bin/${pname} completion zsh)
  '';

  meta = {
    description = "The simplest way to protect your apps with a login screen";
    homepage = "https://tinyauth.app";
    mainProgram = pname;
  };
}
