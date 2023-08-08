FROM python:3.8-slim

RUN apt update -y && apt install -y curl

RUN mkdir -p /opt/hetzner-load-balancer-prometheus-exporter

WORKDIR /opt/hetzner-load-balancer-prometheus-exporter

COPY exporter.py .
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

ENV PYTHONPATH '/opt/hetzner-load-balancer-prometheus-exporter/'

USER nobody

EXPOSE 8000

CMD ["python" , "-u", "/opt/hetzner-load-balancer-prometheus-exporter/exporter.py"]
