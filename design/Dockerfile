# Build image
FROM jjmerelo/alpine-raku as build

ARG url_prefix=https://design.raku.org/
ENV url_prefix=${url_prefix}
ARG organization=perl6

ENV build_dir=/tmp/build
ENV target_dir=/tmp/output
ENV api_base=https://api.github.com/repos/${organization}
ENV download_base=https://github.com/${organization}

RUN build_deps=' \
		perl-file-find-rule \
		perl-file-slurp \
		perl-file-sharedir \
		perl-cgi \
		perl-class-accessor \
		jq \
		unzip \
		curl \
	' \
	\
	&& set -x \
	&& apk add --no-cache ${build_deps} \
	&& zef install --/test Pod::To::HTML

RUN set -x \
	&& mkdir -p ${build_dir} \
	&& ( \
		for project in mu roast specs; do \
			revision=$(curl ${api_base}/${project}/branches/master | jq -r .commit.sha); \
			project_base=${build_dir}/${project}; \
			zip_file=${project_base}.zip; \
			wget -O ${zip_file} ${download_base}/${project}/archive/${revision}.zip; \
			unzip -d ${build_dir} -q ${zip_file}; \
			mv ${project_base}-* ${project_base}; \
			echo ${revision} | head -c 8 > ${project_base}/.revision; \
		done \
	)

RUN set -x \
	&& mkdir -p ${target_dir} \
	&& cd ${build_dir}/mu \
	&& perl util/smartlinks.pl --out-dir ${target_dir} --dir ${build_dir}/roast --css /perl-with-historical-message.css --line-anchor --pod-dir ${build_dir}/specs \
	&& perl util/podhtm.pl --css /perl-with-historical-message.css --url-prefix ${url_prefix} --url-postfix .html --index --charset=UTF-8 --out ${target_dir}/Differences.html docs/Perl6/Perl5/Differences.pod \
	&& cp ${build_dir}/specs/html/* ${target_dir}

RUN set -x \
	&& cd ${build_dir}/specs \
	&& grep -vE '^(#.*|\s*)$' pod6-files | ( \
		while read LINE; do \
			input=$(echo $LINE | cut -d ' ' -f 1); \
			output=$(echo $LINE | cut -d ' ' -f 2); \
			perl6-m -MMONKEY-SEE-NO-EVAL -MPod::To::HTML -e 'put pod2html EVAL(slurp(@*ARGS.shift) ~ "\n; \$=pod"), :css-url</perl-with-historical-message.css>' "${input}" > "${target_dir}/${output}"; \
		done \
	)


# nginx image
FROM alpine:3.11 as nginx

RUN apk add nginx \
	&& mkdir /run/nginx

COPY nginx.conf /etc/nginx/nginx.conf


# Release image
FROM nginx as release

COPY --from=build /tmp/output /var/www

EXPOSE 3000

CMD ["nginx"]
