pkgs:
let inherit (pkgs.lib) makeBinPath; in
pkgs.stdenv.mkDerivation rec {
  pname = "papra";
  version = "0.8.2";

  src = pkgs.fetchFromGitHub {
    owner = "papra-hq";
    repo = pname;
    tag = "@papra/app-server@${version}";
    hash = "sha256-A8oDuhIWm7mEn3qq4mC3g+HsfLfgvTj6Ytc5KGyIw14=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
    pnpm.configHook

    # for sharp build:
    node-gyp
    pkg-config
    python3
  ];

  buildInputs = with pkgs; [
    vips
  ];

  pnpmDeps = pkgs.pnpm.fetchDeps {
    inherit pname version src;
    fetcherVersion = 2;
    hash = "sha256-C+/Q7iT/BLxyG/m5sBIsko3gNTixhIFbWkmSJbL30VI=";
  };

  buildPhase = ''
    echo "[1;32mBuilding app components...[m"
    pnpm --filter @papra/app-client... run build
    pnpm --filter @papra/app-server... run build

    echo "[1;32mBuilding production dependencies...[m"
    export MAKEFLAGS="-j$NIX_BUILD_CORES"
    pnpm config set nodedir ${pkgs.nodejs}
    pnpm install                    \
      --filter @papra/app-server... \
      --force                       \
      --frozen-lockfile             \
      --offline                     \
      --prod
  '';

  installPhase = ''
    echo "[1;32mInstalling app components...[m"
    mkdir -p                          $out/{app/{apps,packages},bin}
    cp -r apps/papra-server           $out/app/apps
    cp -r apps/papra-client/dist      $out/app/apps/papra-server/public
    cp -r packages/{lecture,webhooks} $out/app/packages

    echo "[1;32mInstalling dependencies...[m"
    cp -r node_modules $out/app

    echo "[1;32mCleaning up dangling symlinks...[m"
    find $out -xtype l -ls -delete

    echo "[1;32mGenerating launcher...[m"
    cat << EOF > $out/bin/${pname}
    #!${pkgs.runtimeShell} -e
    export PATH="${makeBinPath (with pkgs; [ nodejs tsx ])}:\$PATH"
    tsx $out/app/apps/papra-server/src/scripts/migrate-up.script.ts
    export SERVER_SERVE_PUBLIC_DIR=true
    exec node $out/app/apps/papra-server/dist/index.js
    EOF
    chmod +x $out/bin/${pname}
  '';

  meta = {
    description = "The minimalistic document archiving platform";
    homepage = "https://github.com/papra-hq/papra";
    mainProgram = pname;
  };
}
