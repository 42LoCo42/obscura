pkgs: pkgs.buildGoModule rec {
  pname = "e2eirc";
  version = "0.0.1-unstable-2017-10-31";

  src = pkgs.fetchFromGitHub {
    owner = "novus0rdo";
    repo = pname;
    rev = "0e3198a20cd64e6d42dac407fd46afad9bcf4abf";
    hash = "sha256-qaLNd40NUIi4ox4jIkzkotUBl0NUuR/0UsmhIOnKaz8=";
  };

  patches = [
    # provide go.mod & go.sum
    ./go-mod-sum.patch
  ];

  vendorHash = "sha256-TUjjxOsP7tmIaT7M9alaz1Of4uD+kda1Z9qUSdSwf7s=";

  meta = {
    description = "E2EIRC allows you to create end to end encrpyted chat rooms on Regular (Unmodified) IRC servers and your favorite IRC client.";
    homepage = "https://github.com/novus0rdo/e2eirc";
  };
}
