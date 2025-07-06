pkgs:
let driver = pkgs.linuxPackages_zen.nvidiaPackages.production; in
pkgs.lib.pipe driver [
  (x: [ x x.persistenced x.settings pkgs.nvtopPackages.full ])
  (pkgs.linkFarmFromDrvs "nvidia")
  (x: x // {
    inherit (driver) version;
    meta = {
      description = "nvidia driver & nvtop metapackage";
      homepage = "https://www.nvidia.com";
    };
  })
]
