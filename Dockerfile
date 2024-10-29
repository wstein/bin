ARG BASE_IMAGE=registry.fedoraproject.org/fedora:latest

FROM ${BASE_IMAGE}

RUN dnf install -y git-core bash-completion sudo &&\
	dnf clean all &&\
	rm -rf /var/cache/dnf

RUN groupadd -g 1000 foobar &&\
	useradd -u 1000 -g 1000 -m foobar -G wheel &&\
	echo "foobar ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER foobar
WORKDIR /home/foobar

RUN echo "source /usr/share/bash-completion/bash_completion" >> .bashrc &&\
	echo "source /usr/share/bash-completion/completions/git" >> .bashrc &&\
	echo "export PS1=\"\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ \"" >> .bashrc

RUN ls -alh &&\
	git clone https://github.com/wstein/.config

ENTRYPOINT [ "/usr/bin/bash" ]

