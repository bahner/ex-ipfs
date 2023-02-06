FROM ipfs/kubo:v0.17.0
LABEL org.opencontainers.image.authors: "Lars Bahner <lars.bahner@basefarm-orange.com>"

CMD ["daemon", "--migrate=true", "--agent-version-suffix=docker", "--enable-pubsub-experiment", "--enable-namesys-experiment", "--enable-mplex-experiment"]
