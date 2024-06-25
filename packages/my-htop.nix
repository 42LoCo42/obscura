pkgs: pkgs.htop.overrideAttrs (old: rec {
  version = "5d778ea";

  src = pkgs.fetchFromGitHub {
    inherit (old.src) owner repo;
    rev = version;
    hash = "sha256-EAqirkDle0VbG4VEaiWwIAgISP8JsUAkgfkGQWAAXkc=";
  };

  meta = old.meta // {
    description = "htop with sorting in tree mode fixed";
  };
})
