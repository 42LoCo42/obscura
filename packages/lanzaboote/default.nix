pkgs:
let
  src = import (fetchTarball {
    url = "https://github.com/42LoCo42/lanzaboote/tarball/4bcbae99c48270ccd6fe8f09a5aca4b32bb0a76a";
    sha256 = "0yf8sjaq0ra8083rywwmak3prvbfwya9lhlqi3bgw000xhpi86h6";
  });

  packages = src.packages.${pkgs.system};
in
(pkgs.runCommand "lzbt" {
  inherit (packages.stub) version;

  passthru = {
    inherit (packages) lzbt stub tool;
  };

  meta = {
    description = "Secure Boot for NixOS";
    homepage = "https://github.com/42LoCo42/lanzaboote";
    mainProgram = packages.lzbt.name;
  };
}) ''
  install -Dm555 "${pkgs.lib.getExe packages.lzbt}" "$out/bin/lzbt"
  install -Dm444 "${packages.stub}/bin/lanzaboote_stub.efi" "$out/bin/lanzaboote_stub.efi"
  install -Dm444 "${src}/nix/modules/lanzaboote.nix" "$out/module.nix"
''
