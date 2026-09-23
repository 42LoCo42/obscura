pkgs: pkgs.php.buildComposerProject2 (drv: {
  pname = "directorylister";
  version = "5.7.0";

  src = pkgs.fetchFromGitHub {
    owner = drv.pname;
    repo = drv.pname;
    tag = drv.version;
    hash = "sha256-QDO3ozwkUCvmCtffYZv2L7rATljFX/Xwo2pE+Xuy69s=";
  };

  prePatch = ''
    sed -i 's|app/vendor|vendor|' composer.json
    sed -i '/footer/d' app/views/*.twig
  '';

  nativeBuildInputs = with pkgs; [
    nodejs
    npmHooks.npmConfigHook
  ];

  npmDeps = pkgs.fetchNpmDeps {
    inherit (drv) pname src version;
    hash = "sha256-d7+iDiUuP5kRDWKAFEgtex1At5MGAUF1cP8nJleZSoc=";
  };

  vendorHash = "sha256-X85hzkZ/LtQKJ3Tw3WcYZLxe8QPLDLKBSMY7/8Sq93s=";

  buildPhase = ''
    setComposerEnvVariables
    cp -r $composerVendor/vendor app
    chmod -R +w app/vendor
    composer \
      --no-dev --no-plugins --no-scripts \
      --no-cache --no-interaction install

    npm run build
    rm -rf app/{cache/*,resources}
  '';

  installPhase = ''
    mkdir $out
    cp -r index.php app $out
  '';

  meta = {
    description = "Simple PHP-based directory lister";
    homepage = "https://github.com/DirectoryLister/DirectoryLister";
  };
})
