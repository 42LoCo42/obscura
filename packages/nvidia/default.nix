pkgs:
let driver = pkgs.linuxPackages_zen.nvidiaPackages.production; in
pkgs.lib.pipe driver [
  (nvidia: [
    nvidia
    nvidia.persistenced
    nvidia.settings

    (pkgs.nvtopPackages.full.override {
      cudaPackages.cuda_nvml_dev = null;
    })
  ])
  (map (x: { name = x.pname or "nvidia"; path = x; }))
  (pkgs.linkFarm "nvidia")
  (x: x.overrideAttrs {
    inherit (driver) version;

    meta = {
      description = "nvidia driver & nvtop metapackage";
      homepage = "https://www.nvidia.com";
      broken = pkgs.stdenv.hostPlatform.isAarch64;
    };
  })
]
