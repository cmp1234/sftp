FROM cmp1234/alpine-base:3.6
MAINTAINER Wang Lilong <wanglilong007@gmail.com>

ENV SSH_VERSION 7.4p1
ENV SSH_DOWNLOAD_URL http://mirrors.sonic.net/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz
#ENV SSH_DOWNLOAD_SHA 6eaacfa983b287e440d0839ead20c2231749d5d6b78bbe0e0ffa3a890c59ff26

COPY build_openssh.sh /build_openssh.sh 
RUN chmod +x /build_openssh.sh

RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		coreutils \
		gcc \
		linux-headers \
		make \
		musl-dev \
		zlib \
		zlib-dev \
		openssl \
		openssl-dev \
	; \
	apk add --no-cache --virtual .run-deps \
		libcrypto1.0 \
	; \
	\
	/build_openssh.sh; \
	\
	apk del .build-deps; \
	rm -f /build_openssh.sh;


# add openssh and clean
#RUN apk add --update 'openssh=7.4_p1-r0' && apk search -v openssh \
#&& rm  -rf /tmp/* /var/cache/apk/*
# add entrypoint script
ADD docker-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/local/openssh/sbin/sshd","-D"]
