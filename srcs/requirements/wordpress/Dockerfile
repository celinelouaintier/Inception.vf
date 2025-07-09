FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y php php-fpm php-mysql wget curl unzip mariadb-client && \
    apt-get clean

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf

RUN mkdir -p /var/www/html

COPY ./tools/setup.sh /setup.sh
RUN chmod +x /setup.sh

RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

WORKDIR /var/www/html

ENTRYPOINT ["/setup.sh"]