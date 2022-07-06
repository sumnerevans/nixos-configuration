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
    rev = "79e6dd458561a87575559a435aac58d164b4672a";
    sha256 = "sha256-boG99dwM+LaGxyRBXsatrvPZrnz3Fprsk3QYwFoDE4E=";
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
        version = "0.17.1";

        src = fetchPypi {
          inherit pname version;
          sha256 = "sha256-diWd75CUc4Cz9HRD+l3RsIshNxfMo7jDEYGK2j168R4=";
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
