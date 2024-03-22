{ config, pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.waybar
    ];
  xdg.configFile.waybar.source = ./dotfiles
}
