FROM docker.io/library/node:22 AS builder

WORKDIR /usr/local/src

RUN git clone --depth 1 https://seed.radicle.xyz/z4V1sjrXqjvFdnCUbxPFqd5p4DtH5.git radicle-explorer

WORKDIR /usr/local/src/radicle-explorer

RUN npm install

COPY config/local.json config/local.json

RUN npm run build

FROM docker.io/library/caddy

COPY --from=builder /usr/local/src/radicle-explorer/build /usr/share/caddy

COPY Caddyfile /etc/caddy/Caddyfile
