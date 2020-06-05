## Prerequisites

#### "Bridgetown ~> 0.15.0"

```bash
bridgetown -v
# => bridgetown 0.15.0.beta2 "Overlook"
```

This project requires the new `apply` command introduced in Bridgetown
`0.15.0`

## Usage

### New project

```bash
bridgetown new <newsite> --apply="https://raw.githubusercontent.com/ParamagicDev/bridgetown-plugin-tailwindcss/master/bridgetown.automation.rb"
```

### Existing Project

```bash
bridgetown apply https://raw.githubusercontent.com/ParamagicDev/bridgetown-plugin-tailwindcss/master/bridgetown.automation.rb
```

## Testing

Right now there is one big integration tests which is run via simple:

```bash
git clone https://github.com/ParamagicDev/bridgetown-plugin-tailwindcss/
cd bridgetown-plugin-tailwindcss
bundle install
bundle exec rake test
```

### Testing with Docker

```bash
git clone https://github.com/ParamagicDev/bridgetown-plugin-tailwindcss/
cd bridgetown-plugin-tailwindcss
./compose.sh up --build
```

## Issues

Right now, the script does not do a smart replace of
`webpack.config.js`. If you have a webpack config different from the
stock version of Bridgetown it will be replaced with the default
bridgetown version with a PostCss loader.
