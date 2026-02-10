# TODO https://github.com/NixOS/nixpkgs/pull/465533

pkgs:
let
  inherit (pkgs.lib) makeBinPath;
  java = pkgs.openjdk11;
in
pkgs.stdenv.mkDerivation rec {
  pname = "neo4j";
  version = "4.4.46";

  src = pkgs.fetchzip {
    url = "https://neo4j.com/artifact.php?name=neo4j-community-${version}-unix.tar.gz";
    hash = "sha256-qeA6lP8gqvwtJSMdJgJ0Iy2MMrtGhhUIOa4A6traSNg=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
  ];

  installPhase = ''
    mkdir -p $out/{bin,share/neo4j}
    cp -R * $out/share/neo4j

    for NEO4J_SCRIPT in neo4j neo4j-admin cypher-shell; do
      f="$out/share/neo4j/bin/$NEO4J_SCRIPT"
      patchShebangs "$f"
      makeWrapper "$f" "$out/bin/$NEO4J_SCRIPT" \
        --prefix PATH : ${makeBinPath (with pkgs; [
          coreutils
          findutils
          gawk
          java
          which
        ])} \
        --set JAVA_HOME ${java}
    done
  '';

  meta = {
    description = "Neo4j 4.4 LTS";
    homepage = "https://neo4j.com";
    mainProgram = pname;
  };
}
