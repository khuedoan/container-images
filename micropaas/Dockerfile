FROM nixos/nix:latest

RUN echo 'experimental-features = flakes nix-command' >> /etc/nix/nix.conf

RUN nix-env -iA \
    nixpkgs.soft-serve \
    nixpkgs.git

ENV SOFT_SERVE_DATA_PATH=/var/lib/micropaas
ENV SOFT_SERVE_HTTP_LISTEN_ADDR=:80
ENV SOFT_SERVE_SSH_LISTEN_ADDR=:22

WORKDIR ${SOFT_SERVE_DATA_PATH}

COPY ./hooks ./hooks

CMD [ "soft", "serve" ]
