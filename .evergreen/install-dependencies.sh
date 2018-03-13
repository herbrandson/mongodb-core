#!/bin/sh
set -o xtrace   # Write all commands first to stderr
set -o errexit  # Exit the script with error if any of the commands fail

NODE_LTS_NAME=${NODE_LTS_NAME:-carbon}
NODE_ARTIFACTS_PATH="${PROJECT_DIRECTORY}/node-artifacts"
NPM_CACHE_DIR="${NODE_ARTIFACTS_PATH}/npm"

# this needs to be explicitly exported for the nvm install below
export NVM_DIR="${NODE_ARTIFACTS_PATH}/nvm"

# create node artifacts path if needed
mkdir -p ${NODE_ARTIFACTS_PATH}
mkdir -p ${NPM_CACHE_DIR}

# install Node.js
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
[ -s "${NVM_DIR}/nvm.sh" ] && \. "${NVM_DIR}/nvm.sh"
nvm install --lts=${NODE_LTS_NAME}

# setup npm cache in a local directory
cat <<EOT > .npmrc
devdir=${NPM_CACHE_DIR}/.node-gyp
init-module=${NPM_CACHE_DIR}/.npm-init.js
cache=${NPM_CACHE_DIR}
EOT


cat <<EOT > index.js
var url = require('url');;
var path = require('path');;

module.exports = cf;;

function cf(root, u) {
  console.log('ROOT: ', root);
  console.log('U: ', u);

  if (!u)
    return cf.bind(null, root);;

  u = url.parse(u);;
  var h = u.host.replace(/:/g, '_');;
  // Strip off any /-rev/... or ?rev=... bits
  var revre = /(\?rev=|\?.*?&rev=|\/-rev\/).*$/;;
  var parts = u.path.replace(revre, '').split('/').slice(1);;
  // Make sure different git references get different folders
  if (u.hash && u.hash.length > 1) {
    parts.push(u.hash.slice(1));;
  };;
  var p = [root, h].concat(parts.map(function(part) {
    return encodeURIComponent(part).replace(/%/g, '_');;
  }));;

  console.log('FINAL: ', path.join.apply(path, p));
  return path.join.apply(path, p);;
}
EOT

mv index.js ${NVM_DIR}/versions/node/v4.8.7/lib/node_modules/npm/node_modules/npm-cache-filename/index.js

# install node dependencies
# npm install --unsafe-perm=true --allow-root

# npm install bson
npm install chai --verbose

# npm install require_optional
# npm install co
# npm install conventional-changelog-cli
# npm install eslint
# npm install eslint-plugin-prettier
# npm install jsdoc
# npm install mongodb-mock-server
# npm install prettier
# npm install snappy
# npm install kerberos

# npm install mongodb-test-runner

