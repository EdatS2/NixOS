{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
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
    plugins = with pkgs.vimPlugins; [
      telescope-nvim
      gruvbox-baby
      harpoon
      undotree
      vim-tmux-navigator
      luasnip
    ];
    extraPackages = with pkgs; [
      pkgs.nixpkgs-fmt
      pkgs.nixd
      pkgs.cargo
      #    pkgs.llm-ls
      pkgs.texliveFull
      pkgs.clang-tools
      pkgs.jdk
      pkgs.python3
      pkgs.bash-language-server
      # pkgs.python311Packages.jedi-language-server
      pkgs.ltex-ls
      pkgs.lua-language-server
      pkgs.texlab
      pkgs.tree-sitter
      pkgs.ripgrep
      pkgs.zls
      pkgs.marksman
      pkgs.vscode-extensions.vadimcn.vscode-lldb
      pkgs.nixfmt
    ];

    # Using normal neovim config to allow reuse on other systems.
  };

  xdg.configFile."nvim".source = ./dotfiles;
}
