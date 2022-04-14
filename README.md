# Dotfiles repository

To install on a new machine install [chezmoi](https://www.chezmoi.io/docs/install/) and then initialize the repository connection:

```sh
# SSH
chezmoi init git@github.com:joergrosenkranz/dotfiles.git

# HTTPS
chezmoi init https://github.com/joergrosenkranz/dotfiles.git
```

Apply the files:

```sh
chezmoi diff
chezmoi apply
```

To update the files on any machine:

```sh
chezmoi update
```
