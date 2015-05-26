# Docker images for Thunder

Dockerfiles for [`codeneuro/notebooks`](https://registry.hub.docker.com/u/codeneuro/notebooks/) to build Spark and Thunder for use with Jupyter notebooks. Intended for launching temporary notebooks via [tmpnb](https://github.com/jupyter/tmpnb).

To run with tmpnb:

```
docker pull codeneuro/notebooks
```
```
export TOKEN=$( head -c 30 /dev/urandom | xxd -p )
```
```
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
           --name=proxy jupyter/configurable-http-proxy \
           --default-target http://127.0.0.1:9999
```
```
docker run --net=host -d -e CONFIGPROXY_AUTH_TOKEN=$TOKEN \
           -v /var/run/docker.sock:/docker.sock jupyter/tmpnb python orchestrate.py \
           --image='codeneuro/notebooks' --command="/bin/bash -c 'source activate \
           /opt/conda/envs/python2.7-env/ && thunder -n \
           --notebook-opts='--NotebookApp.base_url={base_path} \
           --ip=0.0.0.0 --port={port}''" --pool_size=25
```


