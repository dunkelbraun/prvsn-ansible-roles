FROM python:3.8-slim

RUN apt update -y && apt install -y git curl

RUN git clone \
      --branch v1.3.1 \
      --single-branch \
      --depth 1 \
      https://github.com/wacken89/hetzner-load-balancer-prometheus-exporter.git \
      /tmp/hetzner-load-balancer-prometheus-exporter

RUN cp -r /tmp/hetzner-load-balancer-prometheus-exporter/code /opt/hetzner-load-balancer-prometheus-exporter

RUN pip install --no-cache-dir -r /opt/hetzner-load-balancer-prometheus-exporter/requirements.txt

WORKDIR /opt/hetzner-load-balancer-prometheus-exporter

ENV PYTHONPATH '/opt/hetzner-load-balancer-prometheus-exporter/'

USER nobody

EXPOSE 8000

CMD ["python" , "-u", "/opt/hetzner-load-balancer-prometheus-exporter/exporter.py"]
