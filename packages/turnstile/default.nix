pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "turnstile";
  version = "0.1.10";

  src = pkgs.fetchFromGitHub {
    owner = "chimera-linux";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XJ3SQSoYFwGVhmqODaJnPkTfkmNKRgcRZtt+B5KXo0c=";
  };

  nativeBuildInputs = with pkgs; [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = with pkgs; [
    linux-pam
  ];

  mesonFlags = [
    "-D library=enabled"
    "-D localstatedir=/var"
    "-D pam_moddir=${placeholder "out"}/lib/security"
    "-D runit=enabled"
  ];

  meta = {
    description = "Independent session/login tracker";
    homepage = "https://github.com/chimera-linux/turnstile";
    mainProgram = "turnstiled";
  };
}
