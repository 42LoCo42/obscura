{ fetchFromGitHub
, python3
}:
let
  pyenv = python3.withPackages (ps: with ps; [
    certbot
    dnspython
  ]);
in
python3.pkgs.buildPythonApplication rec {
  pname = "certbot_dns_duckdns";
  version = "1.3";

  src = fetchFromGitHub {
    owner = "infinityofspace";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-G7GtFs3e7L8uKQgvoCy64kh7wzDpz6LCG2tEcsdHcQs=";
  };

  doCheck = false;

  buildInputs = [ pyenv ];
}
