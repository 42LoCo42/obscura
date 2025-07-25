pkgs:
let
  spectrum = fetchTarball {
    url = "https://spectrum-os.org/git/spectrum/snapshot/spectrum-f2f6d7d2a36fd37910335654b8fc69fb01934cb3.tar.zst";
    sha256 = "sha256-aOmICRVaK7e3kPfJiN8KySMNkaFC+JxJGhWNhi668/4=";
  };
in
import "${spectrum}/pkgs/cloud-hypervisor" {
  final = pkgs;
  super = pkgs;
}
