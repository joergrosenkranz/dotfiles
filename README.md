# Dotfiles repository

To install on a new machine install [chezmoi](https://www.chezmoi.io/docs/install/) and then initialize the repository connection:

```sh
chezmoi init git@github.com:joergrosenkranz/dotfiles.git
```

Create a configuration file called ~/.config/chezmoi/chezmoi.toml defining variables that vary from machine to machine:

```ini
[data]
    email = "me@home.org"
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
