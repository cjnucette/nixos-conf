{ config, pkgs, helix, ... }: {

  imports = [
    ./hardware-configuration.nix
    # ./nvidia-beta.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Enable zram
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    distrobox # podman needs to be enabled
  ];

  virtualisation.podman.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };

  security.sudo.extraConfig = ''
    cjnucette ALL=(ALL) NOPASSWD:ALL
  '';

  networking.hostName = "beta"; # Define your hostname.
  networking.extraHosts = ''
    192.168.0.100 alpha
    192.168.0.110 gamma
  '';
  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  services.openssh.enable = true;
  services.flatpak.enable = true;


  # To manually generate it:
  # mkdir -p /var/cache/man/nixos
  # sudo mandb
  documentation.man.generateCaches = true;

  programs.fuse.userAllowOther = true;

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 1w";
  };

  # nix-index-database
  programs.command-not-found.enable = false;

  # Define users accounts
  users.users.cjnucette = {
    isNormalUser = true;
    description = "Carlos Nucette";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };
}
