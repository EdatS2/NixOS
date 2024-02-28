# Nixos configuration
This repo details my holds my NixOS configuration, some details
- Hyprland
- Grub
- luks2 encrypted
- btrfs
- homemanager
- flakes

## Detailed explanation
### Grub & luks2
The system is fully encrypted, which is why Grub is used and not the systemd bootloader, which does not support encrypting the boot partition.
Grub was installed using [this]{https://nixos.wiki/wiki/Full_Disk_Encryption} guide for disk encryption.
A thing to watch out for is generating the encryption keys for luks
'cryptsetup addKey' generated argonID2 keys by default, however grub by default cannot understand these and will not unlock the partition. As such the keys should be generated with 'cryptsetup addKey--pbkdf pbkdf2', which does unlock. 
