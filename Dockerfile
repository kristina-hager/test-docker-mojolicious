#for mojolicious web app

FROM perl:5.20

MAINTAINER Kristina Hager

#install mojolicious
RUN curl -L cpanmin.us | perl - Mojolicious@6.01

#copy in app src files and set working dir
COPY . /usr/src/helloworld
WORKDIR /usr/src/helloworld
EXPOSE 3000
CMD [ "morbo", "hello.pl"]
