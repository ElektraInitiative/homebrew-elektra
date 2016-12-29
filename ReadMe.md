# Elektra Homebrew Formula

This tap contains the official [🍺 Homebrew](https://brew.sh) formula for the configuration framework [⚡️ Elektra](http://web.libelektra.org).

# How to Use

## Preparation

**If you installed Elektra manually before**, then please remove it before you install this formula. After you uninstalled Elektra, please run `brew doctor` and remove all fragments of previous Elektra versions that the command reports.

## Installation

To install Elektra using this tap just use the two shell commands listed below:

```sh
brew tap ElektraInitiative/homebrew-elektra
brew install elektra
```

## Versions

| Version          | Command                                    |
| ---------------- | ------------------------------------------ |
| Bottle (Binary)  | `brew install elektra`                     |
| Source (Release) | `brew install --build-from-source elektra` |
| Source (Head)    | `brew install --HEAD elektra`              |

# Troubleshooting

- To check if the installation works you can use the command `brew test elektra`.
