{ config, pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.cargo
    pkgs.llm-ls
    pkgs.texliveFull
  ];

  programs.neovim = {
    enable = true;

    # Enable other frameworks for plugins.
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    # Setup aliasing.
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    # Using normal neovim config to allow reuse on other systems.
  };

  xdg.configFile."nvim".source = ./dotfiles;
}
