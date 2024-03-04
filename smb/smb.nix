{ config, pkgs, ... }:
{
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  fileSystems."/home/kusanagi/SIB" = {
    device = "//192.168.0.15/Fileshare";
    fsType = "cifs";
    options = let
      automount_opts = "_netdev,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
    in ["${automount_opts},credentials=/etc/nixos/keys/smb-secrets,uid=1000,gid=100"];
    };
}
