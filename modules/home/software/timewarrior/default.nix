{ config, pkgs, lib, ... }:

with lib;

{
  options.shabka.timewarrior.enable = mkEnableOption "timewarrior";

  config = mkIf config.shabka.timewarrior.enable {
    home.packages = with pkgs; [
      timewarrior
      python # needed by totals.py extension and by on-modify.timewarrior
    ];

    home.file.".timewarrior/timewarrior.cfg".text = builtins.readFile (pkgs.substituteAll {
      src = ./timewarriorcfg;

      timewarrior_out = "${pkgs.timewarrior}";
    });

    home.file.".timewarrior/extensions/totals.py" = {
      source = "${pkgs.timewarrior}/share/doc/timew/ext/totals.py";
      executable = true;
    };

    home.file.".task/hooks/on-modify.timewarrior" = {
      source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
      executable = true;
    };
  };
}
