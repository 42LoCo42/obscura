pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "bedrockdb";
  version = "2023-10-25";

  src =
    let
      bedrockdb = pkgs.fetchFromGitHub {
        owner = "expensify";
        repo = "bedrock";
        rev = version;
        hash = "sha256-NzKC7RdsoU9Uz+RhqDLIbpnyg4TcWoLk7y96ftEzCBY=";
      };

      mbedtls = pkgs.fetchFromGitHub {
        owner = "ARMmbed";
        repo = "mbedtls";
        rev = "v2.26.0";
        hash = "sha256-VbgYI7I6BxcuW9EvRr0CXVPsRBNlsIl3Pti8/XK9nGk=";
      };
    in
    pkgs.runCommand "source" { } ''
      cp -r ${bedrockdb} $out
      chmod -R +w $out
      rmdir $out/mbedtls
      cp -r ${mbedtls} $out/mbedtls
    '';

  patches = [ ./nixify.patch ];
  enableParallelBuilding = true;

  GIT_REVISION = "-DGIT_REVISION=${version}";

  nativeBuildInputs = with pkgs; [ pkg-config ];
  buildInputs = with pkgs; [ pcre-cpp zlib ];
  buildFlags = "bedrock";

  installPhase = ''
    install -Dm755 bedrock $out/bin/bedrock
  '';

  meta = {
    description = "Rock solid distributed database specializing in active/active automatic failover and WAN replication";
    homepage = "https://bedrockdb.com";
    mainProgram = "bedrock";
  };
}
