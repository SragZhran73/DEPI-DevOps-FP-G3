FROM python:3.8-slim-buster

WORKDIR /back_app


COPY requirements.txt requirements.txt


RUN pip3 install -r requirements.txt


COPY app.py .



ENV DB_HOST=ec2-18-208-9-152.compute-1.amazonaws.com
ENV DB_USER=newuser
ENV DB_PASSWORD=#strong#85207410#
ENV DB_NAME=Demo

EXPOSE 5000


CMD [ "python", "app.py"]