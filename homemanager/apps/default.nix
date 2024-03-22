{ config, pkgs, ... }:
{
	imports = [
		./nvim/nvim.nix
		./tmux/tmux.nix
		./hyprland/hyperland.nix
		./waybar/waybar.nix
		];
		}
