FROM debian:11

RUN apt-get update \
 && apt-get install -y --no-install-recommends supervisor cron busybox-syslogd logrotate python3-apt apt-transport-https gnupg net-tools procps wget openjdk-17-jdk curl jq \
 && wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
 && echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee /etc/apt/sources.list.d/elastic-7.x.list \
 && apt-get update \
 && apt-get install elasticsearch kibana filebeat \
 && rm -rf /var/lib/apt/lists/*

ENV ES_HOME=/usr/share/elasticsearch
ENV ES_PATH_CONF=/etc/elasticsearch
ENV KBN_PATH_CONF=/etc/kibana

COPY ./supervisord.conf /etc/supervisor/supervisord.conf
COPY ./bootstrap.sh /bootstrap.sh
COPY ./healthcheck.sh /healthcheck.sh

COPY ./elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
COPY ./kibana.yml /etc/kibana/kibana.yml
COPY ./netflow.yml /etc/filebeat/modules.d/netflow.yml
COPY ./netflow-mod-ip.js /etc/filebeat/netflow-mod-ip.js
COPY ./netflow-mod-domain.js /etc/filebeat/netflow-mod-domain.js
COPY ./launch-kibana.sh /launch-kibana.sh
COPY ./launch-filebeat.sh /launch-filebeat.sh

RUN echo "-Xms512m" >> /etc/elasticsearch/jvm.options.d/memory \
 && echo "-Xmx512m" >> /etc/elasticsearch/jvm.options.d/memory \
 && touch /etc/default/locale \
 && addgroup syslog \
 && chmod -R go-w /etc/elasticsearch \
 && chmod -R go-w /etc/kibana \
 && chmod -R go-w /etc/filebeat

EXPOSE 5601/tcp
EXPOSE 2055/udp

CMD ["/bootstrap.sh"]
HEALTHCHECK --interval=30s --start-period=120s CMD /healthcheck.sh
