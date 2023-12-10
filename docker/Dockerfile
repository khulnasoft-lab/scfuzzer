FROM ubuntu:jammy AS builder-scfuzzer
ENV LD_LIBRARY_PATH=/usr/local/lib PREFIX=/usr/local HOST_OS=Linux
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-suggests --no-install-recommends \
        cmake \
        curl \
        git \
        libbz2-dev \
        libgmp-dev \
        libreadline-dev \
        libsecp256k1-dev \
        libssl-dev \
        software-properties-common \
        sudo
RUN curl -sSL https://get.haskellstack.org/ | sh
COPY . /scfuzzer/
WORKDIR /scfuzzer
RUN .github/scripts/install-libff.sh
RUN stack upgrade && stack setup && stack install --flag scfuzzer:static --extra-include-dirs=/usr/local/include --extra-lib-dirs=/usr/local/lib


FROM ubuntu:jammy AS builder-python3
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-suggests --no-install-recommends \
        gcc \
        python3.8-dev \
        python3.8-venv
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_CACHE_DIR=1
RUN python3 -m venv /venv && /venv/bin/pip3 install --no-cache --upgrade setuptools pip
RUN /venv/bin/pip3 install --no-cache slither-analyzer solc-select


FROM gcr.io/distroless/python3-debian11:nonroot AS final-distroless
COPY --from=builder-scfuzzer /root/.local/bin/scfuzzer /usr/local/bin/scfuzzer
COPY --from=builder-python3 /venv /venv
COPY docker/solc-install.py /usr/local/bin/solc-install
ENV PATH="$PATH:/venv/bin"
ENTRYPOINT [ "/usr/local/bin/solc-install", "/usr/local/bin/scfuzzer" ]


FROM ubuntu:jammy AS final-ubuntu
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-suggests --no-install-recommends \
        ca-certificates \
        curl \
        python3 \
        python3-distutils \
        && \
    rm -rf /var/lib/apt/lists/*
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
COPY --from=builder-scfuzzer /root/.local/bin/scfuzzer /usr/local/bin/scfuzzer
RUN ln -s /usr/local/bin/scfuzzer /usr/local/bin/scfuzzer-test
COPY --from=builder-python3 /venv /venv
ENV LANG="C.UTF-8"
ENV PATH="$PATH:/venv/bin"
