# ================================== BUILDER ===================================
ARG INSTALL_PYTHON_VERSION=${INSTALL_PYTHON_VERSION:-PYTHON_VERSION_NOT_SET}

FROM python:${INSTALL_PYTHON_VERSION}-slim-buster AS builder

# # application folder
ENV APP_DIR /app

WORKDIR /app

RUN true
COPY requirements.txt /app
RUN python -m pip install

COPY app app
COPY .env.default .env

# ================================= PRODUCTION =================================
#FROM python:3.7.4-slim-buster as production
FROM python:${INSTALL_PYTHON_VERSION}-slim-buster as production

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
    

# Setup Supervisor
# RUN apt-get -y install supervisor
RUN mkdir -p /var/log/supervisor

WORKDIR /app
RUN useradd -m docker
RUN chown -R docker:docker /app
USER docker
ENV PATH="/home/docker/.local/bin:${PATH}"

COPY requirements.txt /app
RUN pip3 install --no-cache --user -r requirements.txt
# COPY supervisord.conf /etc/supervisor/supervisord.conf

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisord_programs /etc/supervisor/conf.d

# copy config files
COPY . .
# COPY ./app ${APP_DIR}

# VOLUME ["${APP_DIR}"]
# "ENV_LOG_LEVEL", "debug"
EXPOSE 8000
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
#CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--worker-tmp-dir", "/dev/shm", "--workers", "2", "--worker-class", "gevent", "--worker-connections", "1000", "wsgi:app", "--log-level", "debug"]

# ================================= DEVELOPMENT ================================
# FROM builder AS development
# RUN pip install --no-cache -r requirements.txt
