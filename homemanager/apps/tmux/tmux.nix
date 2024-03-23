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
    extraConfig = ''
      source-file ~/.config/tmux/keybinds.conf
    '';
  };
  home.file.".config/tmux/keybinds.conf".source = ./dotfiles/tmux.conf;
}
