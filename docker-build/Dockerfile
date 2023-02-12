ARG PY_VER="3.9.16-slim-bullseye"

FROM python:${PY_VER}

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY debian.tuna.sources.list /etc/apt/sources.list
COPY installfiles/ /opt/
COPY runserver.sh /livepatch/

WORKDIR /

RUN apt-get update \
    && apt-get install -y --no-install-recommends sudo wget curl procps htop \
                          net-tools \
                          ca-certificates \
                          iproute2 \
                          iputils-ping \
                          locales  \
                         libgl1 libglib2.0-0 \
                          vim \
    && pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && python -m pip install --upgrade pip \
    && pip install --no-cache-dir -r /opt/requirements.txt \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /opt/requirements.txt

# Creates a non-root user with an explicit UID and adds permission to access the /app folder

EXPOSE 80 1080 8080

# During debugging, this entry point will be overridden. For more information, please refer to https://aka.ms/vscode-docker-python-debug
CMD ["/bin/bash", "/livepatch/runserver.sh"]
