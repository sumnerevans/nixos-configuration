{ lib, fetchFromGitLab, python3 }: with python3.pkgs;
let
  linkedin-messaging = callPackage ./linkedin-messaging.nix { };
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "unstable-2022-07-06";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "bb7449e424aaf0c541bc5d616c0d61fbba7ae5ff";
    sha256 = "sha256-vQiZ/hbL/Uig9fFBu9AxwQlpwy7qf71vx46rgvTc7pw=";
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
        version = "0.16.10";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-TctTY5nq4JFj1Nhi8DCiIqRMEqJpxZOF6usS/lTKYSM=";
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
    homepage = "https://gitlab.com/beeper/linkedin";
    license = licenses.asl20;
    maintainers = [ maintainers.sumnerevans ];
  };
}
