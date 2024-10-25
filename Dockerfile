FROM --platform=$BUILDPLATFORM madebytimo/scripts AS builder

ARG TARGETPLATFORM

WORKDIR /root/builder
COPY files/download-p2pool.sh /usr/local/bin/

RUN download-p2pool.sh

FROM madebytimo/base

# RUN install-autonomous.sh install  \
#     && apt update -qq && apt install -y -qq  \
#     && rm -rf /var/lib/apt/lists/*

COPY --from=builder /root/builder/* /usr/local/bin/
COPY files/entrypoint.sh files/run.sh /usr/local/bin/

RUN ln --symbolic /dev/null p2pool.log

ENV MONERO_NODE_ADDRESS="localhost"
ENV PROXY_URL=""
ENV WALLET_ADDRESS=\
"4AHZZW4wAW1ejT7J1PhvkaCqKDpSea8AubEZY8zdoGVp3tCSQ43XMSr4h9DrSyL8gvYVSSMJksUmoc4hQWVrGksAQ3FJJmF"

USER user
ENTRYPOINT [ "entrypoint.sh" ]
CMD [ "run.sh" ]

HEALTHCHECK CMD [ "healthcheck.sh" ]

LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/madebytimo/docker-p2pool"
