![build](https://github.com/ParamagicDev/bridgetown-automation-tailwindcss/workflows/build/badge.svg)

# Purpose

An automation to add TailwindCSS to a Bridgetown site.

This automation is deprecated. Go checkout the official bridgetown tailwind integration.

https://www.bridgetownrb.com/docs/bundled-configurations#tailwindcss

**This is not an official tailwind repository / product**

## What this automation does 

This automation will create the following file:

- `tailwind.config.js`
- `postcss.config.js`

It will replace the following file:

- `webpack.config.js`

It will modify the following file:

- `frontend/index.scss`

It will add the following NPM packages:

- [postcss-import](https://github.com/postcss/postcss-import)
- [postcss-loader](https://webpack.js.org/loaders/postcss-loader/)
- [tailwindcss](https://tailwindcss.com/)

## Prerequisites

#### "Bridgetown >= 0.15.0"

```bash
bridgetown -v
# => bridgetown 0.17.0 "Mount Scott"
```

This project requires the `apply` command introduced in Bridgetown version
`>= 0.15.0` 

## Usage

### New project

```bash
bridgetown new <newsite> --apply="https://github.com/ParamagicDev/bridgetown-automation-tailwindcss"
```

### Existing Project

```bash
cd <bridgetown-site>
[bundle exec] bridgetown apply "https://github.com/ParamagicDev/bridgetown-automation-tailwindcss"
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

### ActiveSupport issue

Sometimes you may see an error related to requiring ActiveSupport. 
Try rerunning the above command with `bundle exec` prepended, like so:

```bash
bundle exec bridgetown apply "https://github.com/ParamagicDev/bridgetown-automation-tailwindcss"
```
