pkgs:
let py = pkgs.python3.pkgs; in
pkgs.infuse py.solo-python
{
  __input = {
    ecdsa.__output = {
      meta.knownVulnerabilities.__assign = [ ];
    };

    fido2.__python = {
      version.__assign = "0.9.3";

      src.__output.hash.__assign = "sha256-tF6JphCc/Lfxu1E3dqotZAjpXEgi+DolORi5RAg0Zuw=";

      build-system.__assign = with py; [ setuptools ];
      dependencies.__assign = with py; [ cryptography six ];

      dontUsePytestCheck.__assign = true;
    };
  };

  __python = {
    dontCheckPythonMetadata.__assign = true;

    meta.mainProgram.__assign = "solo";
  };
}
