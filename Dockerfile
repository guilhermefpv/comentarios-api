# ================================= PRODUCTION =================================
FROM python:3.8.18-slim-bullseye as production

# Update Packages
RUN apt-get -y update && \
    apt-get -y install supervisor && \
    pip3 install --upgrade pip && \
	#pip3 install flask gunicorn && \
    mkdir -p ${APP_DIR}/conf && \
	mkdir -p ${APP_DIR}/logs
    #echo "files = ${APP_DIR}/conf/*.ini" >> /etc/supervisord.conf

# Install basics
#RUN apt-get -y install curl wget make gcc build-essential

# Ferramentas para 'troubleshoot' 
# RUN apt-get -y update; apt-get -y install curl
# RUN apt-get update \
#   && apt-get install --no-install-recommends --yes \
#     curl \
#     apt-utils \
#     dnsutils \
#     httpie \
#     iputils-ping \
#     jq \
#     netcat-openbsd \
#     net-tools \
#     telnet \
#     vim \
#     wget \
#     && rm -rf /var/lib/apt/lists/*

## application folder
WORKDIR /app

COPY app app
COPY .env.default .env

WORKDIR /app
RUN useradd -m docker
RUN chown -R docker:docker /app
USER docker
ENV PATH="/home/docker/.local/bin:${PATH}"

COPY requirements.txt /app
RUN pip3 install --no-cache --user -r requirements.txt

# Setup Supervisor
RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord_programs /etc/supervisor/conf.d

# copy config files
COPY . .

EXPOSE 8080
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]