
# ---------------------------
FROM archlinux

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]

# ---------------------------
FROM fedora

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]

# ---------------------------
FROM centos

COPY . /root/bin
RUN ls -alh /root/bin
WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]

# ---------------------------
FROM opensuse/leap

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]

# ---------------------------
FROM debian

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]

# ---------------------------
FROM ubuntu:20.10

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]

# ---------------------------
FROM alpine

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

ENTRYPOINT [ "/usr/bin/env", "zsh" ]
