# NB! This file is generated from templates/Dockerfile.
# Make sure to make change to the template, not
# the in situ file.
FROM ipfs/kubo:${KUBO_VERSION}
LABEL org.opencontainers.image.authors: "Lars Bahner <lars.bahner@gmail.com>"

CMD ["daemon", "--migrate=true", "--agent-version-suffix=docker", "--enable-pubsub-experiment", "--enable-namesys-pubsub", "--enable-mplex-experiment"]
