# Elektra Homebrew Formula

This tap contains a [🍺 Homebrew](https://brew.sh) formula for the configuration framework [⚡️ Elektra](http://web.libelektra.org). The official Homebrew repository [`homebrew/core`](https://github.com/Homebrew/homebrew-core) also includes an [official formula for Elektra](https://github.com/Homebrew/homebrew-core/blob/master/Formula/elektra.rb). We therefore recommend you use this tap, only if you want to use functionality that is not supported by the formula in `homebrew/core`, such as library dependent plugins (e.g. `xerces`, `yajl`).

# How to Use

## Preparation

**If you installed Elektra manually before**, then please remove it before you install this formula. After you uninstalled Elektra, please run `brew doctor` and remove all fragments of previous Elektra versions that the command reports.

## Installation

To install Elektra using this tap just use the two shell commands listed below:

```sh
brew tap elektrainitiative/elektra
brew install elektrainitiative/elektra/elektra
```

## Options

Use the command `brew info elektrainitiative/elektra/elektra`to show a list of optional switches for this Homebrew formula.

# Troubleshooting

To check if the installation worked you can use the command `brew test elektra`.
