{
  pkgs ? import <nixpkgs> {}
}:
pkgs.stdenv.mkDerivation rec {
  pname = "adi1090x-plymouth";
  version = "0.0.1";

  src = builtins.fetchGit {
    url = "https://github.com/adi1090x/plymouth-themes";
    ref = "master";
    rev = "bf2f570bee8e84c5c20caac353cbe1d811a4745f";
  };

  buildInputs = [
    pkgs.git
  ];

  configurePhase = ''
mkdir -p $out/share/plymouth/themes/
  '';

  buildPhase = ''
  '';

  installPhase = ''
  cp -r pack_2/dragon $out/share/plymouth/themes
cat pack_2/dragon/dragon.plymouth | sed  "s@\/usr\/@$out\/@" > $out/share/plymouth/themes/dragon/dragon.plymouth
  '';
}