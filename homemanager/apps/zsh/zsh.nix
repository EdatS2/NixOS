{ config, pkgs, inputs, osConfig, ... }:
{
    home.packages = with pkgs; [
#        thefuck
    ];
programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;

  shellAliases = {
    ll = "ls -l";
    rebuild = ''sudo nixos-rebuild --flake "/etc/nixos?submodules=1#${osConfig.networking.hostName}" switch''; 
    edit = "cd /etc/nixos; nvim .; cd $(echo $OLDPWD)";
    update = ''cd /etc/nixos; nix flake update --commit-lock-file; cd $(echo $OLDPWD)'';
    tvim = "vim $(tv)";
    text = ''tv text | xargs -oI {} sh -c 'vim "$(echo {} | cut -d ":" -f 1)" +$(echo {} | cut -d ":" -f 2)' '';
    tgit = "cd $(tv git-repos)";
  };
  history.size = 10000;
  history.path = "${config.xdg.dataHome}/zsh/history";
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" 
#                "thefuck"
                "direnv"];
    theme = "half-life";
  };
  sessionVariables = {
    PATH = "$HOME/.cargo/bin:$PATH";
  };
};

}
