pkgs: pkgs.rustPlatform.buildRustPackage (drv: {
  pname = "pipewire-screenaudio";
  version = "0.4.2";

  src = pkgs.fetchFromGitHub {
    owner = "IceDBorn";
    repo = drv.pname;
    tag = drv.version;
    hash = "sha256-oCUH7p46BNEaUnd/asY1eT7ZY6uVwrZVyJMM/zUNkqc=";
  };

  sourceRoot = "${drv.src.name}/native/connector-rs";

  cargoHash = "sha256-RDxVY9GnXxUuDefzrrb69MTCB3L+c7vMAaEmwJruWWY=";

  env = {
    BINDGEN_EXTRA_CLANG_ARGS = "-I${pkgs.glibc.dev}/include";
    LIBCLANG_PATH = "${pkgs.libclang.lib}/lib";
  };

  nativeBuildInputs = with pkgs; [
    pkg-config
  ];

  buildInputs = with pkgs; [
    pipewire
  ];

  postInstall = ''
    mv $out/bin/{connector-rs,$pname}

    common=native-messaging-hosts/com.icedborn.pipewirescreenaudioconnector.json
    dst=$out/lib/mozilla/$common
    install -Dm644 $src/native/$common $dst
    substituteInPlace $dst                               \
      --replace CONNECTOR_BINARY_PATH $out/bin/$pname    \
      --replace ALLOWED_FIELD         allowed_extensions \
      --replace ALLOWED_VALUE         pipewire-screenaudio@icenjim
  '';

  meta = {
    description = "Extension to passthrough pipewire audio to WebRTC Screenshare";
    homepage = "https://github.com/IceDBorn/pipewire-screenaudio";
    mainProgram = drv.pname;
  };
})
