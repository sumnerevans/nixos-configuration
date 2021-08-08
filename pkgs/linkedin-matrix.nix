{ lib, fetchFromGitLab, python3 }: with python3.pkgs;
let
  mautrix = callPackage ./mautrix.nix {};
  linkedin-messaging = callPackage ./linkedin-messaging.nix {};
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "unstable-2021-08-07";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "400118adc35886bf1d9af6567e61a74fd0fc272f";
    sha256 = "sha256-t9anyBT+B1Xm7zPjjTEWb1vB33lRpm7cwDUETYE/xmE=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry
  ];

  propagatedBuildInputs = [
    asyncpg
    CommonMark
    linkedin-messaging
    mautrix
    pillow
    prometheus_client
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
