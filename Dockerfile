FROM python:alpine3.16
WORKDIR /usr/src/app
COPY code/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY code/app.py .

COPY code/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV APP_PORT=8080
EXPOSE 8888

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
