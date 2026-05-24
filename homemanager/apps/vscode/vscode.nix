{ config, pkgs, inputs, osConfig, ... }:
{
    home.packages = with pkgs; [
#        thefuck
    ];
programs.vscode = {
    enable = true;
    # enable = if osConfig.networking.hostName == "saito" then true else false;
    extensions = with pkgs.vscode-extensions; [
        vscodevim.vim
    ];
    mutableExtensionsDir = true;
    package = pkgs.vscode;
};
}
