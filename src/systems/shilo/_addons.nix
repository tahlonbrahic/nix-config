{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/31abaf40-3fc5-40c7-bd02-bf6190b11108";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3D79-C26D";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/c04b23b6-b26b-4ec0-bd85-0bf2b06216d4";}
  ];
}
