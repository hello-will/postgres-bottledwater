FROM postgres:latest

RUN set -x \
        && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget gcc g++ zlib1g-dev postgresql-server-dev-10 git pkg-config make cmake && rm -rf /var/lib/apt/lists/*\
        && wget http://www.digip.org/jansson/releases/jansson-2.11.tar.gz && tar -zxvf jansson-2.11.tar.gz && cd jansson-2.11/ && ./configure && make install && export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH && pkg-config --cflags --libs jansson && cd ../ && rm -rf jansson-2.11 && rm jansson-2.11.tar.gz\
        && wget http://mirrors.hust.edu.cn/apache/avro/avro-1.8.2/avro-src-1.8.2.tar.gz && tar -zxvf avro-src-1.8.2.tar.gz && cd avro-src-1.8.2/lang/c/ && cmake . && make install && cd ../../../ && rm -rf avro-src-1.8.2 && rm avro-src-1.8.2.tar.gz\
        && wget https://curl.haxx.se/download/curl-7.61.0.tar.gz && tar -zxvf curl-7.61.0.tar.gz && cd curl-7.61.0/ && ./configure && make install && cd ../ && rm -rf curl-7.61.0 && rm curl-7.61.0.tar.gz\
        && wget https://github.com/edenhill/librdkafka/archive/v0.11.5.tar.gz && tar -zxvf v0.11.5.tar.gz && cd librdkafka-0.11.5/ && ./configure && make && make install && cd ../ && rm -rf librdkafka-0.11.5 && rm v0.11.5.tar.gz\
        && git clone https://github.com/confluentinc/bottledwater-pg.git && cd bottledwater-pg/ && make all && make install && cp ./kafka/bottledwater /usr/local/bin/bottledwater && cd ../ && rm -rf bottledwater-pg\
        && apt-get purge -y --auto-remove ca-certificates wget gcc g++ git make cmake\
        && cd /usr/local/lib && ldconfig

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 5432
CMD ["help"]
