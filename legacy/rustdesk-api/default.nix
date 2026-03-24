pkgs:
let
  owner = "lejianwen";

  frontend = pkgs.buildNpmPackage rec {
    pname = "rustdesk-api-web";
    version = "1.2.0-unstable-2025-04-14";

    src = pkgs.fetchFromGitHub {
      inherit owner;
      repo = pname;
      rev = "83f25444ba952f21de2d73838d8982e768032f87";
      hash = "sha256-boITBL8fnmx6RoKiOofOGfjrIJDRPjY4byjLDNg99Vg=";
    };

    npmDepsHash = "sha256-93qB65Ilghn5mCja3dU/Mib1iXFrYlfuYymoSaMsqYE=";

    dontNpmInstall = true;
    installPhase = "cp -r dist $out";

    meta = {
      description = "Frontend for rustdesk-api";
      homepage = "https://github.com/lejianwen/rustdesk-api-web";
    };
  };

  backend = pkgs.buildGoModule rec {
    pname = "rustdesk-api";
    version = "2.6.15";

    src = pkgs.fetchFromGitHub {
      inherit owner;
      repo = pname;
      tag = "v${version}";
      hash = "sha256-13Hj1lf0PYQs+HowtfgFKf7f0sZwSZqJZbLVtzlV/XY=";
    };

    # the repo does not include these for some reason >_<
    prePatch = "cp ${./.}/go.{mod,sum} .";

    ldflags = [ "-s" "-w" ];
    subPackages = [ "cmd/apimain.go" ];
    vendorHash = "sha256-NzooRu6AreNzbliofVgjLAnqbsPFVnDXkN70d65jzz8=";

    nativeBuildInputs = with pkgs; [ go-swag ];

    postBuild = ''
      swag init -g cmd/apimain.go --output docs/api   --instanceName api   --exclude http/controller/admin
      swag init -g cmd/apimain.go --output docs/admin --instanceName admin --exclude http/controller/api

      ln -s ${frontend} resources/admin
    '';

    postInstall = "cp -r conf docs resources $out";

    passthru = { inherit frontend; };

    meta = {
      description = "Custom Rustdesk Api Server";
      homepage = "https://github.com/lejianwen/rustdesk-api";
      mainProgram = "apimain";
    };
  };
in
backend
