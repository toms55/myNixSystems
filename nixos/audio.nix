{ lib, hasBluetooth ? false, ... }:

{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  hardware.bluetooth = lib.mkIf hasBluetooth {
    enable = true;
    powerOnBoot = true;
    settings.Policy.AutoEnable = true;
  };

  services.blueman.enable = hasBluetooth;

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
