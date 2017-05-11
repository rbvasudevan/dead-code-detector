FROM openjdk:8

ENV SERVER_PORT 8080

ADD ./app /var/app

RUN apt-get update -y
RUN apt-get install -y awscli

RUN touch /var/app/start.sh && \
    chmod +x /var/app/start.sh

EXPOSE 8080
USER root
RUN mkdir -p /var/app/understand
RUN mkdir -p  /var/app/temp/
RUN tar -xvzf /var/app/understand.tgz -C /var/app/understand
RUN export PATH=$PATH:/var/understand/scitools/bin/linux64/
RUN echo $PATH
CMD /var/app/start.sh
