{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, aiohttp
, asyncpg
, attrs
, CommonMark
, lxml
, prometheus_client
, pycryptodome
, python-olm
, python_magic
, ruamel_yaml
, sqlalchemy
, unpaddedbase64
, uvloop
, yarl
}:

buildPythonPackage rec {
  pname = "mautrix";
  version = "0.10.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-D4lVTOiHdsMzqw/1kpNdvk3GX1y/stUaCCplXPu2/88=";
  };

  propagatedBuildInputs = [
    # requirements.txt
    aiohttp
    attrs
    yarl

    # optional-requirements.txt
    CommonMark
    asyncpg
    lxml
    prometheus_client
    pycryptodome
    python-olm
    python_magic
    ruamel_yaml
    sqlalchemy
    unpaddedbase64
    uvloop
  ];

  # no tests available
  doCheck = false;

  pythonImportsCheck = [
    # https://github.com/mautrix/python#components
    "mautrix"
    "mautrix.api"
    "mautrix.client.api"
    "mautrix.appservice"
    "mautrix.crypto"
    "mautrix.bridge"
    "mautrix.client"
  ];

  meta = with lib; {
    homepage = "https://github.com/mautrix/python";
    description = "A Python 3 asyncio Matrix framework.";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nyanloutre ma27 ];
  };
}
