{ config, pkgs, ... }:
{
	imports = [
		./nvim/nvim.nix
		./tmux/tmux.nix
		./hyprland/hyperland.nix
        ./hyprlock/hyprlock.nix
		./waybar/waybar.nix
        ./zsh/zsh.nix
        ./alacritty/alacritty.nix
		];
		}
