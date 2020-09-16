'use strict';
process.env.TS_NODE_FILES = true;
module.exports = {
  recursive: true,
  diff: true,
  'allow-uncaught': true,
  extension: ['ts'],
  reporter: 'spec',
  slow: 75,
  timeout: 20000,
  ui: 'bdd',
  watch: false,
  'watch-files': ['src/**/*.sol', 'test/**/*.ts'],
  spec: 'test/**/*.test.ts',
  require: ['@nomiclabs/buidler/register', 'ts-node/register'],
};
