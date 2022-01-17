{ lib, fetchFromGitLab, python3 }: with python3.pkgs;
let
  linkedin-messaging = callPackage ./linkedin-messaging.nix { };
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "0.5.2";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "c2923ef60824d0f58857e68f600d7f3af73b4b34";
    sha256 = "sha256-L+FrnYtjM0ep8G/FqZDJhWB7vRZl77MKFselbTdfEOk=";
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
