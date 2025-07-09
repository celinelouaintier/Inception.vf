FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./tools/init.sh /init.sh
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
RUN chmod +x /init.sh

EXPOSE 3306

ENTRYPOINT ["/init.sh", "mysqld"]