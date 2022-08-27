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
  version = "unstable-2022-08-22";

  src = fetchFromGitHub {
    owner = "maubot";
    repo = pname;
    rev = "d574f84079c2469b71e6c09c4b804e8bf6156153";
    sha256 = "sha256-HtViA3i+R05It7ZbSOWc5XpYWfEEJQrdJ8OzPXXW7uU=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    aiohttp
    (asyncpg.overridePythonAttrs (old: rec {
      pname = "asyncpg";
      version = "0.25.0";

      src = fetchPypi {
        inherit pname version;
        sha256 = "sha256-Y/jmppczsoVJfChVRko03mV/LMzSWurutQcYcuk4JUA=";
      };
    }))
    attrs
    bcrypt
    click
    colorama
    CommonMark
    jinja2
    mautrix
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
