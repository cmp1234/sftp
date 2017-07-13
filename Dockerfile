FROM hicloudcmp/alpine-base:3.6
MAINTAINER Wang Lilong <wanglilong007@gmail.com>

ENV SSH_VERSION 7.4p1
ENV SSH_DOWNLOAD_URL http://download.redis.io/releases/redis-3.2.9.tar.gz
ENV SSH_DOWNLOAD_SHA 6eaacfa983b287e440d0839ead20c2231749d5d6b78bbe0e0ffa3a890c59ff26
RUN apk search -v openssh
# add openssh and clean
RUN apk add --update 'openssh=7.5_p1-r1' \
&& rm  -rf /tmp/* /var/cache/apk/*
# add entrypoint script
ADD docker-entrypoint.sh /usr/local/bin
#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

EXPOSE 22
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/usr/sbin/sshd","-D"]
