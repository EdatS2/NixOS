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
      nvim-treesitter
      vim-fugitive
      nvim-cmp
      lazy-nvim
      which-key-nvim
      comment-nvim
      vimtex
      nvim-lspconfig
      nvim-treesitter-parsers.mermaid
      (pkgs.vimUtils.buildVimPlugin {
        name = "devcontainers-nvim";
        src = pkgs.fetchFromGitHub {
          owner = "jedrzejboczar";
          repo = "devcontainers.nvim";
          rev = "d8910dbf668b9db7dc21c9ef5c1aea800de804df";
          sha256 = "0qwknjgc0a2i7wbawy4vhfvva4hqcgfl9vjb0454jqr9dwn3sb92";
        };
      })
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
      pkgs.typescript-language-server
      pkgs.pyright
      pkgs.devcontainer
    ];

    # Using normal neovim config to allow reuse on other systems.
  };

  xdg.configFile."nvim".source = ./dotfiles;
}
