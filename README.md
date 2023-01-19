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

A potential chocolatey install:
```sh
cinst -y 7zip 7zip.install ag astrogrep autohotkey autohotkey.install autohotkey.portable autoruns azure-cli chezmoi croc devaudit devtoys dive dnspy docfx docker-compose docker-engine dotnet-7.0-sdk dotnet-7.0-sdk-1xx dotnetfx FiraCode Firefox fusionplusplus gimp gitui GitVersion.Portable graphviz hxd ilspy jetbrains-rider kdiff3 keepassxc kubernetes-cli lazygit MarkdownMonster.Portable mdcat mRemoteNG msbuild-structured-log-viewer choco install nerd-fonts-iosevka nodejs-lts notepadplusplus notepadplusplus.install NugetPackageExplorer oh-my-posh perfview poshgit powertoys procexp procmon ripgrep rsync sharex SQLite tailblazer terminal-icons.powershell tortoisegit winmerge wireshark zoomit
```
