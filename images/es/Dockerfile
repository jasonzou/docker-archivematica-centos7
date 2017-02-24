FROM localhost:5000/alpine-base
MAINTAINER Jason Zou <jason.zou@gmail.com>

ENV ELASTICSEARCH_MAJOR 1.7
ENV ELASTICSEARCH_VERSION 1.7.5
ENV ELASTICSEARCH_URL_BASE https://download.elasticsearch.org/elasticsearch/elasticsearch
ENV PATH /opt/elasticsearch/bin:$PATH

RUN set -ex \
	&& apk --update add bash curl libseccomp \
	&& rm -rf /var/cache/apk/* 
RUN apk --update add openjdk8 && \
    mkdir /tmp/tmprt && \
    cd /tmp/tmprt && \
    apk add zip && \
    unzip -q /usr/lib/jvm/default-jvm/jre/lib/rt.jar && \
    apk add zip && \
    zip -q -r /tmp/rt.zip . && \
    apk del zip && \
    cd /tmp && \
    mv rt.zip /usr/lib/jvm/default-jvm/jre/lib/rt.jar && \
    rm -rf /tmp/tmprt /var/cache/apk/* bin/jjs bin/keytool bin/orbd bin/pack200 bin/policytool \
    bin/rmid bin/rmiregistry bin/servertool bin/tnameserv bin/unpack200

RUN set -ex \
	&& mkdir -p /opt \
	&& curl -fsSL -o /tmp/elasticsearch.tar.gz $ELASTICSEARCH_URL_BASE/elasticsearch-$ELASTICSEARCH_VERSION.tar.gz \
	&& tar -xzf /tmp/elasticsearch.tar.gz -C /opt \
	&& rm -f /tmp/elasticsearch.tar.gz \
	&& mv /opt/elasticsearch-$ELASTICSEARCH_VERSION /opt/elasticsearch \
	&& for path in \
		/opt/elasticsearch/data \
		/opt/elasticsearch/logs \
		/opt/elasticsearch/config \
		/opt/elasticsearch/config/scripts; do mkdir -p "$path"; done \
	&& addgroup elasticsearch \
	&& adduser -D -G elasticsearch -h /opt/elasticsearch elasticsearch \
	&& chown -R elasticsearch:elasticsearch /opt/elasticsearch

# install a plugin
RUN cd /opt/elasticsearch && \
  bin/plugin install mobz/elasticsearch-head && \
  bin/plugin install knapsack -url http://xbib.org/repository/org/xbib/elasticsearch/plugin/elasticsearch-knapsack/1.7.2.1/elasticsearch-knapsack-1.7.2.1-plugin.zip


ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
# data folder
VOLUME ["/opt/elasticsearch/data"]

ADD root /

ENTRYPOINT ["/init"]
CMD []

EXPOSE 9200 9300
