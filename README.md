# Dockerized Elastic Stack for testing Netflow/IPFIX monitoring

This repo contains the Dockerfile and prerequisites to build an image to serve as a Netflow/IPFIX monitor.

**IMPORTANT: This is NOT in any way production quality!** Authentication is disabled, and besides, running a whole Elastic Stack in a single container is generally not a great idea. Nevertheless, this can be used to test out what the Elastic Stack can show for network monitoring.

![image](https://user-images.githubusercontent.com/344911/137599306-71c59d93-2e3e-4729-bd6f-ec70855f867a.png)

Usage:

```
git clone https://github.com/arktronic/docker-quick-elastic-netflow.git
cd docker-quick-elastic-netflow

# building the image will take a while
./_build.sh

# launch the container
# note, first launch could take a couple of minutes for Filebeat to load dashboards into Kibana
docker run --init --name=quickelasticnetflow -p 5601:5601 -p 2055:2055/udp -d localhost/arktronic/quick-elastic-netflow:latest
```

Once launched, you can browse Kibana by accessing `http://localhost:5601`. To get Netflow or IPFIX data, point your exporter to `<YOUR-IP>:2055`. There are a number of predefined Dashboards available in Kibana for Netflow.

NOTE: the Filebeat configuration is modified from the default one to work slightly better with Mikrotik IPFIX data. Theoretically, it shouldn't cause any harm with other Netflow or IPFIX sources.
