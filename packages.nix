{ pkgs, lib, ... }: {
  # Use mkDefault so your Linux flake can safely override these paths
  home.username = lib.mkDefault "kunall";
  home.homeDirectory = lib.mkDefault "/Users/kunall";

  home.packages = with pkgs; [
    nix gh git jq podman podman-compose 
    pbgopy
    go rustc cargo nodejs python315 google-cloud-sdk
  ];

  programs.home-manager.enable = true;
}

