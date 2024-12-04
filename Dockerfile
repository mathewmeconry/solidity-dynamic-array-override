FROM ghcr.io/foundry-rs/foundry

RUN apk add nodejs yarn

RUN mkdir -p /app

WORKDIR /app

COPY . /app/

RUN forge update
RUN forge build
RUN yarn

ENV PRIVATE_KEY=0xaa20aa192b89a9f6e50bafff8dc5e6399e4150f45f3f14dced24b30e5152e18e
CMD ["/app/entrypoint.sh"]