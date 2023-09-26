{ fetchurl, stdenvNoCC }: stdenvNoCC.mkDerivation rec {
  pname = "k0s-bin";
  version = "v1.27.6+k0s.0";

  src = fetchurl {
    url = "https://github.com/k0sproject/k0s/releases/download/${version}/k0s-${version}-amd64";
    hash = "sha256-IvPxxr75hGvJSUzp8TeJGejWJvuvvEvERPN5xVvDkm8=";
  };

  dontUnpack = true;
  installPhase = ''
    mkdir -p $out/bin
    cp ${src} $out/bin/k0s
    chmod +x $out/bin/k0s
  '';

  meta = {
    description = "The Zero Friction Kubernetes";
    homepage = "https://k0sproject.io";
    mainProgram = "k0s";
  };
}
