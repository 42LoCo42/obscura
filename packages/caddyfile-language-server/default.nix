pkgs:
let
  inherit (pkgs.lib) getExe;

  node = pkgs.nodejs;
  pnpm = pkgs.pnpm_8;

  pname = "caddyfile-language-server";
  pkg = "@caddyserver/${pname}";
in
pkgs.stdenv.mkDerivation rec {
  inherit pname;
  version = "0.4.0";

  src = pkgs.fetchFromGitHub {
    owner = "caddyserver";
    repo = "vscode-caddyfile";
    tag = "v${version}";
    hash = "sha256-IusP9Z3e8mQ0mEhI1o1zIqPDB/i0pqlMfnt6M8bzb2w=";
  };

  nativeBuildInputs = [ node pnpm.configHook ];

  pnpmWorkspaces = [ pkg ];

  pnpmDeps = pnpm.fetchDeps {
    inherit pname version src pnpmWorkspaces;
    fetcherVersion = 2;
    hash = "sha256-1Hxb1MsuQLj9LsWW4tZ3JL79Kdu0qQB/bwIswRHUdHk=";
  };

  buildPhase = ''
    pnpm --filter=${pkg} build

    echo '#!${getExe node}'           >  ${pname}
    cat packages/server/dist/index.js >> ${pname}
  '';

  installPhase = ''
    install -Dm555 ${pname} $out/bin/${pname}
  '';

  meta = {
    description = "Caddyfile language server";
    homepage = "https://github.com/caddyserver/vscode-caddyfile";
    mainProgram = pname;
  };
}
