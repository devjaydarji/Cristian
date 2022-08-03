#! bin/bash


ip=$1

docker run -d  --name=fox consul agent -node=client-1 -join=$ip

docker exec badger consul members

docker pull hashicorp/counting-service:0.0.2

docker run -p 9001:9001  -d  --name=weasel  hashicorp/counting-service:0.0.2

docker exec fox /bin/sh -c "echo '{\"service\": {\"name\": \"counting\", \"tags\": [\"go\"], \"port\": 9001}}' >> /consul/config/counting.json"

docker exec fox consul reload

dig @127.0.0.1 -p 8600 counting.service.consul
