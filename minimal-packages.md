# Packages to install for 'minimal' Linux instances.

This file documents a cross-distro list of recommended packages for minimal Linux installations. The table below maps each package to its corresponding name or availability on major distributions: Fedora, Debian, Ubuntu, RHEL, Alpine, Arch, openSUSE, and Photon. The list is machine-readable and used by the `install-minimal` script, which parses it with `awk` to automate package installation.

## Column documentation

- **fedora**, **debian**, **ubuntu**, **rhel**, **alpine**, **arch**, **opensuse**, **photon**: For each distribution, this column indicates the corresponding package name or its availability. If a package is not available or not applicable for a distribution, this is noted (e.g., as `n/a` or left blank). These columns allow mapping a generic package list to the specific naming or packaging conventions of each Linux distribution.
- **group**: Used to organize packages into collections based on their role or purpose (e.g., `core`, `base`). This allows for grouping and filtering when installing or summarizing packages.
- **description**: A brief textual explanation of the package's purpose or functionality. This is shown in listings and summaries, and may be truncated in some outputs to fit formatting constraints.

## Package list

| fedora           | groups     | description                                      | debian                  | ubuntu                  | rhel      | alpine         | arch          | opensuse       | photon         |
| ---------------- |------------|--------------------------------------------------| ----------------------- | ----------------------- | --------- | -------------- | ------------- | -------------- | -------------- |
| aria2            | base       | Advanced command-line download utility           |                         |                         | n/a       |                |               |                | n/a            |
| bash-completion  | base       | Tab completion for Bash shell                    |                         |                         |           |                |               |                | n/a            |
| byobu            | base       | Terminal multiplexer and window manager          |                         |                         | n/a       |                |               |                | n/a            |
| bzip2            | core, base | Compression utility for .bz2 files               |                         |                         |           |                |               |                |                |
| cloud-utils      | base       | Tools for cloud instance management              |                         |                         | n/a       |                |               | n/a            | n/a            |
| ctags            | base       | Generates tag files for source code navigation   | universal-ctags         | universal-ctags         | n/a       |                |               |                |                |
| curl             | core, base | Command-line tool for transferring data with URLs|                         |                         | n/a       |                |               |                |                |
| darkhttpd        | base       | Lightweight HTTP server                          | n/a                     | n/a                     | n/a       |                |               |                | n/a            |
| diffutils        | core, base | Tools for comparing files                        |                         |                         |           |                |               |                |                |
| dirmngr          | core, base | Certificate and CRL management for GnuPG         |                         |                         |           |                | n/a           |                | n/a            |
| doas             | core, base | Simple utility to run commands as another user   |                         |                         | n/a       |                |               | n/a            | n/a            |
| eza              | base       | Modern replacement for 'ls'                      | exa                     |                         | n/a       |                |               | n/a            | n/a            |
| fd-find          | core, base | Simple, fast and user-friendly file finder       |                         |                         | n/a       | fd             | fd            | fd             | n/a            |
| findutils        | core, base | Utilities for finding files                      |                         |                         |           |                |               |                |                |
| fping            | base       | Scriptable ping tool for multiple hosts          |                         |                         | n/a       |                |               |                |                |
| fzf              | core, base | Command-line fuzzy finder                        |                         |                         | n/a       |                |               |                | n/a            |
| git              | core, base | Distributed version control system               |                         |                         |           |                |               |                |                |
| gnupg            | core, base | GNU Privacy Guard for encryption and signing     |                         |                         | gnupg2    |                |               |                |                |
| gzip             | core, base | Compression utility for .gz files                |                         |                         |           |                |               |                |                |
| htop             | base       | Interactive process viewer                       |                         |                         | n/a       |                |               |                | n/a            |
| inotify-tools    | base       | Command-line utilities for inotify               |                         |                         | n/a       |                |               |                |                |
| iproute          | core, base | Utilities for IP networking and traffic control  | iproute2                | iproute2                |           | iproute2       |               |                | iproute2       |
| iptraf-ng        | base       | Console-based network monitoring tool            |                         |                         | n/a       |                |               |                |                |
| jq               | core, base | Command-line JSON processor                      |                         |                         |           |                |               |                |                |
| kitty-terminfo   | core, base | Terminfo for the Kitty terminal emulator         |                         |                         | n/a       |                |               |                | n/a            |
| libnsl           | core, base | Network Services Library                         | n/a                     | n/a                     |           |                |               | n/a            |                |
| lolcat           | base       | Rainbow coloring for text output                 |                         |                         | n/a       | n/a            |               | n/a            |                |
| lshw             | base       | Hardware lister utility                          |                         |                         |           |                |               |                |                |
| lz4              | core, base | Fast compression algorithm and tool              |                         |                         |           |                |               |                |                |
| lzip             | core, base | Compression utility for .lz files                |                         |                         | n/a       |                |               |                | n/a            |
| lzop             | core, base | Fast file compressor using LZO                   |                         |                         |           |                |               |                | n/a            |
| make             | core, base | Utility to maintain groups of programs           |                         |                         |           |                |               |                |                |
| mkpasswd         | base       | Utility to generate encrypted passwords          | libstring-mkpasswd-perl | libstring-mkpasswd-perl |           |                | whois         | whois          |                |
| moreutils        | core, base | Additional useful Unix utilities                 |                         |                         | n/a       |                |               | n/a            | n/a            |
| neovim           | core, base | Modern Vim-based text editor                     |                         |                         | vim       |                |               |                | vim            |
| net-snmp-utils   | base       | SNMP utilities for network management            | snmp                    | snmp                    |           | net-snmp-tools | net-snmp      | net-snmp       | net-snmp       |
| nethogs          | base       | Network traffic monitor per process              |                         |                         | n/a       |                |               |                | n/a            |
| openssh-server   | core, base | Secure shell (SSH) server                        |                         |                         |           |                | openssh       |                |                |
| pass             | core, base | Standard Unix password manager                   |                         |                         | n/a       |                |               | password-store | password-store |
| patch            | core, base | Apply changes to files using patch files         |                         |                         |           |                |               |                |                |
| procps           | core, base | Utilities for monitoring system processes        |                         |                         | procps-ng |                |               |                | n/a            |
| pv               | base       | Monitor data progress through a pipe             |                         |                         | n/a       |                |               |                | n/a            |
| qrencode         | core, base | QR code generator                                |                         |                         | n/a       | libqrencode    |               |                | n/a            |
| rake             | base       | Ruby make-like build utility                     |                         |                         |           | ruby-rake      |               | n/a            |                |
| ripgrep          | core, base | Fast recursive search tool                       |                         |                         | n/a       |                |               | n/a            | n/a            |
| rlwrap           | base       | Readline wrapper for command-line interfaces     |                         |                         | n/a       |                |               |                | n/a            |
| rsync            | core, base | Fast incremental file transfer utility           |                         |                         |           |                |               |                |                |
| ruby             | core, base | Ruby programming language interpreter            |                         |                         |           |                |               |                |                |
| rubygem-bundler  | core, base | Ruby dependency manager                          | ruby-bundler            | ruby-bundler            |           | ruby-bundler   | ruby-bundler  | n/a            |                |
| rubygem-git      | core, base | Ruby interface to Git                            | ruby-git                | ruby-git                | n/a       | n/a            | n/a           | n/a            |                |
| rubygem-mustache | core, base | Logic-less Ruby templates                        | ruby-mustache           | ruby-mustache           | n/a       | ruby-mustache  | ruby-mustache | n/a            |                |
| rubygem-optimist | core, base | Ruby command-line option parser                  | ruby-optimist           | ruby-optimist           | n/a       | ruby-optimist  | ruby-optimist | n/a            |                |
| rubygem-pastel   | core, base | Ruby terminal color library                      | ruby-pastel             | ruby-pastel             | n/a       | n/a            | n/a           | n/a            |                |
| rubygem-sdoc     | core, base | Ruby documentation generator                     | ruby-sdoc               | ruby-sdoc               | n/a       | ruby-rdoc      | ruby-rdoc     | n/a            |                |
| rubygem-rspec    | core, base | Ruby testing framework                           | ruby-rspec              | ruby-rspec              | n/a       | ruby-rspec     | ruby-rspec    | n/a            |                |
| rubygem-thwait   | core, base | Ruby thread synchronization library              | ruby-thwait             | ruby-thwait             | n/a       | n/a            | n/a           | n/a            |                |
| rubygem-tracer   | core, base | Ruby code execution tracer                       | n/a                     | n/a                     | n/a       | n/a            | ruby-tracer   | n/a            |                |
| rubygem-webrick  | core, base | Ruby HTTP server library                         | ruby-webrick            | ruby-webrick            | n/a       | ruby-webrick   | ruby-webrick  | n/a            |                |
| screen           | core, base | Terminal multiplexer with session management     |                         |                         | n/a       |                |               |                |                |
| sl               | core, base | Steam Locomotive ASCII art fun command           |                         |                         | n/a       |                |               |                | n/a            |
| socat            | base       | Multipurpose relay for bidirectional data        |                         |                         |           |                |               |                |                |
| sqlite           | core, base | Lightweight SQL database engine                  | sqlite3                 | sqlite3                 |           |                | sqlite3       | sqlite3        | sqlite3        |
| sshpass          | base       | Non-interactive SSH password provider            |                         |                         |           |                |               |                |                |
| strace           | core, base | Trace system calls and signals                   |                         |                         |           |                |               |                |                |
| sudo             | core, base | Execute commands as another user                 |                         |                         |           |                |               |                |                |
| tar              | core, base | Archiving utility                                |                         |                         |           |                |               |                |                |
| tig              | base       | Text-mode interface for Git                      |                         |                         | n/a       |                |               |                | n/a            |
| tmux             | core, base | Terminal multiplexer                             |                         |                         |           |                |               |                |                |
| unzip            | core, base | Extractor for .zip archives                      |                         |                         |           |                |               |                |                |
| util-linux       | core, base | Essential system utilities                       |                         |                         |           |                |               |                |                |
| virt-what        | base       | Detects if running in a virtual machine          |                         |                         | n/a       |                |               |                | n/a            |
| wget             | core, base | Network downloader                               |                         |                         |           |                |               |                |                |
| xmlstarlet       | core, base | Command-line XML toolkit                         |                         |                         |           |                |               |                |                |
| xz               | core, base | Compression utility for .xz files                | xz-utils                | xz-utils                |           |                |               |                |                |
| zip              | core, base | Compression utility for creating zip archives    |                         |                         |           |                |               |                |                |
| zsh              | core, base | Z shell, advanced command interpreter            |                         |                         |           |                |               |                |                |
| zstd             | core, base | Fast compression algorithm and tool              |                         |                         |           |                |               |                |                |

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

- debian:10     -doas -ruby-optimist -ruby-pastel -ruby-thwait -ruby-webrick

### Ubuntu

- ubuntu:24.04
- ubuntu:22.04  -doas -eza
- ubuntu:20.04  -doas -eza
- ubuntu:18.04  -doas -eza -fd-find -fzf -kitty-terminfo -libqrencode -lzo -lz4             -ripgrep -ruby-optimist -ruby-pastel -ruby-thwait -ruby-webrick -universal-ctags
- ubuntu:16.04  -doas -eza -fd-find -fzf -kitty-terminfo -libqrencode -lzo -lz4 neovim=>vim -ripgrep -ruby-optimist -ruby-pastel -ruby-thwait -ruby-webrick -universal-ctags

### RedHat

- rhel:8        -mkpasswd
- rhel:8.5      -mkpasswd
