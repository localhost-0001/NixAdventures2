{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.teletypeOne.hardware.ProPenGo;
in
{
  options.teletypeOne.hardware.ProPenGo = mkEnableOption "Enable ProPenGo";

  config = mkIf cfg{

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "kvm-intel" ];
  boot.kernelModules = [ ];
  boot.kernelParams = [ ];
  
  boot.extraModulePackages = [ ];
  #boot.zfs.devNodes = "/dev/disk/by-label";
  boot.initrd.supportedFilesystems = [ "zfs"];
  boot.supportedFilesystems = [ "zfs" ];
  fileSystems."/" =
    { device = "nvmeRoot/root";
      fsType = "zfs";
    };

  fileSystems."/nix" =
    { device = "nvmeRoot/root/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/home" =
    { device = "nvmeRoot/root/home";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-partuuid/4f6def1b-dec4-a746-a257-dc87e9fd0b0b";
      fsType = "vfat";
    };
  swapDevices = [ ];
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  };
}
