# The goal
Coming from an Arch setup with x11, i3 window manager and ext4, the goal of this setup is to incorporate new technologies in the setup and use lessons learned from using Arch for 3 years. As such a shortlist of goals would be
- wayland
- btrfs
- disk encryption

### Wayland
The adoption of wayland has been quite slow, mostly because many distro's switch with x11 as default and if it 'just works' why would you switch? 
Wayland was created to replace X and rid us of the patchwork that it has slowly become over the years. Wayland tries to do away with some of the complexities of X by incorporating the display manager and display server as one. Overall Wayland has now reached a level of maturity that running it daily should not be an issue and this config aims to do so.

### BTRFS
BTRFS is a CoW file system that offers snapshot capabilities that ext4 does not, therefore it supports snapshots and is very usable for backups. This is a functionality that was missing in the arch setup that relies on ext4. 

### Disk encryption
The prior setup used disk encryption based on `dm-crypt` with `lvm` on top, the boot partition was outside the encrypted partition. The NIX configuration will aim to address this. 

# NIX
This repo details and holds my NixOS configuration, some details
- Hyprland
- Grub
- luks2 encrypted
- btrfs
- homemanager
- flakes

## Detailed explanation
### Grub & luks2
The system is fully encrypted, which is why Grub is used and not the systemd bootloader, which does not support encrypting the boot partition.
Grub was installed using [this](https://nixos.wiki/wiki/Full_Disk_Encryption) guide for disk encryption.
A thing to watch out for is generating the encryption keys for luks
`cryptsetup addKey` generated argonID2 keys by default, however grub by default cannot understand these and will not unlock the partition. As such the keys should be generated with `cryptsetup addKey--pbkdf pbkdf2`, which does unlock. 

### BTRFS
On top of the luks container a [BTRFS](https://wiki.archlinux.org/title/btrfs) filesystem is created following [this guide for NixOS](https://nixos.wiki/wiki/Btrfs) where a change is made towards the end where the guide suggests mounting the bootloader at `/boot`, this would conflict with the full disk encryption goal and as such the mounting from the guide named prior is followed. The partition setup as suggested in the guide is compliant with an [impermanent](https://nixos.wiki/wiki/Impermanence) setup and this will be tried in the future. 

### Homemanager & flakes
After reading this [blog](https://writerit.nl/software/nixos/my-personal-journey-into-nixos/) the decision was made to also use flakes and homemanager. The setup of these two does not differ from the guides outlines on the NixOS wiki. But they are henceforth used to configure the rest of the system.

### Wayland and Nixos
Most of the Nix wiki seems to point towards the usage of x11 however aim of this configuration is to use wayland, as such the Nix wiki is not that helpfull. If not in possession of a 2 gpu laptop, which requires either nvidia prime or an environmental variable to point wayland to the right gpu. The setup is easy, setup hyprland with homemanager as outlined on the hyprland wiki and off to the races. The setup process with a laptop with a dgpu is a bit more tedious
1. Use the nouveau driver and the environmental variable `ENV_WLR_DEVICES`
2. Install NVIDIA drivers and setup prime

## Future goals
A few wants are not yet realized in this configuration, automatic btrfs snapshot backups to a remote target are not yet implemented. 
Furthermore, the system does not yet utilize secure boot, because the secure boot project for NixOS [Lanzaboote](https://github.com/nix-community/lanzaboote) is focussed on systemd boot, not grub. Following the playbook as set out on the [arch wiki](https://wiki.archlinux.org/title/GRUB#Secure_Boot_support) should be possible, and it could possibly be made into a nix package, however I have not tried this yet. 


