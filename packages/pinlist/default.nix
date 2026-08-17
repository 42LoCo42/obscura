pkgs: pkgs.buildGoModule (drv: {
  pname = "pinlist";
  version = "1.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = drv.pname;
    tag = drv.version;
    hash = "sha256-vHIIgpk3ngd8ngAi5xDIAlrKSJgfOs69CAEueGftmN4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-DJxWvd9ABBkxJxqFdr3C2GVUs2Hxmr9GhOBnVj+Ip6Q=";

  meta = {
    description = "Super simple text/link pinlist tool";
    homepage = "https://github.com/42LoCo42/pinlist";
    mainProgram = drv.pname;
  };
})
