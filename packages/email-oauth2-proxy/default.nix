pkgs:
let p = pkgs.python3.pkgs; in
p.buildPythonApplication rec {
  pname = "email-oauth2-proxy";
  version = "2025-10-04";

  src = pkgs.fetchFromGitHub {
    owner = "simonrob";
    repo = pname;
    tag = version;
    hash = "sha256-ZWacjTO+2xeZv8lwcU5tFYsF61p7hduPQB1iOCSdeS4=";
  };

  patches = [
    # allow appending raw text to the permission_url
    ./url-append.patch
  ];

  pyproject = true;

  build-system = with p; [ setuptools ];

  dependencies = with p; [
    cryptography
    prompt-toolkit
    pyasyncore
    pyjwt
  ];

  meta = {
    description = ''
      An IMAP/POP/SMTP proxy that transparently adds OAuth 2.0 authentication
      for email clients that don't support this method
    '';
    homepage = "https://github.com/simonrob/email-oauth2-proxy";
    mainProgram = "emailproxy";
  };
}
