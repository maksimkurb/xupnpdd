FROM lsiobase/alpine 

# install packages and symlink libs
WORKDIR /var/tmp/
RUN \
 echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
  build-base \
  git \
  psmisc \
  openssl-dev \
  util-linux-dev \
  mc \
  nano \
  wget \
  htop  && \
  wget https://ftp.openssl.org/source/old/0.9.x/openssl-0.9.8e.tar.gz && \
   tar -zxvf openssl-0.9.8e.tar.gz && \
  mkdir -p /home/user/src/ && \
  mv openssl-0.9.8e /home/user/src/openssl-0.9.8e && \
 echo "**** Clone and compile xupnpd source code ****" && \
  git clone https://github.com/sybdata/xupnpd.git && \
  cd xupnpd/src && \
  make && \
  mkdir -p \
	/etc/xupnpd && \
  mv /var/tmp/xupnpd/src/* /etc/xupnpd && \
  sed -i "s|interface='lo'|interface='br0'|g" "/etc/xupnpd/xupnpd.lua" && \
  sed -i "s|cfg.daemon=false|cfg.daemon=true|g" "/etc/xupnpd/xupnpd.lua" && \
# cleanup
  rm -rf \ 
  /var/tmp/xupnpd
COPY root/ /
WORKDIR / 
# ports and volumes 
EXPOSE 4044

