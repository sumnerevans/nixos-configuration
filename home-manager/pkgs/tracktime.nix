{ lib, pkgs }:
with pkgs;
python3Packages.buildPythonApplication rec {
  pname = "tracktime";
  version = "0.10.0";
  format = "pyproject";

  nativeBuildInputs = [ python3Packages.poetry-core ];

  propagatedBuildInputs = with python3Packages; [
    argcomplete
    chromedriver
    docutils
    pass
    pdfkit
    pyyaml
    requests
    selenium
    tabulate
    # wkhtmltopdf
  ];

  doCheck = false;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'requires = ["poetry>=0.12"]' 'requires = ["poetry-core>=1.0.0"]'
    substituteInPlace pyproject.toml \
      --replace 'build-backend = "poetry.masonry.api"' 'build-backend = "poetry.core.masonry.api"'
    substituteInPlace pyproject.toml \
      --replace 'tabulate = "^0.8.7"' 'tabulate = ">=0.8.7"'
  '';

  src = fetchFromGitHub {
    owner = "sumnerevans";
    repo = pname;
    rev = "36da64c101be1ba9838fba4e61bae6efc55b0cc0";
    sha256 = "sha256-1QIgdcGojNl1EPP51kaeNVF5Ll7pfbP9y1VLtqtmi8Q=";
  };

  meta = with lib; {
    description = "Time tracking library with command line interface.";
    homepage = "https://github.com/sumnerevans/tracktime";
    license = licenses.gpl3Plus;
  };
}
