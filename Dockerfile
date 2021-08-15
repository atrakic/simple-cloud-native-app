FROM tiangolo/uwsgi-nginx-flask:python3.8-alpine

WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

COPY . .
