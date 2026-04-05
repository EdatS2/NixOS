{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
    pkgs.waybar
    pkgs.networkmanager_dmenu
  ];
  xdg.configFile.waybar.source = ./dotfiles;
}
