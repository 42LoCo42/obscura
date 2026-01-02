pkgs:
let
  spectrum = fetchTarball {
    url = "https://spectrum-os.org/git/spectrum/snapshot/spectrum-93126ea05e4b45415aee38e2ea4c4264b1c4ccaf.tar.zst";
    sha256 = "sha256-9wzmXlcLz+PE2alNOaAbrIdZTJp8FPoVDKLAFLJ6AO0=";
  };
in pkgs.writeText "cloud-hypervisor" "broken" # TODO spectrum git is down :(
# import "${spectrum}/pkgs/cloud-hypervisor" {
#   final = pkgs;
#   super = pkgs;
# }
