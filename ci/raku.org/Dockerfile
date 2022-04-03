# perl image is debian bullseye based
FROM perl:5.34.1
# plack and more is not needed any more
RUN apt-get update && apt-get install -y --no-install-recommends vim
RUN cpan -T Text::VimColor App::Mowyw
#RUN cpan -T install App::cpanminus; \
#    cpanm --notest App::Mowyw Plack IO::Socket::SSL HTML::Template::Compiled Mojolicious;
#RUN apt-get update && apt-get install -y --no-install-recommends vim && cpanm --notest Text::VimColor
RUN git clone https://github.com/Raku/raku.org.git
RUN cd ./raku.org; mowyw --make
# install caddy
RUN curl -sLO https://github.com/caddyserver/caddy/releases/download/v2.4.6/caddy_2.4.6_linux_amd64.deb && \
    dpkg -i caddy_2.4.6_linux_amd64.deb && \
    rm -rf caddy_2.4.6_linux_amd64.deb
#CMD cd ./raku.org; plackup
CMD cd ./raku.org/online; caddy file-server --listen :5000