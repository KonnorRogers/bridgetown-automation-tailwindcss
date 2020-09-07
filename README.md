![build](https://github.com/ParamagicDev/bridgetown-automation-tailwindcss/workflows/build/badge.svg)

## Prerequisites

#### "Bridgetown ~> 0.16.0"

```bash
bridgetown -v
# => bridgetown 0.16.0 "Crystal Springs"
```

This project requires the new `apply` command introduced in Bridgetown
`>= 0.15.0` 

## Usage

### New project

```bash
bridgetown new <newsite> --apply="https://github.com/ParamagicDev/bridgetown-automation-tailwindcss"
```

### Existing Project

```bash
cd <bridgetown-site>
bridgetown apply "https://github.com/ParamagicDev/bridgetown-automation-tailwindcss"
```

## Testing

Right now there is one big integration tests which is run via simple:

```bash
git clone https://github.com/ParamagicDev/bridgetown-automation-tailwindcss/
cd bridgetown-automation-tailwindcss
bundle install
bundle exec rake test
```

### Testing with Docker

```bash
git clone https://github.com/ParamagicDev/bridgetown-automation-tailwindcss/
cd bridgetown-automation-tailwindcss
source docker.env && docker-compose up --build
```

## Issues

Right now, the script does not do a smart replace of
`webpack.config.js`. If you have a webpack config different from the
stock version of Bridgetown it will be replaced with the default
bridgetown version with a PostCss loader.
