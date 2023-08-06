FROM ubuntu as build-stage

# Init 
RUN apt update
RUN apt install python3 -y
RUN apt install cura -y
RUN apt install git -y
RUN apt install webhook -y
RUN apt install postgresql-client-14 -y
RUN apt install curl -y
RUN mkdir /var/webhook

COPY ./fdmextruder.def.json /usr/share/cura/resources/definitions/fdmextruder.def.json

ENTRYPOINT webhook -hotreload -verbose -hooks /etc/cura-api/config/hooks.yaml
