pkgs: pkgs.buildGoModule rec {
  pname = "pinlist";
  version = "0-unstable-2024-08-25";

  src = pkgs.fetchFromGitHub {
    owner = "42LoCo42";
    repo = pname;
    rev = "4cb28595176e7c9b4a04192ee57641a41cd03b32";
    hash = "sha256-LDc3P5wKeHKEgisLO6h7OvXzzjtcscotHNp4TRWBQUs=";
  };

  ldflags = [ "-s" "-w" ];
  vendorHash = "sha256-6LEpelMU1eGbjYHQ7LjZqZU/lUGc3tlRen8NgT5vStg=";

  meta = {
    description = "Super simple text/link pinlist tool";
    homepage = "https://github.com/42LoCo42/pinlist";
    mainProgram = pname;
  };
}
