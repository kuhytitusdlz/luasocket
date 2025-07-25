FROM ubuntu:22.04

WORKDIR /build

COPY entrypoint.sh /build/entrypoint.sh

RUN apt-get update && apt-get install -y \
  git \
  build-essential \
  mingw-w64 \
  cmake \
  unzip \
  wget \
  zip && \
  \
  wget https://www.lua.org/ftp/lua-5.4.1.tar.gz && \
  tar -xzf lua-5.4.1.tar.gz && \
  cd lua-5.4.1 && \
  make mingw CC=x86_64-w64-mingw32-gcc && \
  cd src && \
  ln -s lua.exe lua && \
  ln -s luac.exe luac && \
  mkdir -p /usr/local/lua54/bin /usr/local/lua54/include /usr/local/lua54/lib && \
  cp lua.exe luac.exe /usr/local/lua54/bin/ && \
  cp ../src/*.h /usr/local/lua54/include/ && \
  cp lua54.dll liblua.a /usr/local/lua54/lib/ && \
  \
  cd /build && \
  git clone --depth=1 https://github.com/lunarmodules/luasocket.git && \
  chmod +x /build/entrypoint.sh
