## Usage

## Testing

Right now there is one big integration tests which is run via simple:

```bash
bundle install
rake test
```

## Issues

Right now, the script does not do a smart replace of
`webpack.config.js`. If you have a webpack config different from the
stock version of Bridgetown it will be replaced with the default
bridgetown version with a PostCss loader.
