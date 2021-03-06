# TODO(high): Surfingkeys must be composed of two files, the main one and the colemak bindings.
{ config, pkgs, lib, ... }:

with lib;

{
  options.shabka.workstation.chromium.enable = mkEnableOption "workstation.chromium";

  config = mkIf config.shabka.workstation.chromium.enable {
    home.file.".config/chromium/profiles/anya/.keep".text = "";
    home.file.".config/chromium/profiles/ihab/.keep".text = "";
    home.file.".config/chromium/profiles/keeptruckin/.keep".text = "";
    home.file.".config/chromium/profiles/nosecurity/.keep".text = "";
    home.file.".config/chromium/profiles/personal/.keep".text = "";
    home.file.".config/chromium/profiles/vanya/.keep".text = "";

    home.file.".config/chromium/profiles/nosecurity/.cmdline_args".text = ''
      --disable-web-security
    '';

    home.packages = with pkgs; [
      chromium
    ];

    home.file.".surfingkeys.js".text = builtins.readFile (pkgs.substituteAll {
      src = ./surfingkeys.js;

      home_dir = "${config.home.homeDirectory}";
    });
  };
}
