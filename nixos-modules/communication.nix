{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.teletypeOne.communication;
  discord-latest = pkgs.discord.overrideAttrs (old: {
    version = "0.0.16";
    src = pkgs.fetchurl {
      url = "https://dl.discordapp.net/apps/linux/0.0.16/discord-0.0.16.tar.gz";
      sha256 = "sha256-UTVKjs/i7C/m8141bXBsakQRFd/c//EmqqhKhkr1OOk=";
    };
  });
in {
  options.teletypeOne.communication = {
    free = mkEnableOption "Install free communication tools.";
    nonFree = mkEnableOption "Install nonfree communication tools.";
    bullshit = mkEnableOption "Install dumb communication tools.";
    mailGui = mkEnableOption "Install and add gui mail tools.";
    mailTui = mkEnableOption "Install and add tui mail tools";
  };

  config = (mkMerge [
    (mkIf (cfg.free) {
      environment.systemPackages = with pkgs; [signal-desktop element-desktop];
    })

    (mkIf (cfg.nonFree) {
      environment.systemPackages = with pkgs; [discord-latest];
    })

    (mkIf (cfg.bullshit) {
      environment.systemPackages = with pkgs; [teams];
    })

    (mkIf cfg.mailGui {
      environment.systemPackages = with pkgs; [thunderbird];
    })

    (mkIf cfg.mailTui {
      environment.systemPackages = with pkgs; [neomutt curl isync msmtp pass lynx notmuch abook urlview];
      programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        pinentryFlavor = "curses";
      };
    })
  ]);
}
