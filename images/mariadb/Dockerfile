FROM localhost:5000/alpine-base

RUN apk add --update mariadb mariadb-common mariadb-client && \
    rm -rf /var/cache/apk/*

# copy configuration files
COPY root /

# EntryPoint
ENTRYPOINT ["/init"]

CMD []

# Expose port
EXPOSE 3306

# Volume
VOLUME ["/var/lib/mysql"]
