pkgs: pkgs.buildGoModule rec {
  pname = "sillysecrets";
  version = "2.1.4";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = pname;
    tag = version;
    hash = "sha256-YZwQDK+4weicsJ1yalolferLQxtrC1aGefSFYR0Dbv0=";
  };

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-XIh0+k/CJ4RrRw9+Lvl/BKPh4TM5g+gY2jnrWwFvfTs=";

  nativeBuildInputs = with pkgs; [
    installShellFiles
    makeBinaryWrapper
  ];

  postInstall = ''
    mv $out/bin/{${pname},sesi}

    wrapProgram $out/bin/sesi \
      --prefix PATH : ${pkgs.moreutils}/bin

    $out/bin/sesi man
    installManPage man/*

    for i in bash fish zsh; do
      $out/bin/sesi completion $i > sesi.$i
      installShellCompletion sesi.$i
    done
  '';

  meta = {
    description = "The silliest secret manager! :3";
    homepage = "https://github.com/42LoCo42/sillysecrets";
    mainProgram = "sesi";
  };
}
