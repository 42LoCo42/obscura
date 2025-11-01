pkgs:
let
  inherit (pkgs.lib) escapeRegex head match replaceStrings;

  cryptpad = ((import (fetchTarball {
    # https://github.com/NixOS/nixpkgs/pull/434721
    url = "https://github.com/NixOS/nixpkgs/archive/06b08e536f1d219564f9512563334b913bfbbdb9.tar.gz";
    sha256 = "sha256-ZbvpT8SL2qOSuVbK2y72Bri9LZ/Scl1xk5wikCuldD4=";
  })) { inherit (pkgs.stdenv.hostPlatform) system; }).cryptpad;

  oo_ver_old = "v8.3.3.23+4";
  oo_ver_new = "v8.3.3.23+5";

  oo_drv_old = head ((match ''
    .*unzip (/nix/store/[^ ]+) -d "\$oo_dir"
    echo "${escapeRegex oo_ver_old}" .*'') cryptpad.postInstall);

  oo_drv_new = (pkgs.fetchurl {
    url = "https://github.com/cryptpad/onlyoffice-editor/releases/download/${oo_ver_new}/onlyoffice-editor.zip";
    hash = "sha256-+53jzvmGltD1yjXAimLl8zL1V4YDc1qF1PUFSeyiUm8=";
  }).outPath;
in
cryptpad.overrideAttrs (new: old: {
  version = "2025.9.0";

  src = pkgs.fetchFromGitHub {
    inherit (old.src) owner repo;
    tag = new.version;
    hash = "sha256-veLtKjrk1CZe2u3MkozsPK98hyhdsWbQGUxh8oWjLXg=";
  };

  npmDeps = pkgs.fetchNpmDeps {
    name = "${new.pname}-${new.version}-npm-deps";
    inherit (new) src;
    hash = "sha256-d/2JKGdC/tgDOo4Qr/0g83lh5gW6Varr0vkZUZe+WTA=";
  };

  postInstall = replaceStrings
    [ oo_ver_old oo_drv_old ]
    [ oo_ver_new oo_drv_new ]
    old.postInstall;
})
