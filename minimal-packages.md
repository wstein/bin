# Packages to install for 'minimal' Linux instances.

This file documents a cross-distro list of recommended packages for minimal Linux installations. The table below maps each package to its corresponding name or availability on major distributions: Fedora, Debian, Ubuntu, RHEL, Alpine, Arch, openSUSE, and Photon. The list is machine-readable and used by the `install-minimal` script, which parses it with `awk` to automate package installation.

## Package list

| fedora          | debian                  | ubuntu                  | rhel           | alpine         | arch     | opensuse       | photon         |
|-----------------|-------------------------|-------------------------|----------------|----------------|----------|----------------|----------------|
| aria2           |                         |                         | n/a            |                |          |                | n/a            |
| bash-completion |                         |                         |                |                |          |                | n/a            |
| byobu           |                         |                         | n/a            |                |          |                | n/a            |
| bzip2           |                         |                         |                |                |          |                |                |
| cloud-utils     |                         |                         | n/a            |                |          | n/a            | n/a            |
| ctags           | universal-ctags         | universal-ctags         | n/a            |                |          |                |                |
| curl            |                         |                         | n/a            |                |          |                |                |
| darkhttpd       | n/a                     | n/a                     | n/a            |                |          |                | n/a            |
| diffutils       |                         |                         |                |                |          |                |                |
| dirmngr         |                         |                         |                |                | n/a      |                | n/a            |
| doas            |                         |                         | n/a            |                |          |                | n/a            |
| eza             | exa                     |                         | n/a            |                |          |                | n/a            |
| fd-find         |                         | fd                      | n/a            | fd             | fd       |                | n/a            |
| findutils       |                         |                         |                |                |          |                |                |
| fping           |                         |                         | n/a            |                |          |                |                |
| fzf             |                         |                         | n/a            |                |          |                | n/a            |
| git             |                         |                         |                |                |          |                |                |
| gnupg           |                         |                         | gnupg2         |                |          |                |                |
| gzip            |                         |                         |                |                |          |                |                |
| htop            |                         |                         | n/a            |                |          |                | n/a            |
| inotify-tools   |                         |                         | n/a            |                |          |                |                |
| iproute         | iproute2                | iproute2                |                | iproute2       |          |                | iproute2       |
| iptraf-ng       |                         |                         | n/a            |                |          |                |                |
| jq              |                         |                         |                |                |          |                |                |
| kitty-terminfo  |                         |                         | n/a            |                |          |                | n/a            |
| libnsl          | n/a                     | n/a                     |                |                |          | n/a            |                |
| lshw            |                         |                         |                |                |          |                |                |
| lz4             |                         |                         |                |                |          |                |                |
| lzip            |                         |                         | n/a            |                |          |                | n/a            |
| lzop            |                         | lzo                     |                |                |          |                | n/a            |
| make            |                         |                         |                |                |          |                |                |
| mkpasswd        | libstring-mkpasswd-perl | libstring-mkpasswd-perl |                |                | whois    |                |                |
| moreutils       |                         |                         | n/a            |                |          | n/a            | n/a            |
| neovim          |                         |                         | vim            |                |          |                | vim            |
| net-snmp-utils  | snmp                    | snmp                    |                | net-snmp-tools | net-snmp |                | net-snmp       |
| nethogs         |                         |                         | n/a            |                |          |                | n/a            |
| openssh-server  |                         |                         |                |                | openssh  |                |                |
| pass            |                         |                         | n/a            |                |          | password-store | password-store |
| patch           |                         |                         |                |                |          |                |                |
| procps          |                         |                         | procps-ng      |                |          |                | n/a            |
| pv              |                         |                         | n/a            |                |          |                | n/a            |
| qrencode        |                         | libqrencode             | n/a            | libqrencode    |          |                | n/a            |
| ripgrep         |                         |                         | n/a            |                |          | n/a            | n/a            |
| rlwrap          |                         |                         | n/a            |                |          |                | n/a            |
| rsync           |                         |                         |                |                |          |                |                |
| ruby            |                         |                         |                |                |          |                |                |
| sl              |                         |                         | n/a            |                |          |                | n/a            |
| socat           |                         |                         |                |                |          |                |                |
| sqlite          | sqlite3                 | sqlite3                 |                |                | sqlite3  | sqlite3        | sqlite3        |
| sshpass         |                         |                         |                |                |          |                |                |
| strace          |                         |                         |                |                |          |                |                |
| sudo            |                         |                         |                |                |          |                |                |
| tar             |                         |                         |                |                |          |                |                |
| tig             |                         |                         | n/a            |                |          |                | n/a            |
| tmux            |                         |                         |                |                |          |                |                |
| unzip           |                         |                         |                |                |          |                |                |
| util-linux      |                         |                         |                |                |          |                |                |
| virt-what       |                         |                         | n/a            |                |          |                | n/a            |
| wget            |                         |                         |                |                |          |                |                |
| xmlstarlet      |                         |                         |                |                |          |                |                |
| xz              | xz-utils                | xz-utils                |                |                |          |                |                |
| zip             |                         |                         |                |                |          |                |                |
| zsh             |                         |                         |                |                |          |                |                |
| zstd            |                         |                         |                |                |          |                |                |

**Notes:**
- If a package is renamed, the table shows the actual name used for that distro.
- The `n/a` entries indicate that the package is not applicable or not available for that distro.

## Version-specific package rules

These rules allow you to customize the package list for specific distributions and versions. Each rule starts with a line like `- distro:version ...` followed by a list of modifications:
- `+pkgname` adds a package for that version.
- `-pkgname` disables (removes) a package for that version.
- `pkg1=>pkg2` renames `pkg1` to `pkg2` for that version.

For example, `- ubuntu:16.04 neovim=>vim -ripgrep -universal-ctags` means that on Ubuntu 16.04, `neovim` is replaced with `vim`, and `ripgrep` and `universal-ctags` are removed from the package list.

### Debian

- debian:10     -doas

### Ubuntu

- ubuntu:24.04             -fd                      -libqrencode -lzo
- ubuntu:22.04  -doas      -fd                      -libqrencode -lzo
- ubuntu:20.04  -doas -eza -fd                      -libqrencode -lzo
- ubuntu:18.04  -doas -eza -fd -fzf -kitty-terminfo -libqrencode -lzo -lz4             -ripgrep -universal-ctags
- ubuntu:16.04  -doas -eza -fd -fzf -kitty-terminfo -libqrencode -lzo -lz4 neovim=>vim -ripgrep -universal-ctags

### RedHat

- rhel:8        -mkpasswd
