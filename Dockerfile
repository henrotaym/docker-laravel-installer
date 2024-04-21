FROM php:8.2-cli-alpine3.19 as installer

# Install composer
COPY --from=composer:2.7.2 /usr/bin/composer /usr/bin/composer

WORKDIR /tmp

RUN apk add --no-cache git && \
    composer create-project laravel/installer --prefer-dist

WORKDIR /opt/apps

CMD [ "/tmp/installer/bin/laravel", "--git", "new" ]