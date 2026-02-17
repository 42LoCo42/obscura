# based on https://github.com/NixOS/nixpkgs/pull/485134

pkgs:
let inherit (pkgs.lib) makeBinPath; in
pkgs.stdenv.mkDerivation rec {
  pname = "papra";
  version = "26.2.0";

  src = pkgs.fetchFromGitHub {
    owner = "papra-hq";
    repo = pname;
    tag = "@papra/app@${version}";
    hash = "sha256-5vSRQnsnLQ8beHOpKYQxZiOhaB8KgLATAWqyRoveW8M=";
  };

  nativeBuildInputs = with pkgs; [
    nodejs
    pnpm
    pnpmConfigHook

    # for sharp build:
    node-gyp
    pkg-config
    python3
  ];

  buildInputs = with pkgs; [
    vips
  ];

  pnpmDeps = pkgs.fetchPnpmDeps {
    inherit pname version src;
    fetcherVersion = 3;
    pnpmWorkspaces = [
      "@papra/app-client..."
      "@papra/app-server..."
    ];
    hash = "sha256-NQakyRlL6deG13yt+FlmVcVvEkNWHW0Lhf/3NecfwaE=";
  };

  env = {
    SHARP_FORCE_GLOBAL_LIBVIPS = 1;
    npm_config_nodedir = pkgs.nodejs;
  };

  postPatch = ''
    substituteInPlace apps/papra-server/src/modules/app/static-assets/static-assets.routes.ts \
      --replace-fail "./public" "$out/lib/public" \
      --replace-fail "public/index.html" "$out/lib/public/index.html"
  '';

  buildPhase = ''
    export MAKEFLAGS="-j$NIX_BUILD_CORES"
    pnpm config set inject-workspace-packages true

    pushd node_modules/sharp
    pnpm run install
    popd

    pnpm --filter "@papra/app-client..." run build
    pnpm --filter "@papra/app-server..." run build
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}

    pnpm deploy --filter=@papra/app-server --prod $out/lib/

    mkdir -p $out/lib/public
    cp -r apps/papra-client/dist/* $out/lib/public/

    cat << EOF > $out/bin/papra
    #!${pkgs.runtimeShell} -e

    export PATH="${makeBinPath (with pkgs; [ nodejs tsx ])}"
    export NODE_PATH=$out/lib/node_modules
    export SERVER_SERVE_PUBLIC_DIR=true

    tsx $out/lib/src/scripts/migrate-up.script.ts
    exec node $out/lib/dist/index.js
    EOF
    chmod +x $out/bin/papra
  '';

  meta = {
    description = "The minimalistic document archiving platform";
    homepage = "https://github.com/papra-hq/papra";
    mainProgram = pname;
  };
}
