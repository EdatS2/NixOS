{ inputs, pkgs, hyprland, config, ... }:
{
  imports = [
    ./apps
  ];
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };
  xdg.enable = true;
  home.username = "kusanagi";
  home.homeDirectory = "/home/kusanagi";
  programs.home-manager.enable = true;
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };
    bash = {
      enable = true;
      bashrcExtra = ''
        				eval "$(direnv hook bash)"
        			'';
    };
  };
  home.packages = with pkgs; [
    unzip
    thunderbird-latest
    wofi
    swww
    dunst
    brightnessctl
    pamixer
    networkmanagerapplet
    waybar
    git
    swaylock-effects
    btop
    discord
    moonlight-qt
    psst
    playerctl
    teams-for-linux
    hunspell
    onedrive
    libreoffice
    pcmanfm
    lxmenu-data
    shared-mime-info
    via #for configuring keyboard
    sshfs #mounting remote filesystems
    uefitool #for bios editing
    prusa-slicer #3dprinting
    hyprshot #screenshots
    inkscape-with-extensions #to create eps images for reports
    darktable #for editing raws
    gimp #editing png
    nufraw-thumbnailer #preview raw files
    poppler_gi #pdf thumbnails
    libgsf #docs odf thumbnails
    geekbench_6 #benchmark
    zapzap #whatsapp
    pavucontrol #for controlling audio
    traceroute #finding out connection issues
    fastfetch #flex the config
    inxi #for checking battery life
    pomodoro-gtk #title says all
    borgbackup #for backup
    vorta #frontend for borg
    remmina #for remote desktop
    kernelshark
  ];
  systemd.user.startServices = "sd-switch";
  home.stateVersion = "23.11";
}
