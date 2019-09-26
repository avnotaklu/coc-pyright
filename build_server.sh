#!/usr/bin/env sh

set -ue

tag=`curl https://api.github.com/repos/microsoft/pyright/releases/latest | grep tag_name | sed -E 's/.*"([^"]+)".*/\1/'`
url="https://github.com/microsoft/pyright/archive/${tag}.tar.gz"

echo "Downloading pyright ${tag}"
curl -L -O ${url}

tar xzf ${tag}.tar.gz
cd ./pyright-${tag}

npm install && cd ./server && npm install && npm run build && cd ..

test $? -ne 0 && echo "npm build error" && exit

echo "Pyright build success!"

cd ..
rm -rf server
rm -rf typeshed-fallback

cp -R ./pyright-${tag}/client/server .
cp -R ./pyright-${tag}/client/typeshed-fallback .

rm -rf ${tag}.tar.gz
rm -rf ./pyright-${tag}

find server -type f | grep -v "js$" | grep -v "json$" | xargs rm
