pkgs:
let
  spectrum = fetchTarball {
    url = "https://spectrum-os.org/git/spectrum/snapshot/spectrum-f14abeb3db2c1c47658fa1809f3fde379e41d632.tar.zst";
    sha256 = "sha256-hHDDE0z13tIV/aE+XNVnb6tTpt8WQb3OiVZg+/AIt9U=";
  };
in
import "${spectrum}/pkgs/cloud-hypervisor" {
  final = pkgs;
  super = pkgs;
}
