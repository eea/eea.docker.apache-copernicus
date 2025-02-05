FROM eeacms/apache:2.4-3.4

RUN set -eux; \
  \
  apk add --no-cache \
  bzip2 \
  ca-certificates \
  dirmngr \
  dpkg-dev \
  gcc \
  gnupg \
  lua-dev \
  nghttp2-dev \
  pcre-dev \
  openssl-dev \
  libxml2-dev \
  make \
  wget \
  zlib-dev \
  cmake \
  build-base \
  apr-util-dev \
  libmaxminddb-dev \
  ; \
  mkdir -p maxmind; \
  wget https://github.com/maxmind/mod_maxminddb/releases/download/1.2.0/mod_maxminddb-1.2.0.tar.gz; \
  tar -xzf mod_maxminddb-1.2.0.tar.gz -C maxmind  --strip-components=1; \
  rm mod_maxminddb-1.2.0.tar.gz; \
  cd maxmind; \
  ./configure; \
  make install; \
  cd ..; \
  rm -rf maxmind; 

RUN sed -i 's|#LoadModule suexec_module modules/mod_suexec.so|LoadModule maxminddb_module modules/mod_maxminddb.so|' /usr/local/apache2/conf/httpd.conf
