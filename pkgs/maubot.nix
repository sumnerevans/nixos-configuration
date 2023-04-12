{ lib
, fetchpatch
, fetchFromGitHub
, python3
, yarn
, fixup_yarn_lock
, nodejs
, fetchYarnDeps
}:
python3.pkgs.buildPythonPackage rec {
  pname = "maubot";
  version = "unstable-2023-04-12";

  src = fetchFromGitHub {
    owner = "maubot";
    repo = pname;
    rev = "184d6b8eedf4710fc3ded28039264ed997e6336c";
    sha256 = "sha256-5DY9qFPXg+rF4Nczx0wd4uKckGWWETqlmtbNtiYQDn4=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    asyncpg
    attrs
    bcrypt
    click
    colorama
    CommonMark
    jinja2
    (mautrix.overridePythonAttrs (
      old: rec {
        pname = "mautrix";
        version = "0.19.9";

        src = pkgs.fetchFromGitHub {
          owner = "mautrix";
          repo = "python";
          rev = "refs/tags/v${version}";
          hash = "sha256-GyviaWFPiT0ka0IUFU53DLPT8R8kRhTztvKTG9b7ads=";
        };
      }
    ))
    packaging
    python-socks
    questionary
    ruamel-yaml
    sqlalchemy
    python-olm
    pycryptodome
    unpaddedbase64
  ];

  nativeBuildInputs = [ fixup_yarn_lock yarn nodejs ];

  offlineCache = fetchYarnDeps {
    yarnLock = src + "/maubot/management/frontend/yarn.lock";
    sha256 = "sha256-VBPZbtqF9u63yRgk0PObhUMvV8s7UXSs6nr87cPeLz4=";
  };

  configurePhase = ''
    runHook preConfigure

    export HOME=$PWD/tmp
    mkdir -p $HOME

    pushd maubot/management/frontend
    fixup_yarn_lock yarn.lock
    yarn config --offline set yarn-offline-mirror $offlineCache
    yarn install --offline --frozen-lockfile --ignore-platform --ignore-scripts --no-progress --non-interactive
    patchShebangs node_modules
    popd

    runHook postConfigure
  '';

  preBuild = ''
    pushd maubot/management/frontend
    yarn build
    popd
  '';

  postPatch = ''
    sed -i -e 's/SQLAlchemy>=1,<1.4/SQLAlchemy/' requirements.txt
    sed -i -e 's/bcrypt>=3,<4/bcrypt/' requirements.txt
  '';

  postInstall = ''
    mkdir -p $out/bin

    cat <<-END >$out/bin/maubot
    #!/bin/sh
    PYTHONPATH="$PYTHONPATH" exec ${python3}/bin/python -m maubot "\$@"
    END
    chmod +x $out/bin/maubot
  '';

  doCheck = false;

  meta = with lib; {
    description = "A bouncer-style Matrix-IRC bridge.";
    homepage = "https://github.com/maubot/maubot";
    license = licenses.agpl3Plus;
    maintainers = [ maintainers.sumnerevans ];
  };
}
