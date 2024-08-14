pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "dinit";
  version = "0.18.0";

  src = pkgs.fetchFromGitHub {
    owner = "davmac314";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AaLfsoSXNKrVEIKgfP6eSWLbGNK4QLr3dnc9MXEoEWM=";
  };

  nativeBuildInputs = with pkgs; [
    m4
    meson
    ninja
  ];

  mesonFlags = [
    "-D dinit-sbindir=${placeholder "out"}/bin"
  ];

  meta = {
    description = "Service monitoring / init system";
    homepage = "https://github.com/davmac314/dinit";
    mainProgram = pname;
  };
}
