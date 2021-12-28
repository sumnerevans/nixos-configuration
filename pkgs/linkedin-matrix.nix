{ lib, fetchFromGitLab, python3 }: with python3.pkgs;
let
  linkedin-messaging = callPackage ./linkedin-messaging.nix { };
  mautrix = pkgs.python3Packages.mautrix.overridePythonAttrs (
    old: rec {
      pname = "mautrix";
      version = "0.14.0";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-WtBOh7zzHrNHn908q9UIKyVwE+XAD2s2lTmitYSvra8=";
      };

      doCheck = false;
    }
  );
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "0.5.2";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "v${version}";
    sha256 = "sha256-BG0QJgpxZpdJ67cIO+AK+0Jt2bZcmAnUEy8wAPP2cac=";
  };

  nativeBuildInputs = [
    poetry
  ];

  propagatedBuildInputs = [
    aiohttp
    asyncpg
    cffi
    CommonMark
    linkedin-messaging
    mautrix
    pillow
    prometheus_client
    pycryptodome
    python-olm
    python_magic
    ruamel-yaml
    systemd
    unpaddedbase64
  ];

  postInstall = ''
    mkdir -p $out/bin

    # Make a little wrapper for running linkedin-matrix with its dependencies
    echo "$linkedinMatrixScript" > $out/bin/linkedin-matrix
    echo "#!/bin/sh
      exec python -m linkedin_matrix \"\$@\"
    " > $out/bin/linkedin-matrix
    chmod +x $out/bin/linkedin-matrix
    wrapProgram $out/bin/linkedin-matrix \
      --set PATH ${python3}/bin \
      --set PYTHONPATH "$PYTHONPATH"
  '';

  pythonImportsCheck = [ "linkedin_matrix" ];

  meta = with lib; {
    description = "A LinkedIn Messaging <-> Matrix bridge.";
    homepage = "https://gitlab.com/beeper/linkedin";
    license = licenses.asl20;
    maintainers = [ maintainers.sumnerevans ];
  };
}
