FROM node:gallium-alpine

ENV FIREBASE_TOOLS_VERSION=12.9.1
RUN yarn global add firebase-tools@${FIREBASE_TOOLS_VERSION} && \
    yarn cache clean && \
    firebase -V && \
    mkdir $HOME/.cache

RUN apk --no-cache add openjdk11-jre bash curl nginx gettext sed grep
RUN firebase setup:emulators:database
RUN firebase setup:emulators:ui

RUN mkdir -p /firebase

COPY serve.sh healthcheck.sh /usr/bin/
COPY nginx.conf.template /etc/nginx/

HEALTHCHECK --interval=1s --timeout=1m --retries=60 \
  CMD /usr/bin/healthcheck.sh
ENTRYPOINT "/usr/bin/serve.sh"
