/**
 * @see https://prettier.io/docs/en/configuration.html
 */
const config = {
  tabWidth: 2,
  plugins: [
    // Add plugins here using a require() statement.
    // This is required to ensure the node module resolution algorithm starts walking
    // up the filesystem from this file, rather than from the location where prettier interprets it.
  ],
};

// eslint-disable-next-line no-undef
module.exports = config;
