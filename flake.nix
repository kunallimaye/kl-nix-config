{
  description = "Cross-Platform Single-List Nix Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: {
    # macOS Configuration
    darwinConfigurations."mac" = inputs.nix-darwin.lib.darwinSystem {
      modules = [
        ({ pkgs, ... }: {
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ (import ./pinned-overlay.nix) ];
          nix.enable = false;
          nix.settings.experimental-features = "nix-command flakes";
          system.stateVersion = 5;
          environment.systemPackages = [ pkgs.nix ];
          environment.systemPath = [ "/nix/var/nix/profiles/default/bin" ];
          environment.extraInit = ''
            export PATH="/nix/var/nix/profiles/default/bin:$PATH"
          '';
          system.activationScripts.postActivation.text = ''
            mkdir -p /usr/local/bin
            ln -sf /nix/var/nix/profiles/default/bin/nix* /usr/local/bin/
          '';
          users.users.kunall = {
            name = "kunall";
            home = "/Users/kunall";
          };
        })
        inputs.home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.kunall = {
            imports = [ ./packages.nix ];
            home.stateVersion = "26.11";
          };
        }
      ];
    };

    # Linux Configuration
    # NOTE: Change "kunall" here if your Ubuntu/Debian username is different!
    homeConfigurations."kunall" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        {
          home.username = "kunall";
          home.homeDirectory = "/home/kunall";
          nixpkgs.config.allowUnfree = true;
          nixpkgs.overlays = [ (import ./pinned-overlay.nix) ];
          home.stateVersion = "26.11"; 
        }
        ./packages.nix
      ];
    };
  };
}

