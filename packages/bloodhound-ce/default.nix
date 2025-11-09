pkgs:
let
  inherit (pkgs.lib) concatLines flatten flip mapAttrsToList pipe;
  inherit (pkgs.lib.versions) major minor patch;

  pname = "bloodhound-ce";
  version = "8.3.0";

  repo = pkgs.fetchFromGitHub {
    owner = "SpecterOps";
    repo = "BloodHound";
    tag = "v${version}";
    hash = "sha256-T9OtfV3gTNT5mnXdRFxYtSyvlceOaKV+0cG1iDTAhyI=»;";
  };

  filter = flip pipe [
    (map (x: ''
      mkdir -p "$out/${dirOf x}"
      cp -r "${repo}/${x}" "$out/${x}"
    ''))
    concatLines
    (pkgs.runCommandLocal "filtered-source" { })
  ];

  yarn-berry = pkgs.yarn-berry_3;

  ##############################################################################

  frontend = pkgs.stdenv.mkDerivation (drv: {
    pname = "${pname}-ui";
    inherit version;

    src = filter [
      ".yarn/plugins"
      ".yarn/releases"
      ".yarnrc.yml"
      "cmd/ui"
      "constraints.pro"
      "package.json"
      "packages/javascript"
      "yarn-workspaces.json"
      "yarn.lock"
    ];

    patches = [
      ./fetch-dagrejs-via-https.patch
    ];

    nativeBuildInputs = with pkgs; [
      nodejs_22
      yarn-berry
      yarn-berry.yarnBerryConfigHook
      python311 # for node-gyp builds
    ];

    missingHashes = ./missing-hashes.json;

    offlineCache = yarn-berry.fetchYarnBerryDeps {
      inherit (drv) src patches missingHashes;
      hash = "sha256-0OXOZ9QVpOxqE4r1Gj0dOlEijY+JAqOvanntp5D5t1M=";
    };

    env.JOBS = "max";

    buildPhase = ''
      yarn build
    '';

    installPhase = ''
      cp -r cmd/ui/dist $out
    '';
  });

  collectors =
    let
      azver = "v2.8.1";
      shver = "v2.8.0";
    in
    (pipe {
      azurehound.${azver} = {
        darwin = {
          amd64 = "1c3e6f31ceafb7bd708f9493e8e9f8d7b898dc3259417746f0897bdc7db69bd4";
          arm64 = "e7b8beffd815d7ba6a42aaa71226a725d27a26d8380ec1313247c012a69e367b";
        };

        linux = {
          amd64 = "f30ac479fd3e8a4e5602c215eed227c9494d9ec501c3a531f4b13b8154b7161b";
          arm64 = "db796891c6ddd98a7da5689bb1be52356fd813f787a4708566fd8f6c1970d17a";
        };

        windows = {
          amd64 = "22411f121d9514d4e7b9401ecfafef318eec32fe2bb434773da7ab7afff1a2ab";
          arm64 = "a848263bba0dcbfa545c7ee56cea09c4dce797698fa1f8f647944605974ea142";
        };
      };

      sharphound.${shver} = {
        windows = {
          x86 = "06304ec63850629a83fea532f44b2e5e994af0902e3d4fcb1363b43a8c6bfabe";
        };
      };
    }) [
      (mapAttrsToList (name:
        mapAttrsToList (version:
          mapAttrsToList (os:
            mapAttrsToList (arch: sha256:
              pkgs.fetchurl {
                url = "https://github.com/SpecterOps/${name}/releases/download/${version}/${name}_${version}_${os}_${arch}.zip";
                inherit sha256;
              })))))
      flatten
      (pkgs.linkFarmFromDrvs "${pname}-collectors-zips")
      (src: pkgs.stdenv.mkDerivation {
        pname = "${pname}-collectors";
        inherit version src;

        nativeBuildInputs = with pkgs; [ p7zip ];

        installPhase = ''
          mkdir -p $out/{azurehound,sharphound}

          7z x 'azurehound_*.zip' '-oartifacts/*'
          cd artifacts
          7z a -tzip -mx9 $out/azurehound/azurehound-${azver}.zip *
          cd ..

          cp -L sharphound_* $out/sharphound/sharphound-${shver}.zip
          for i in $out/*/*.zip; do sha256sum "$i" > "$i.sha256"; done
        '';
      })
    ];

  backend = pkgs.buildGoModule (drv: {
    inherit pname version;

    src = filter [
      "cmd/api"
      "go.mod"
      "go.sum"
      "packages/go"
    ];

    nativeBuildInputs = with pkgs; [
      makeBinaryWrapper
    ];

    ldflags = [
      "-X github.com/specterops/bloodhound/cmd/api/src/version.majorVersion=${major drv.version}"
      "-X github.com/specterops/bloodhound/cmd/api/src/version.minorVersion=${minor drv.version}"
      "-X github.com/specterops/bloodhound/cmd/api/src/version.patchVersion=${patch drv.version}"
    ];

    subPackages = [
      "cmd/api/src/cmd/bhapi"
    ];

    vendorHash = "sha256-Lm6g0pxGVIuns6mUwnkbnBQQQp1V0TvEakX5fAo8qMo=";

    preBuild = ''
      rm -rf            cmd/api/src/api/static/assets
      cp -r ${frontend} cmd/api/src/api/static/assets
    '';

    postInstall = ''
      mv $out/bin/{bhapi,${pname}}

      wrapProgram $out/bin/${pname} \
        --set BHE_COLLECTORS_BASE_PATH ${collectors}
    '';

    passthru = {
      inherit frontend collectors;
    };

    meta = {
      description = "Six Degrees of Domain Admin";
      homepage = "https://github.com/SpecterOps/BloodHound";
      mainProgram = pname;
    };
  });
in
backend
