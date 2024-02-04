{
  config,
  pkgs,
  helix,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    # ./nvidia-beta.nix
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.plymouth.enable = true; # pretty splash boot screen

  # Enable zram
  zramSwap.enable = true;

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
    distrobox # podman needs to be enabled
    qemu
    gnome.nautilus-python
    glxinfo
    pciutils
    dict
  ];

  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;

  programs.fuse.userAllowOther = true;
  programs.virt-manager.enable = true;

  environment.variables = {
    EDITOR = "nvim";
  };
  environment.etc."dict.conf".text = ''
    server localhost
    server dict.org
    server dict0.us.dict.org
    server alt0.dict.org
  '';

  security.sudo.extraConfig = ''
    cjnucette ALL=(ALL) NOPASSWD:ALL
  '';

  networking.hostName = "beta"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.extraHosts = ''
    192.168.0.100 alpha
    192.168.0.110 gamma
  '';
  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [22 445 139];
  networking.firewall.allowedUDPPorts = [137 138];
  networking.firewall.extraCommands = ''iptables -t raw -A OUTPUT -p udp -m udp --dport 137 -j CT --helper netbios-ns'';
  networking.firewall.allowPing = true;

  # services
  services.openssh.enable = true;
  services.flatpak.enable = true;
  services.gvfs.enable = true;
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    extraConfig = ''
         workgroup = WORKGROUP
         netbios name = beta
      disable netbios = yes
      client min protocol = NT1
      server min protocol = NT1
         server string = %h server (Samba, NixOS)
      server role = standalone server
         security = user
         hosts allow = 192.168.0. 127.0.0.1 localhost
         hosts deny = 0.0.0.0/0
      name resolve order = bcast host
         guest account = nobody
         map to guest = bad user
    '';
    shares = {
      documents = {
        path = "/home/cjnucette/Documents";
        browseable = true;
        comment = "beta's documents";
        "read only" = "no";
        "guest ok" = "no";
      };
    };
  };

  services.dictd = {
    enable = true;
    DBs = with pkgs.dictdDBs; [
      wordnet
      epo2eng
    ];
  };

  # To manually generate it:
  # mkdir -p /var/cache/man/nixos
  # sudo mandb
  documentation.man.generateCaches = true;

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
    extraGroups = ["networkmanager" "wheel" "libvirtd"];
    packages = with pkgs; [
      #  thunderbird
    ];
  };
}
