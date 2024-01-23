{ buildGoModule
, fetchFromGitHub
}: buildGoModule rec {
  pname = "e2eirc";
  version = "0e3198a";
  src = fetchFromGitHub {
    owner = "novus0rdo";
    repo = pname;
    rev = version;
    hash = "sha256-qaLNd40NUIi4ox4jIkzkotUBl0NUuR/0UsmhIOnKaz8=";
  };
  patches = [ ./e2eirc.patch ];
  vendorHash = "sha256-TUjjxOsP7tmIaT7M9alaz1Of4uD+kda1Z9qUSdSwf7s=";

  meta = {
    description = "E2EIRC allows you to create end to end encrpyted chat rooms on Regular (Unmodified) IRC servers and your favorite IRC client.";
    homepage = "https://github.com/novus0rdo/e2eirc";
  };
}
