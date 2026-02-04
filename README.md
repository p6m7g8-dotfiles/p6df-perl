# P6's POSIX.2: p6df-perl

## Table of Contents

- [Badges](#badges)
- [Summary](#summary)
- [Contributing](#contributing)
- [Code of Conduct](#code-of-conduct)
- [Usage](#usage)
  - [Functions](#functions)
- [Hierarchy](#hierarchy)
- [Author](#author)

## Badges

[![License](https://img.shields.io/badge/License-Apache%202.0-yellowgreen.svg)](https://opensource.org/licenses/Apache-2.0)

## Summary

TODO: Add a short summary of this module.

## Contributing

- [How to Contribute](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CONTRIBUTING.md>)

## Code of Conduct

- [Code of Conduct](<https://github.com/p6m7g8-dotfiles/.github/blob/main/CODE_OF_CONDUCT.md>)

## Usage

### Functions

#### p6df-perl

##### p6df-perl/init.zsh

- `p6df::modules::perl::deps()`
- `p6df::modules::perl::home::symlink()`
- `p6df::modules::perl::init(_module, dir)`
  - Args:
    - _module - 
    - dir - 
- `p6df::modules::perl::langs()`
- `p6df::modules::perl::vscodes()`
- `p6df::modules::perl::vscodes::config()`
- `str str = p6df::modules::perl::prompt::env()`
- `str str = p6df::modules::perl::prompt::lang()`

#### p6df-perl/lib

##### p6df-perl/lib/plenv.sh

- `p6df::modules::perl::plenv::latest()`
- `p6df::modules::perl::plenv::latest::installed()`

## Hierarchy

```text
.
├── bin
│   └── deps.sh
├── init.zsh
├── lib
│   └── plenv.sh
├── README.md
└── share

4 directories, 4 files
```

## Author

Philip M. Gollucci <pgollucci@p6m7g8.com>
