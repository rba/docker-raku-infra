# perl image is debian bullseye based
FROM perl:5.34.1

# Vim and Text::VimColor
RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends vim; \
    cpan -T Text::VimColor App::Mowyw Mojolicious HTML::Template::Compiled JSON IO::Socket::SSL

# install caddy
RUN set -ex; \
    curl -sLO https://github.com/caddyserver/caddy/releases/download/v2.4.6/caddy_2.4.6_linux_amd64.deb && \
    dpkg -i caddy_2.4.6_linux_amd64.deb && \
    rm -rf caddy_2.4.6_linux_amd64.deb
COPY Caddyfile /

# get raku.org repo and build
RUN set -ex; \
    git clone https://github.com/Raku/raku.org.git; \
    cd /raku.org; \
    mowyw --make

# get features repo and create file
RUN set -ex; \
    git clone https://github.com/Raku/features.git; \
    cd /features; \
    perl process.pl > /raku.org/online/compilers/features.html

# add cron and start it for update
RUN set -ex; \
    apt-get update && apt-get install -y --no-install-recommends cron
RUN set -ex; \
    crontab -l | \
    { cat; echo "PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"; echo "*/15 * * * * sh /update-docker.sh > /update-docker.log 2>&1"; } | \
    crontab -

COPY update-docker.sh /
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh /update-docker.sh

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["caddy", "run"]