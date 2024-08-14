pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "dinit";
  version = "2024-08-06";

  src = pkgs.fetchFromGitHub {
    owner = "davmac314";
    repo = pname;
    rev = "3867cf1766134980d2c3cd6f441276217af498e9";
    hash = "sha256-6CJaoga5Pu+eRGuaGDsRZk26+hKEIWkNm0WrCIpEiV0=";
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
