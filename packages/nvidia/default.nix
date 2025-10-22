pkgs:
let driver = pkgs.linuxPackages_zen.nvidiaPackages.production; in
pkgs.lib.pipe driver [
  (nvidia: [
    nvidia
    nvidia.persistenced
    nvidia.settings
    pkgs.nvtopPackages.full
  ])
  (pkgs.linkFarmFromDrvs "nvidia")
  (x: x // {
    inherit (driver) version;

    meta = {
      description = "nvidia driver & nvtop metapackage";
      homepage = "https://www.nvidia.com";
      # broken = pkgs.hostPlatform.isAarch64;
      broken = true; # TODO https://hydra.nixos.org/job/nixpkgs/trunk/linuxPackages_zen.kernel.x86_64-linux
    };
  })
]
