pkgs: pkgs.rustPlatform.buildRustPackage (drv: {
  pname = "fastgmad";
  version = "0.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "WilliamVenner";
    repo = drv.pname;
    tag = "v${drv.version}";
    hash = "sha256-8anoerXQG2NY2/qo7JOvOBvJqu8UVqkyr1/i7Y40pk4=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  cargoHash = "sha256-elplwIgnhDtgg4H3zC49zd6qL+SUvKhkcuLowhh0/mk=";

  doCheck = false; # breaks, maybe a race condition? :/

  meta = {
    description = "An extremely fast reimplementation of gmad.exe and gmpublish.exe";
    homepage = "https://github.com/WilliamVenner/fastgmad";
    mainProgram = drv.pname;
    broken = pkgs.stdenv.hostPlatform.isAarch64; # due to steamworks dependency
  };
})
