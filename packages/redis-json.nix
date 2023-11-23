{ rustPlatform
, fetchFromGitHub

, clang
}: rustPlatform.buildRustPackage rec {
  pname = "redis-json";
  version = "2.6.8";

  src = fetchFromGitHub {
    repo = "RedisJSON";
    owner = "RedisJSON";
    rev = "v${version}";
    hash = "sha256-uOgLsmagNxkQz+SokZLvRd/b4TAbzaKJ3x/a3ezVooM=";
  };

  cargoLock = {
    lockFile = "${src}/Cargo.lock";
    outputHashes = {
      "ijson-0.1.3" = "sha256-GFNNGsXWXS3BWsYffxhAnWtPh7rboGWJ1FmSHSidNmI=";
    };
  };

  patches = [ ./redis-json.patch ];

  nativeBuildInputs = [
    clang
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "RedisJSON - a JSON data type for Redis";
    homepage = "https://github.com/RedisJSON/RedisJSON";
  };
}
