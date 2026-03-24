pkgs: pkgs.rustPlatform.buildRustPackage rec {
  pname = "redis-json";
  version = "2.6.8";

  src = pkgs.fetchFromGitHub {
    repo = "RedisJSON";
    owner = "RedisJSON";
    tag = "v${version}";
    hash = "sha256-uOgLsmagNxkQz+SokZLvRd/b4TAbzaKJ3x/a3ezVooM=";
  };

  cargoHash = "sha256-N9AC9HKpKmYAM3UH81nkcOr9CH2W8MtbbtyK/YaoO5s=";

  patches = [
    # fix rustflags syntax in .cargo/config.toml
    ./rustflags.patch
  ];

  nativeBuildInputs = with pkgs; [
    clang
    rustPlatform.bindgenHook
  ];

  meta = {
    description = "RedisJSON - a JSON data type for Redis";
    homepage = "https://github.com/RedisJSON/RedisJSON";
  };
}
