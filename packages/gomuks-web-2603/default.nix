pkgs: pkgs.buildGoModule (drv: {
  pname = "gomuks-web";
  version = "0.2603.0";

  src = pkgs.fetchFromGitHub {
    owner = "gomuks";
    repo = "gomuks";
    rev = "0d5f058f7f1f224ec6a8a97f21738579f43133a1";
    hash = "sha256-lWuZ1UkazG31qfZsRUb4eTc34qazCQlI7k+i9H1cdb4=";
  };

  proxyVendor = true;
  vendorHash = "sha256-0h0/pNCd6g3aknDdKmVgojXKHzbtvWK/NVNToVJP0fU=";

  nativeBuildInputs = with pkgs; [
    nodejs
    npmHooks.npmConfigHook
  ];

  env = {
    npmRoot = "web";
    npmDeps = pkgs.fetchNpmDeps {
      src = "${drv.src}/web";
      hash = "sha256-9kGKUF+t4miz+uXZVifNhLkwYTK8ZAhFfrAfWF8Rxck=";
    };
  };

  postPatch = ''
    substituteInPlace ./web/build-wasm.sh \
      --replace-fail 'go.mau.fi/gomuks/version.Tag=$(git describe --exact-match --tags 2>/dev/null)' "go.mau.fi/gomuks/version.Tag=v${drv.version}" \
      --replace-fail 'go.mau.fi/gomuks/version.Commit=$(git rev-parse HEAD)' "go.mau.fi/gomuks/version.Commit=${drv.src.rev}"
  '';

  doCheck = false;

  tags = [ "goolm" ];

  ldflags = [
    "-X 'go.mau.fi/gomuks/version.Tag=v${drv.version}'"
    "-X 'go.mau.fi/gomuks/version.Commit=${drv.src.rev}'"
    "-X \"go.mau.fi/gomuks/version.BuildTime=$(date -Iseconds)\""
    "-X \"maunium.net/go/mautrix.GoModVersion=$(cat go.mod | grep 'maunium.net/go/mautrix ' | head -n1 | awk '{ print $2 })\""
  ];

  subPackages = [ "cmd/gomuks" ];

  preBuild = ''
    CGO_ENABLED=0 go generate ./web
  '';

  postInstall = ''
    mv $out/bin/gomuks $out/bin/gomuks-web
  '';

  meta = {
    mainProgram = "gomuks-web";
    description = "Matrix client written in Go";
    homepage = "https://github.com/gomuks/gomuks";
  };
})
