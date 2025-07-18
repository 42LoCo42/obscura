pkgs:
let
  spectrum = fetchTarball {
    url = "https://spectrum-os.org/git/spectrum/snapshot/spectrum-37c8663fab86fdb202fece339ef7ac7177ffc201.tar.zst";
    sha256 = "sha256-XoHSo6GEElzRUOYAEg/jlh5c8TDsyDESFIux3nU/NMc=";
  };
in
import "${spectrum}/pkgs/cloud-hypervisor" {
  final = pkgs;
  super = pkgs;
}
