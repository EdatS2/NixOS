{
  stdenv,
  lib,
  bash,
  coreutils,
  wofi,
  rofi,
  dmenu,
  procps,
  iproute2,
  systemd,
}:

stdenv.mkDerivation {
  pname = "vpn-manager";
  version = "1.0.0";

  src = ./scripts;

  nativeBuildInputs = [
    bash
    coreutils
    wofi
    rofi
    dmenu
    procps
    iproute2
    systemd
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp *.sh $out/bin/
    chmod +x $out/bin/*
  '';

  meta = with lib; {
    description = "WireGuard VPN management scripts for Waybar";
    homepage = "https://github.com/robertkokenyesi/vpn-manager";
    license = licenses.mit;
    maintainers = [ ];
  };
}
