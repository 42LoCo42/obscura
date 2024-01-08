{ fetchFromGitHub
, buildNpmPackage
}: buildNpmPackage rec {
  pname = "prettier-plugin-go-template";
  version = "d91c82e";
  src = fetchFromGitHub {
    owner = "NiklasPor";
    repo = pname;
    rev = version;
    hash = "sha256-3Tvh+OzqDTtzoaTp5dZpgEQiNA2Y2dbyq4SV9Od499A=";
  };
  npmDepsHash = "sha256-PpJnVZFRxpUHux2jIBDtyBS4qNo6IJY4kwTAq6stEVQ=";
  dontNpmPrune = true;
  postInstall = ''
    cd "$nodeModulesPath"
    find          \
      -mindepth 1 \
      -maxdepth 1 \
      -type d     \
    | grep -Exv "\./(ulid|prettier)" \
    | xargs rm -rf
  '';
}
