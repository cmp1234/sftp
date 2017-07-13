FROM hicloudcmp/alpine-base:3.6
MAINTAINER Wang Lilong <wanglilong007@gmail.com>

ENV SSH_VERSION 7.4p1
ENV SSH_DOWNLOAD_URL http://mirrors.sonic.net/pub/OpenBSD/OpenSSH/portable/openssh-7.4p1.tar.gz
#ENV SSH_DOWNLOAD_SHA 6eaacfa983b287e440d0839ead20c2231749d5d6b78bbe0e0ffa3a890c59ff26


RUN set -ex; \
	\
	apk add --no-cache --virtual .build-deps \
		coreutils \
		gcc \
		linux-headers \
		make \
		musl-dev \
	; \
	\
	wget -O openssh.tar.gz "$REDIS_DOWNLOAD_URL"; \
	mkdir -p /usr/src/openssh; \
	tar -xzf openssh.tar.gz -C /usr/src/openssh --strip-components=1; \
	rm openssh.tar.gz; \
  \
	make -C /usr/src/openssh -j "$(nproc)"; \
	make -C /usr/src/openssh install; \
	\
	rm -r /usr/src/openssh; \
	\
	apk del .build-deps


# add openssh and clean
#RUN apk add --update 'openssh=7.4_p1-r0' && apk search -v openssh \
#&& rm  -rf /tmp/* /var/cache/apk/*
# add entrypoint script
ADD docker-entrypoint.sh /usr/local/bin
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
