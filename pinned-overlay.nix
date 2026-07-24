final: prev:
let
  # Helper function to instantiate nixpkgs from a specific tarball URL & hash
  fetchNixpkgs = { url, sha256 }: import (builtins.fetchTarball {
    inherit url sha256;
  }) { system = prev.stdenv.hostPlatform.system; config.allowUnfree = true; };
in {
  # --- Go 1.26.4 ---
  go = (fetchNixpkgs {
    url = "https://github.com/NixOS/nixpkgs/archive/241313f4e8e508cb9b13278c2b0fa25b9ca27163.tar.gz";
    sha256 = "sha256-vlHUuqAcbcH2RKmHbPiuQzbv1pnzzavXnI62RD0bqCU=";
  }).go;

  # --- Rust 1.96.1 ---
  rustc = (fetchNixpkgs {
    url = "https://github.com/NixOS/nixpkgs/archive/241313f4e8e508cb9b13278c2b0fa25b9ca27163.tar.gz";
    sha256 = "sha256-vlHUuqAcbcH2RKmHbPiuQzbv1pnzzavXnI62RD0bqCU=";
  }).rustc;

  cargo = (fetchNixpkgs {
    url = "https://github.com/NixOS/nixpkgs/archive/241313f4e8e508cb9b13278c2b0fa25b9ca27163.tar.gz";
    sha256 = "sha256-vlHUuqAcbcH2RKmHbPiuQzbv1pnzzavXnI62RD0bqCU=";
  }).cargo;

  # --- Node.js 26.5.0 ---
  nodejs = (fetchNixpkgs {
    url = "https://github.com/NixOS/nixpkgs/archive/241313f4e8e508cb9b13278c2b0fa25b9ca27163.tar.gz";
    sha256 = "sha256-vlHUuqAcbcH2RKmHbPiuQzbv1pnzzavXnI62RD0bqCU=";
  }).nodejs_26;

  # --- Python 3.15.0b4 ---
  python315 = (fetchNixpkgs {
    url = "https://github.com/NixOS/nixpkgs/archive/241313f4e8e508cb9b13278c2b0fa25b9ca27163.tar.gz";
    sha256 = "sha256-vlHUuqAcbcH2RKmHbPiuQzbv1pnzzavXnI62RD0bqCU=";
  }).python315;

  # --- Google Cloud SDK 570.0.0 (with enterprise-certificate-proxy & gke-gcloud-auth-plugin) ---
  google-cloud-sdk = let
    pkgs' = fetchNixpkgs {
      url = "https://github.com/NixOS/nixpkgs/archive/241313f4e8e508cb9b13278c2b0fa25b9ca27163.tar.gz";
      sha256 = "sha256-vlHUuqAcbcH2RKmHbPiuQzbv1pnzzavXnI62RD0bqCU=";
    };
    gcp = pkgs'.google-cloud-sdk;
  in gcp.withExtraComponents [
    gcp.components.enterprise-certificate-proxy
    gcp.components.gke-gcloud-auth-plugin
  ];

  # --- VS Code (fix postPatch chmod path on macOS) ---
  vscode = prev.vscode.overrideAttrs (oldAttrs: {
    postPatch = "find . -name rg -exec chmod +x {} + || true";
  });
}
