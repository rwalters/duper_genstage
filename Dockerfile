FROM elixir:1.8-alpine

ARG MIX_ENV=prod
ENV MIX_ENV ${MIX_ENV}
# Update SECRET_KEY_BASE to force 'apk' to refresh
ENV SECRET_KEY_BASE PNIM7I30u+mZ1IsPrw8wRnn0SQv3KUgkn+p0hXK5OY1eS1KVuzAja/tPegmBs8ev

RUN apk --no-cache --update --available upgrade

# Set exposed ports
EXPOSE 4000
ENV PORT=4000

RUN mix local.hex --force \
  && mix local.rebar --force

RUN mkdir -p /app
WORKDIR /app

ADD . .

# Get deps & compile project
RUN mix deps.get && mix compile \
  && MIX_ENV=test mix deps.get && MIX_ENV=test mix compile \
  && MIX_ENV=dev  mix deps.get && MIX_ENV=dev  mix compile

CMD /bin/sh
