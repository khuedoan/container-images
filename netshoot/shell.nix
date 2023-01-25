# https://status.nixos.org (nixos-22.11)
{ pkgs ? import (fetchTarball "https://github.com/NixOS/nixpkgs/archive/2dea8991d89b.tar.gz") {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    aria2
    curl
    grpcurl
    httpie
    jq
    jq
    neovim
    openssh
    speedtest-cli
    termshark
    wget
    yq-go
  ];
}
