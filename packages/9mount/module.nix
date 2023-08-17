{ packages }: { config, ... }:
let
  system = config.nixpkgs.system;
  pkg = packages.${system}."9mount";
  mkWrapper = name: {
    inherit name;
    value = {
      setuid = true;
      owner = "root";
      group = "root";
      source = "${pkg}/bin/${name}";
    };
  };
in
{
  security.wrappers = builtins.listToAttrs (map mkWrapper [
    "9mount"
    "9umount"
    "9bind"
  ]);
  environment.systemPackages = [ pkg ];
}
