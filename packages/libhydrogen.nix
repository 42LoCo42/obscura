pkgs: pkgs.stdenv.mkDerivation rec {
  pname = "libhydrogen";
  version = "2024-05-09";

  src = pkgs.fetchFromGitHub {
    owner = "jedisct1";
    repo = pname;
    rev = "c18e510d23c7539629e306d47925a35327eb1ebf";
    hash = "sha256-OjopEs2YsEqE6LXa5UhE+DSbSoMbh+xU9YOL5YOvp80=";
  };

  nativeBuildInputs = with pkgs; [ meson ninja ];

  meta = {
    description = "A lightweight, secure, easy-to-use crypto library suitable for constrained environments";
    homepage = "https://libhydrogen.org";
  };
}
