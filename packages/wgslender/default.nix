pkgs:
let zig = pkgs.zig_0_16; in
pkgs.stdenv.mkDerivation (drv: {
  pname = "wgslender";
  version = "1.5.1";

  src = pkgs.fetchFromGitHub {
    owner = "HugoDaniel";
    repo = drv.pname;
    tag = "v${drv.version}";
    hash = "sha256-68QCjOE+Bj9zpEA7NZ+DQwBjuzWameffiE8ZMm/JKDw=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    zig
  ];

  zigDeps = zig.fetchDeps {
    inherit (drv) pname src version;
    fetchAll = true;
    hash = "sha256-n5L6NK5j9016zGBML9mOQ4HVeHFPw46Eg8c/blI/mlY=";
  };

  postConfigure = ''
    ln -s ${drv.zigDeps} "$ZIG_GLOBAL_CACHE_DIR/p"
  '';

  zigBuildFlags = [ "install" "lsp" ];

  meta = {
    description = "A WGSL minifier, validator, linter, reflection, and LSP";
    homepage = "https://github.com/HugoDaniel/wgslender";
    mainProgram = drv.pname;
  };
})
