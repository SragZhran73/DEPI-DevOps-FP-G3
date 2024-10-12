FROM python:3.8-slim-buster

WORKDIR /back_app


COPY requirements.txt requirements.txt


RUN pip3 install -r requirements.txt


COPY app.py .


EXPOSE 5000


CMD [ "python", "app.py"]