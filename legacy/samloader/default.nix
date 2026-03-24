pkgs:
let py = pkgs.python3.pkgs; in py.buildPythonApplication rec {
  pname = "samloader";
  version = "0.4.1-unstable-2023-06-19";

  src = pkgs.fetchFromGitHub {
    owner = "samloader";
    repo = "samloader";
    rev = "0e53d8032699a4039ea6f5310ebec05f8f417f07";
    hash = "sha256-viMM1voK/qayQ+ouIlYgV5NoYnc+6dJqEaf9ikZHMPY=";
  };

  pyproject = true;

  build-system = with py; [
    setuptools
  ];

  dependencies = with py; [
    pycryptodomex
    requests
    tqdm
  ];

  doCheck = false;

  meta = {
    description = "Download Samsung firmware from official servers";
    homepage = "https://github.com/samloader/samloader";
    mainProgram = pname;
  };
}
