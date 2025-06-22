# show prompt when authentication begins
pkgs: pkgs.pam_rssh.overrideAttrs (old: rec {
  version = "1.2.0";

  src = pkgs.fetchFromGitHub {
    inherit (old.src) owner repo fetchSubmodules;
    tag = "v${version}";
    hash = "sha256-VxbaxqyIAwmjjbgfTajqwPQC3bp7g/JNVNx9yy/3tus=";
  };
})
