# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d015a84b-467f-47d2-a955-7f3f4144c5b4";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."enc".device = "/dev/disk/by-uuid/06c8ef8c-1675-4d75-8222-14814e71d3c7";
  boot.supportedFilesystems = [ "btrfs" ];

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/d015a84b-467f-47d2-a955-7f3f4144c5b4";
      fsType = "btrfs";
      options = [ "subvol=home"  "compress=zstd" "noatime"];
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/d015a84b-467f-47d2-a955-7f3f4144c5b4";
      fsType = "btrfs";
      options = [ "subvol=nix"  "compress=zstd" "noatime"];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/d015a84b-467f-47d2-a955-7f3f4144c5b4";
      fsType = "btrfs";
      options = [ "subvol=persist"  "compress=zstd" "noatime"];
    };

  fileSystems."/var/log" =
    { device = "/dev/disk/by-uuid/d015a84b-467f-47d2-a955-7f3f4144c5b4";
      fsType = "btrfs";
      options = [ "subvol=log"  "compress=zstd" "noatime"];
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D16C-FC77";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp3s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
