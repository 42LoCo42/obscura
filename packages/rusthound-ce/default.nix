pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "rusthound-ce";
  version = "2.4.3-unstable-2025-11-04";

  src = pkgs.fetchFromGitHub {
    owner = "g0h4n";
    repo = pname;
    rev = "c47b8d74e74f5726ca744ba65ac985cc7ead7069";
    hash = "sha256-N71ZK7fW/h2MhgtaiD+G9pQiAhWMp452NrCdYA/g/Ik=";
  };

  cargoHash = "sha256-rIKTi4g6K5rtbMv/BRXIDQC5cElYayX5nL0i/3DpvFI=";

  nativeBuildInputs = with pkgs; [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = with pkgs; [
    krb5
  ];

  meta = {
    description = "Active Directory data ingestor for BloodHound Community Edition written in Rust";
    homepage = "https://github.com/g0h4n/RustHound-CE";
    mainProgram = pname;
  };
}
