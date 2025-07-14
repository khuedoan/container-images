FROM nixos/nix

RUN echo 'experimental-features = flakes nix-command' >> /etc/nix/nix.conf \
    && echo 'filter-syscalls = false' >> /etc/nix/nix.conf
