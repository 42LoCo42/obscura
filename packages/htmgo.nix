pkgs: pkgs.buildGoModule rec {
  pname = "htmgo";
  version = "1.0.5";

  src = pkgs.fetchFromGitHub {
    owner = "maddalax";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-5ADVyNN8SC/iooK7OZO9LHrI/+Mf5QZ8yL+Zgnahedo=";
  };

  modRoot = "cli/htmgo";
  preBuild = ''
    rm -rf                        \
      tasks/astgen/project-sample \
      tasks/astgen/registration_test.go
  '';

  vendorHash = "sha256-2FYYKZu80yXaaIrn1kH94llzL3NrjW6VgqmDnVnEF6Q=";

  CGO_ENABLED = "0";
  ldflags = [ "-s" "-w" ];

  meta = {
    description = "A lightweight pure go way to build interactive websites / web applications using go & htmx";
    homepage = "https://htmgo.dev";
    mainProgram = pname;
  };
}
