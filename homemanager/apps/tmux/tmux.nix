{ config, pkgs, inputs, ... }:

{

  programs.tmux = {
    enable = true;
    # General settings
    clock24 = true;
    keyMode = "vi";
    sensibleOnTop = true;
    mouse = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      sensible
      resurrect
      continuum
    ];
  };
}
