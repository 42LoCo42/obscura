# TODO: https://github.com/NixOS/nixpkgs/pull/507097
pkgs: pkgs.buildGoModule (drv: {
  pname = "prometheus-podman-exporter";
  version = "2.1.0-unstable-2026-10-25";

  src = pkgs.fetchFromGitHub {
    owner = "containers";
    repo = drv.pname;
    rev = "4f820fab1af33010476902679b5f2f4a58b22ad1";
    hash = "sha256-VQzizOLG1NMJ+Wh722mcM/VEI5CqZfCZVbYqSMvTLms=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    btrfs-progs # for headers
    gpgme
  ];

  ldflags = [ "-s" ];
  vendorHash = null;

  doCheck = false; # needs a running podman

  meta = {
    description = "Prometheus exporter for podman environments";
    homepage = "https://github.com/containers/prometheus-podman-exporter";
    mainProgram = drv.pname;
  };
})
