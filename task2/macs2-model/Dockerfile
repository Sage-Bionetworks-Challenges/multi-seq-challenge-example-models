FROM python:3.9.1-slim-buster

RUN apt-get update && apt-get install -y python3-dev gcc parallel
RUN echo 'will cite' | parallel --citation || true
RUN python -m pip install --upgrade pip
RUN pip install macs2 

COPY run_model.sh /run_model.sh

ENTRYPOINT ["bash", "/run_model.sh", "/data", "/output"]
