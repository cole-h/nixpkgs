{ lib
, buildPythonPackage
, fetchFromGitHub
, capstone
, nose
, pyelftools
, tlsh
}:
buildPythonPackage {
  pname = "telfhash";
  version = "unstable-2021-01-29";

  src = fetchFromGitHub {
    owner = "trendmicro";
    repo = "telfhash";
    rev = "b5e398e59dc25a56a28861751c1fccc74ef71617";
    sha256 = "jNu6qm8Q/UyJVaCqwFOPX02xAR5DwvCK3PaH6Fvmakk=";
  };

  # The tlsh library's name is just "tlsh"
  preBuild = ''
    sed 's@python-tlsh@tlsh@' -i requirements.txt
  '';

  propagatedBuildInputs = [
    capstone
    nose
    pyelftools
    tlsh
  ];

  meta = with lib; {
    description = "Symbol hash for ELF files";
    homepage = "https://github.com/trendmicro/telfhash";
    license = licenses.asl20;
  };
}
