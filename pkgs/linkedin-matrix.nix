{ lib, fetchFromGitHub, python3 }: with python3.pkgs;
let
  linkedin-messaging = callPackage ./linkedin-messaging.nix { };
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "unstable-2022-09-13";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "beeper";
    repo = "linkedin";
    rev = "1497327c96daa6ee8173d25ecdb4d553fc259112";
    sha256 = "sha256-zdq+2UzdTkZs1gq/fohYKzfGRavO8cDZRogTuT6wmyU=";
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
    (mautrix.overridePythonAttrs (
      old: rec {
        pname = "mautrix";
        version = "0.17.8";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-DFajAD5mnXLQmJGRv4j2mWhtIj77nZNSQhbesX4qMys=";
        };
      }
    ))
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
    homepage = "https://github.com/beeper/linkedin";
    license = licenses.asl20;
    maintainers = [ maintainers.sumnerevans ];
  };
}
