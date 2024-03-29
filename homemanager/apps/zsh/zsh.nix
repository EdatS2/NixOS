{ config, pkgs, inputs, ... }:
{
    home.packages = with pkgs; [
#        thefuck
    ];
programs.zsh = {
  enable = true;
  enableCompletion = true;
  enableAutosuggestions = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    rebuild = ''sudo nixos-rebuild --flake "/etc/nixos?submodules=1#ishikawa" switch''; 
    edit = "cd /etc/nixos; nvim .";
    update = ''sudo nix flake --flake "/etc/nixos#ishikawa" --commit-lock-file update'';
  };
  history.size = 10000;
  history.path = "${config.xdg.dataHome}/zsh/history";
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" 
#                "thefuck"
                "direnv"];
    theme = "robbyrussell";
  };
};

}
