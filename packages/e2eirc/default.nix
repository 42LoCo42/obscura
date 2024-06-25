pkgs: pkgs.buildGoModule rec {
  pname = "e2eirc";
  version = "0e3198a";
  src = pkgs.fetchFromGitHub {
    owner = "novus0rdo";
    repo = pname;
    rev = version;
    hash = "sha256-qaLNd40NUIi4ox4jIkzkotUBl0NUuR/0UsmhIOnKaz8=";
  };
  patches = [ ./go-mod-sum.patch ];
  vendorHash = "sha256-TUjjxOsP7tmIaT7M9alaz1Of4uD+kda1Z9qUSdSwf7s=";

  meta = {
    description = "E2EIRC allows you to create end to end encrpyted chat rooms on Regular (Unmodified) IRC servers and your favorite IRC client.";
    homepage = "https://github.com/novus0rdo/e2eirc";
  };
}
