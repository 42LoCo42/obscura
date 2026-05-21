# TODO https://github.com/emersion/hydroxide/pull/138
pkgs: pkgs.infuse pkgs.hydroxide {
  __output = {
    patches.__append = [
      ./pagesize.patch
    ];

    vendorHash.__assign = "sha256-rqeQCsQLbsa90YyZfjVoYFaJRCJXXMsAW8Qm9yYjbFE=";
  };
}
