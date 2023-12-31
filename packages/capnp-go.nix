{ buildGoModule
, fetchFromGitHub
}: buildGoModule rec {
  pname = "capnp-go";
  version = "3.0.0-alpha.30";

  src = fetchFromGitHub {
    owner = "capnproto";
    repo = "go-capnp";
    rev = "v${version}";
    hash = "sha256-f3fiVf3ihZOrTMZUPwSy+v4EX4cuIvJXaYMvLKzPgSg=";
  };

  vendorHash = "sha256-ggZqhFEbqP4UHb1FDgFgVVIngE7c6c3F+PTgXO5nyXs=";

  preBuild = ''
    rm -rf example
  '';

  postInstall = ''
    cp -r std $out/
  '';

  meta = {
    description = "Cap'n Proto library and code generator for Go";
    homepage = "https://github.com/capnproto/go-capnp";
  };
}
