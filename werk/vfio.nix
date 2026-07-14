{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.nixos-vfio.nixosModules.vfio
  ];
  programs.virt-manager.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    onBoot = "ignore";
    sshProxy = false;
    qemu.swtpm.enable = true;
    deviceACL = [
      "/dev/kvm"
      "/dev/kvmfr0"
      "/dev/kvmfr1"
      "/dev/kvmfr2"
      "/dev/shm/scream"
      "/dev/shm/looking-glass"
      "/dev/null"
      "/dev/full"
      "/dev/zero"
      "/dev/random"
      "/dev/urandom"
      "/dev/ptmx"
      "/dev/kvm"
      "/dev/kqemu"
      "/dev/rtc"
      "/dev/hpet"
      "/dev/vfio/vfio"
    ];
  };
  environment.systemPackages = with pkgs; [
    virtiofsd
    looking-glass-client
    dnsmasq
  ];
  services.udev.packages = lib.singleton (
    pkgs.writeTextFile {
      name = "kvmfr";
      text = ''
        SUBSYSTEM=="kvmfr", GROUP="kvm", MODE="0660", TAG+="uaccess"
      '';
      destination = "/etc/udev/rules.d/70-kvmfr.rules";
    }
  );

  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.vfio = {
    enable = true;
    IOMMUType = "intel";
    devices = [
    ];
  };

  virtualisation.kvmfr = {
    enable = true;
    devices = lib.singleton {
      size = 128;
      permissions = {
        user = "kusanagi";
        mode = "0777";
      };
    };
  };
  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };

  boot.blacklistedKernelModules = [
    "amdgpu"
    "radeon"
  ];

}
