#!/usr/bin/env nix-shell
#! nix-shell -i bash -p nodePackages.node2nix

# No official release
rev=3b0638be2093d531739b7b8fe234fe4b54c61b7d
u=https://raw.githubusercontent.com/Sorunome/mx-puppet-slack/$rev
# Download package.json and package-lock.json
curl -O $u/package.json
curl -O $u/package-lock.json

node2nix \
  --nodejs-12 \
  --node-env ./node-env.nix \
  --input package.json \
  --lock package-lock.json \
  --output node-packages.nix \
  --composition node-composition.nix

sed -i 's|<nixpkgs>|../../..|' node-composition.nix

rm -f package.json package-lock.json
