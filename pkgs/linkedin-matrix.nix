{ lib, fetchFromGitLab, python3 }: with python3.pkgs;
let
  linkedin-messaging = callPackage ./linkedin-messaging.nix { };
  mautrix = pkgs.python3Packages.mautrix.overridePythonAttrs (
    old: rec {
      pname = "mautrix";
      version = "0.11.3";

      src = pkgs.python3.pkgs.fetchPypi {
        inherit pname version;
        sha256 = "sha256-eZ8fWemS808Hz6KoQWfMsk5WfaO+vj0kTyInhtE20Qk=";
      };

      doCheck = false;
    }
  );
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "unstable-2021-11-14";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "af01ac5217439dc91d8d9d4ec6eb9fd1b1acb34f";
    sha256 = "sha256-BuYVmTKj6saSkMZkSFQ6S542ptcAucL5I+a1xGxCMUc=";
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
