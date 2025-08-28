pkgs:
let driver = pkgs.linuxPackages_zen.nvidiaPackages.production; in
pkgs.lib.pipe driver [
  (nvidia: [
    nvidia
    # nvidia.persistenced # TODO currently broken https://github.com/nixOS/nixpkgs/issues/437066
    nvidia.settings
    pkgs.nvtopPackages.full
  ])
  (pkgs.linkFarmFromDrvs "nvidia")
  (x: x // {
    inherit (driver) version;

    meta = {
      description = "nvidia driver & nvtop metapackage";
      homepage = "https://www.nvidia.com";
      broken = pkgs.hostPlatform.isAarch64;
    };
  })
]
