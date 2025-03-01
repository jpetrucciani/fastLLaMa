FROM ubuntu:18.04

# Add GCC and G++ New
RUN apt-get update && apt-get install software-properties-common curl git -qy 
RUN add-apt-repository ppa:ubuntu-toolchain-r/test && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 42D5A192B819C5DA

# Add CMAKE New
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository "deb https://apt.kitware.com/ubuntu/ bionic main" && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6AF7F09730B3F0A4

RUN apt-get update

# Install
RUN apt-get install -qy cmake gcc-10 g++-10

# Configure
RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-10 30 && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-10 30
RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30 && update-alternatives --set cc /usr/bin/gcc
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30 && update-alternatives --set c++ /usr/bin/g++

ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
RUN add-apt-repository -y ppa:deadsnakes/ppa && apt-get update \
    && apt-get install -y python3.9-dev python3.9-distutils python3.9

WORKDIR /app
RUN git clone https://github.com/PotatoSpudowski/fastLLaMa.git /app
RUN chmod +x build.sh && bash ./build.sh

RUN apt-get install -qy python3-pip
RUN python3.9 -m pip install --upgrade pip && python3.9 -m pip install setuptools-rust
RUN python3.9 -m pip install -r requirements.txt

CMD ["python3.9", "example.py"]