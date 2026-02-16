pkgs: pkgs.buildGo126Module (drv: {
  pname = "waybar-weather";
  version = "0.3.0-unstable-2026-01-30";

  src = pkgs.fetchFromGitHub {
    owner = "wneessen";
    repo = drv.pname;
    rev = "73d38c3ab34ac8ad55536606aa2d2309000a2e39";
    hash = "sha256-Cgo5xbuMmgZhxNiYTJ859vANakMAlQxgfT9XdAaHglI=";
  };

  subPackages = [ "cmd/${drv.pname}" ];
  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-QdT0vKnCO+7DezbH8NUgPV18p6zmIMmLkK2XGWL8+3o=";

  meta = {
    description = "A waybar weather module with automatic geolocation lookup";
    homepage = "https://github.com/wneessen/waybar-weather";
    mainProgram = drv.pname;
  };
})
