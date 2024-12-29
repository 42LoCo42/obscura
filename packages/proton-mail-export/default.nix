pkgs:
let
  pname = "proton-mail-export";
  version = "1.0.4";

  src = pkgs.fetchFromGitHub {
    owner = "ProtonMail";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AbIS7iB5y1+vOfvAgw8mRNRTvuzdE2ML6Izod+BMCUE=";
  };

  inherit (pkgs.buildGoModule {
    inherit pname version;
    src = "${src}/go-lib";
    vendorHash = "sha256-0JsJO5E9Y7DpuZfWHFpqZKO8PPsCokl+YS5zs+zLt30=";
  }) goModules;
in
pkgs.stdenv.mkDerivation {
  inherit pname version src;

  patches = [
    ./0001-cmake-disable-vcpkg.patch
    ./0002-dont-write-logs-in-exe-directory.patch
  ];

  nativeBuildInputs = with pkgs; [
    clang-tools # clang-tidy
    cmake
    go
    ninja
  ];

  buildInputs = with pkgs; [
    catch2_3
    cxxopts
    fmt
  ];

  preConfigure = ''
    export GOCACHE=$TMPDIR/go-cache
    export GOPATH="$TMPDIR/go"
    export GOPROXY=off
    export GOSUMDB=off

    cp -r --reflink=auto "${goModules}" go-lib/vendor
  '';

  postInstall = ''
    cd $out

    # meta only includes version.json, which we don't need
    rm -rf $out/meta

    # for some reason, the library is installed into bin
    mkdir lib
    mv {bin,lib}/${pname}.so
  '';

  meta = {
    description = "Proton Mail Export allows you to export your emails as eml files";
    homepage = "https://github.com/ProtonMail/proton-mail-export";
    mainProgram = "${pname}-cli";
  };
}
