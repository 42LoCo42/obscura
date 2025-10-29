pkgs:
let driver = pkgs.linuxPackages_zen.nvidiaPackages.production; in
pkgs.lib.pipe driver [
  (nvidia: [
    nvidia
    nvidia.persistenced
    nvidia.settings

    (import pkgs.path {
      inherit (pkgs) system;
      config = pkgs.config // {
        cudaSupport = true;
      };
    }).nvtopPackages.full
  ])
  (map (x: { name = x.pname or "nvidia"; path = x; }))
  (pkgs.linkFarm "nvidia")
  (x: x.overrideAttrs {
    inherit (driver) version;

    meta = {
      description = "nvidia driver & nvtop metapackage";
      homepage = "https://www.nvidia.com";
      broken = pkgs.hostPlatform.isAarch64;
    };
  })
]
