{ lib, fetchFromGitLab, python3 }: with python3.pkgs;
let
  linkedin-messaging = callPackage ./linkedin-messaging.nix {};
in
buildPythonPackage rec {
  pname = "linkedin-matrix";
  version = "unstable-2021-09-07";
  format = "pyproject";

  src = fetchFromGitLab {
    owner = "beeper";
    repo = "linkedin";
    rev = "9c3b1acde17585f50182240d4c043904bfc83534";
    sha256 = "sha256-SWZMoY4VFNti1P2sblFTznF23AyjKFlNgrhSLElW2nM=";
  };

  nativeBuildInputs = [
    poetry
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
