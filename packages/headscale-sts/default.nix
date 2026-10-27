pkgs: pkgs.buildGoModule (drv: {
  pname = "headscale-sts";
  version = "0.1.0-unstable-2026-09-28";

  src = pkgs.fetchFromGitHub {
    owner = "fredrikekre";
    repo = drv.pname;
    rev = "dfe11bb0c9fd83fab0fa5b95bf65d7f0ea4a4c0e";
    hash = "sha256-0wzgucUbzUlPqWIIPrLmwXa6tnJw1mZz3n6npKu5djc=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  subPackages = [ "." ];
  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-jzcTaCl3pa15ohko6mE36Z9bImCrjyNF1KNtsnPHEOE=";

  meta = {
    description = "Workload Identity Federation for Headscale";
    homepage = "https://github.com/fredrikekre/headscale-sts";
    mainProgram = drv.pname;
  };
})
