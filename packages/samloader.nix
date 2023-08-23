{ fetchFromGitHub

, python3
}: python3.pkgs.buildPythonApplication {
  pname = "samloader";
  version = "master";

  src = fetchFromGitHub {
    owner = "samloader";
    repo = "samloader";
    rev = "0e53d8032699a4039ea6f5310ebec05f8f417f07";
    hash = "sha256-viMM1voK/qayQ+ouIlYgV5NoYnc+6dJqEaf9ikZHMPY=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pycryptodomex
    requests
    tqdm
  ];

  doCheck = false;

  meta = {
    description = "Download Samsung firmware from official servers";
    homepage = "https://github.com/samloader/samloader";
  };
}
