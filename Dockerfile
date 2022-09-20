FROM eeacms/apache:2.4-2.6 as builder
RUN set -eux; \
  \
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  apt-get install -y --no-install-recommends \
    bzip2 \
    ca-certificates \
    dirmngr \
    dpkg-dev \
    gcc \
    gnupg2 \
    liblua5.2-dev \
    libnghttp2-dev \
    libpcre3-dev \
    libssl-dev \
    libxml2-dev \
    make \
    wget \
    zlib1g-dev \
    cmake \
    build-essential \
    libaprutil1-dev \
  ; \
  rm -r /var/lib/apt/lists/*; \
  \
  mkdir -p maxmind; \
  wget https://github.com/maxmind/mod_maxminddb/releases/download/1.2.0/mod_maxminddb-1.2.0.tar.gz; \
  tar -xzf mod_maxminddb-1.2.0.tar.gz -C maxmind  --strip-components=1; \
  rm mod_maxminddb-1.2.0.tar.gz; \
  cd maxmind; \
  ./configure; \
  make install; \
  cd ..; \
  rm -rf maxmind

FROM eeacms/apache:2.4-2.6
COPY --from=builder  /usr/local/apache2/modules/mod_maxminddb.so  /usr/local/apache2/modules/
RUN sed -i 's|#LoadModule maxminddb_module modules/mod_maxminddb.so|LoadModule maxminddb_module modules/mod_maxminddb.so|' /usr/local/apache2/conf/httpd.conf
