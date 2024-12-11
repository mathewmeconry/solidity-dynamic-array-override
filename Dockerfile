FROM ghcr.io/foundry-rs/foundry

RUN apk add nodejs yarn

RUN mkdir -p /app

WORKDIR /app

COPY . /app/

RUN forge update
RUN forge build
RUN yarn

CMD ["/app/entrypoint.sh"]