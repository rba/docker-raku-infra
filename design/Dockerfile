#FROM alpine:3.10
FROM jjmerelo/alpine-perl6

ENV build_dir=/tmp/build
ENV target_dir=/srv/design.raku.org

RUN buildDeps=' \
        perl-app-cpanminus \
		perl-file-find-rule \
		perl-file-slurp \
		perl-file-sharedir \
		perl-cgi \
		perl-class-accessor \
        git \
    ' \
    \
    && set -x \
    && apk add --no-cache --virtual .build-deps $buildDeps \
    \
	&& mkdir -p ${build_dir} \
	&& mkdir -p ${target_dir}

RUN set -x \
	&& zef install --/test Pod::To::HTML

RUN set -x \
	&& ( \
		for project in mu roast specs; do \
			git clone https://github.com/perl6/${project} ${build_dir}/${project}; \
			git -C ${build_dir}/${project} log --pretty=%h -1 > ${build_dir}/${project}/.revision; \
		done \
	)

RUN set -x \
	&& cd ${build_dir}/mu \
	&& perl util/smartlinks.pl --out-dir ${target_dir} --dir ${build_dir}/roast --css /perl-with-historical-message.css --line-anchor --pod-dir ${build_dir}/specs \
	&& perl util/podhtm.pl --css /perl-with-historical-message.css --url-prefix https://design.raku.org/ --url-postfix .html --index --charset=UTF-8 --out ${build_dir}/Differences.html docs/Perl6/Perl5/Differences.pod \
	&& cp ${build_dir}/specs/html/* ${target_dir}

RUN set -x \
	&& cd ${build_dir}/specs \
	&& grep -vE '^(#.*|\s*)$' pod6-files | ( \
		while read LINE; do \
   			INPUT=$(echo $LINE | cut -d ' ' -f 1); \
    		OUTPUT=$(echo $LINE | cut -d ' ' -f 2); \
		    perl6-m -MMONKEY-SEE-NO-EVAL -MPod::To::HTML -e 'put pod2html EVAL(slurp(@*ARGS.shift) ~ "\n; \$=pod"), :css-url</perl-with-historical-message.css>' "$INPUT" > "${target_dir}/$OUTPUT"; \
		done \
	)

RUN apk del .build-deps

RUN apk add nginx \
	&& mkdir /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 3000

ENTRYPOINT ["nginx"]
