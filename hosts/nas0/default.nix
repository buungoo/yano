{ inputs, outputs, vars, pkgs, ... }:

{
  imports = [
    ../common.nix
    ./hardware-configuration.nix
    ./storage.nix

    ../../containers/immich.nix

    ../../services/jobs.nix
    ../../services/proxy.nix
  ];

  environment.systemPackages = with pkgs; [
    lazydocker
    mergerfs
    tailscale
  ];

  services.tailscale.enable = true;

  services = {
    openssh = {
      enable = true;
      settings = {
        LogLevel = "VERBOSE";
        PasswordAuthentication = false; # Disable password authentication
        PermitRootLogin = "prohibit-password"; # Only allow root login with SSH keys
        KbdInteractiveAuthentication = false; # Disable interactive authentication
      };
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 3;
    bantime = "60m";
    # daemonSettings = {
    #   Definition = {
    #     logtarget = "/var/log/fail2ban.log";
    #   };
    # };
    jails = {
      #    DEFAULT = {
      #      settings = {
      #        loglevel = "DEBUG";  # Set global log level to DEBUG
      # logpath = "/var/log/fail2ban.log";  # Log to a file instead of the journal
      # findtime = "1m";
      #      };
      #    };
      sshd = {
        settings = {
          enable = true;
          port = "22";
          filter = "sshd";
          # logpath = "/var/log/auth.log";
        };
      };
    };
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
      daemon.settings = {
        hosts = [
          "unix:///var/run/docker.sock" # Keep the Unix socket for local access
          # "tcp://0.0.0.0:2375"           # Listen on all interfaces on port 2375
        ];
      };
    };
  };
}
