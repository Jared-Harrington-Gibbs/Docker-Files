FROM ubuntu:17.10
LABEL maintainer="Jared Harrington-Gibbs"
LABEL description="A docker running a completely insecure telnet server"

ENV DISPLAY=":1.0"

RUN apt-get update && \ 
    DEBIAN_FRONTEND=noninteractive apt-get -y install telnetd xinetd && \
		service xinetd start && \
    apt-get autoremove -y && \
    apt-get autoclean -y && \
    rm -rf /var/lib/apt/lists/* && \
    echo root:malware | chpasswd && \
		echo "# default: on \n \
    # description: The telnet server serves telnet sessions; it uses unencrypted username/password pairs for authentication. \n \
    service telnet \n \
    { \n \
    disable = no \n \
    flags           = REUSE \n \
    socket_type     = stream \n \
    wait            = no \n \
    user            = root \n \
    server          = /usr/sbin/in.telnetd \n \
    log_on_failure  += USERID \n \
    }" | tee -a /etc/xinetd.d/telnet && \
		echo "pts/0\npts/1\npts/2\npts/3\npts/4\npts/5\npts/6\npts/7\npts/8\npts/9\n" | tee -a /etc/securetty

ENTRYPOINT ["bash"]
CMD ["-c","xinetd -dontfork -stayalive"]
