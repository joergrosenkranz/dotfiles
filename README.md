# Dotfiles repository

To install on a new machine install [chezmoi](https://www.chezmoi.io/docs/install/) and then initialize the repository connection:

```sh
chezmoi init git@github.com:joergrosenkranz/dotfiles.git
chezmoi diff
chezmoi apply
```

To update the files on any machine:

```sh
chezmoi update
```
