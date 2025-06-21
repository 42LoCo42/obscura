pkgs: pkgs.buildNpmPackage rec {
  pname = "pug";
  version = "3.0.1";

  src = pkgs.fetchFromGitHub {
    owner = "tokilabs";
    repo = "pug3-cli";
    tag = version;
    hash = "sha256-7qvHsP4fyrkOSTzl9zx1s/idFGBew8E0jpsedLiatOs=";
  };
  patches = [
    # provide package-lock.json
    ./package-lock.patch
  ];

  npmDepsHash = "sha256-6wbu2Rgy7aP1L99YE8KXjfwUaJmu869TEWQJdiHBzX8=";
  dontNpmBuild = true;

  postInstall = ''
    gzip -9 man/pug3.0.2
    install -Dm444 man/pug3.0.2.gz $out/share/man/man1/pug3.1.gz
  '';

  meta = {
    mainProgram = "pug3";
    homepage = "https://github.com/tokilabs/pug3-cli";
    description = "Pug 3 CLI interface";
  };
}
