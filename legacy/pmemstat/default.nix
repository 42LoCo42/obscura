pkgs:
let py = pkgs.python3.pkgs; in
py.buildPythonApplication rec {
  pname = "pmemstat";
  version = "0-unstable-2025-10-15";

  src = pkgs.fetchFromGitHub {
    owner = "joedefen";
    repo = pname;
    rev = "e2ac2a14bddc6a1a890e9d46d28d0c4beeeeffe0";
    hash = "sha256-xhGVQcCK/nZ9wVkFnWB8j4th4ofNPiC7pi4oFZcBEjI=";
  };

  pyproject = true;
  build-system = with py; [ flit-core ];
  dependencies = with py; [ psutil ];

  meta = {
    description = "Proportional Memory Status - shows memory consumption of Linux process by PID and groupings";
    homepage = "https://github.com/joedefen/pmemstat";
    mainProgram = pname;
  };
}
