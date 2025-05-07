{ config, pkgs, inputs, osConfig, ... }:
let
    font_path = "${pkgs.jetbrains-mono.outPath}/share/fonts/truetype";
in
{
  home.packages = with pkgs; [
  ];
  programs.tofi = {
    enable = true;
    settings = {
      font = "${font_path}/JetBrainsMono-Regular.ttf";
      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;
      background-color = "#000A";
    };
  };
}
