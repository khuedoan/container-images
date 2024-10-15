FROM ghcr.io/actions/actions-runner:latest

RUN curl -sSLf https://install.determinate.systems/nix \
    | sh -s -- install linux \
        --extra-conf "sandbox = false" \
        --init none \
        --no-confirm
