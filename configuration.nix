# extracted from a nixops deployment configuration for reference. 
# don't expect this to work as is
{
    # imports = [ ../service.nix ];

    networking.firewall.allowedTCPPorts = [ 22 80 443 ];

     security.acme = {
        acceptTerms = true;
        email = "secops+acme@MYDOMAIN.TLD";
      };

    systemd.services.nix-minimal = {
      description = "example web service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = "${nix-minimal-exe}/bin/nix-minimal";
        Restart = "always";
        KillMode = "process";
      };
    };
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      virtualHosts."subdomain.MYDOMAIN.TLD" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:8080";
          proxyWebsockets = true;
          extraConfig = "proxy_pass_header Authorization;";
        };
      };
    };
    users.groups.acme.members = [ "nginx" ];
  }
