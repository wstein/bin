# not working (neovim, exa)

# ---------------------------
FROM fedora

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal


# ---------------------------
FROM centos

COPY . /root/bin
RUN ls -alh /root/bin
WORKDIR /root/
RUN bin/setup-minimal


# ---------------------------
FROM opensuse/leap

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal


# ---------------------------
FROM debian

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

# ---------------------------
FROM ubuntu:20.10

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

# ---------------------------
FROM alpine

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

# ---------------------------
FROM archlinux

COPY . /root/bin

WORKDIR /root/
RUN bin/setup-minimal

