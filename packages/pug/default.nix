{ mkYarnPackage, fetchFromGitHub, ... }: mkYarnPackage rec {
  pname = "pug3-cli";
  version = "0e28930";
  name = "${pname}-${version}";

  src = fetchFromGitHub {
    owner = "tokilabs";
    repo = pname;
    rev = version;
    hash = "sha256-7qvHsP4fyrkOSTzl9zx1s/idFGBew8E0jpsedLiatOs=";
  };
  yarnLock = ./yarn.lock;

  meta = {
    mainProgram = "pug3";
    homepage = "https://github.com/tokilabs/pug3-cli";
    description = "Pug 3 CLI interface";
  };
}
