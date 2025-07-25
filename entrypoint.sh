#!/bin/bash
set -e

echo "🔧 Building LuaSocket..."

cd /build/luasocket
mkdir -p /output/socket
mkdir -p /output/mime
cd src

SOCKET_C_FILES="luasocket.c timeout.c buffer.c io.c auxiliar.c options.c inet.c tcp.c udp.c except.c select.c wsocket.c"

x86_64-w64-mingw32-gcc -O2 -Wall -shared \
  -DLUASOCKET_DEBUG \
  -D_WIN32_WINNT=0x0601 \
  -I/usr/local/lua54/include \
  $SOCKET_C_FILES \
  -o /output/socket/core.dll \
  -L/usr/local/lua54/lib -llua54 -lws2_32

echo "✔ socket/core.dll built"

x86_64-w64-mingw32-gcc -O2 -Wall -shared \
  -DLUASOCKET_DEBUG \
  -I/usr/local/lua54/include \
  mime.c \
  -o /output/mime/core.dll \
  -L/usr/local/lua54/lib -llua54

echo "✔ mime/core.dll built"

cd ..
cp -v src/*.lua /output/socket/
cp -v src/mime.lua /output/mime/

echo "📦 Packaging .dll and .lua into separate zip files..."
cd /output
zip -r /output/luasocket.zip socket/core.dll mime/core.dll
zip -r /output/src_luasocket.zip socket/*.lua mime/mime.lua

echo "✅ All done"
