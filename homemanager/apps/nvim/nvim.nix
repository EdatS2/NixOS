{ config, pkgs, inputs, ... }:

{
  home.packages = [
    pkgs.nixpkgs-fmt
    pkgs.nixd
    pkgs.cargo
#    pkgs.llm-ls
    pkgs.texliveFull
    pkgs.clang-tools
    pkgs.jdk
    pkgs.python3
    pkgs.nodePackages.bash-language-server
    pkgs.python311Packages.jedi-language-server
    pkgs.ltex-ls
    pkgs.ansible-language-server
    pkgs.lua-language-server
    pkgs.texlab
    pkgs.tree-sitter
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;

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
