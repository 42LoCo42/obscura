{ fetchFromGitHub
, python3Packages
}: python3Packages.buildPythonApplication rec {
  pname = "vulnix";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "nix-community";
    repo = pname;
    rev = version;
    hash = "sha256-NSjb/WMrhNthXpan451w+Rcb2LXPidm3AXL0UemvktY=";
  };

  propagatedBuildInputs = with python3Packages; [
    click
    colorama
    pyyaml
    requests
    setuptools
    toml
    zodb
  ];

  doCheck = false;

  meta = {
    description = "Vulnerability (CVE) scanner for Nix/NixOS";
    homepage = "https://github.com/nix-community/vulnix";
  };
}
