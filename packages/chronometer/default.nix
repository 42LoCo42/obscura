pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "chronometer";
  version = "0-unstable-2024-10-02";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = pname;
    rev = "dd49f3b7ec73fe7aeb790eb10b008232dfbc2466";
    hash = "sha256-G8qOfKPKtU1ukPSPsH9z6cbsLqWHdha0l5Ymwx7m5Zk=";
  };

  nativeBuildInputs = with pkgs; [
    nodePackages.typescript
  ];

  buildPhase = ''
    tsc --build
  '';

  installPhase = ''
    cp -r www $out
  '';

  meta = {
    description = "The Chronometer of Endless Whimsy!";
    homepage = "https://github.com/42LoCo42/chronometer";
  };
}
