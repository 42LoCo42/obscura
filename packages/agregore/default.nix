pkgs:
let
  inherit (pkgs.lib) getExe mapAttrsToList pipe;

  pname = "agregore";
  version = "2.4.0";

  src =
    let
      raw = pkgs.fetchFromGitHub {
        owner = "AgregoreWeb";
        repo = "agregore-browser";
        rev = "v${version}";
        hash = "sha256-jDwdBSZdz/hXDeNBpw35WBXAzhlYjTplbZaBfVO+IBg=";
      };
    in
    pkgs.runCommand "patch" { } ''
      cp -r ${raw} $out
      chmod -R +w $out
      cd $out
      patch -p1 < ${./fix.patch}
    '';

  modules = pkgs.mkYarnModules {
    inherit pname version;
    packageJSON = "${src}/package.json";
    yarnLock = "${src}/yarn.lock";
    yarnFlags = [ "--production" ];
  };

  download-extensions = pipe "${src}/app/extensions/builtins.json" [
    builtins.readFile
    builtins.fromJSON
    (mapAttrsToList (name: val:
      let
        file = pkgs.fetchurl {
          url = builtins.replaceStrings [ "{version}" ] [ val.version ] val.url;
          hash = val.hash or "";
        };
      in
      "cp ${file} $out/agregore/app/extensions/builtins/${name}.zip"))
    (builtins.concatStringsSep "\n")
  ];
in
pkgs.stdenvNoCC.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = with pkgs; [
    makeBinaryWrapper
    nodejs
    yarn
  ];

  buildPhase = ''
    node ./update-versions.js

    mkdir -p $out/agregore/app/extensions/builtins
    ${download-extensions}
  '';

  installPhase = ''
    mkdir -p $out/agregore
    cp -r app build package.json ${modules}/node_modules $out/agregore

    makeWrapper "${getExe pkgs.electron}" $out/bin/agregore \
      --chdir $out/agregore --add-flags "."
  '';

  meta = {
    description = "A minimal browser for the distributed web";
    homepage = "https://github.com/AgregoreWeb/agregore-browser";
  };
}
