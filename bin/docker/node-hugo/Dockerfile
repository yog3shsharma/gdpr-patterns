FROM    node:9.10.1

RUN     apt-get update && apt-get install vim -y
ENV     HUGO_VERSION 0.36.1
ENV     HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb

ADD     https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN     dpkg -i /tmp/hugo.deb                   && \
	    rm /tmp/hugo.deb
