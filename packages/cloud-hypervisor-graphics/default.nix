pkgs:
let
  spectrum = fetchTarball {
    url = "https://spectrum-os.org/git/spectrum/snapshot/spectrum-4b89596e112d26c4bd60bc46bb45c5d9a0875314.tar.zst";
    sha256 = "sha256-yguP1BgKqweT0+WAeQ5m+l0SIdlBdKtdJLypASICx90=";
  };
in
import "${spectrum}/pkgs/cloud-hypervisor" {
  final = pkgs;
  super = pkgs;
}
