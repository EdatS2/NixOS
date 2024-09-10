{ pkgs, inputs, ... }:
{
  home.packages = with pkgs; [
    hyprlock
  ];
  xdg.configFile.hyprlock.source = ./dotfiles;
}
