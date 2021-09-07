FROM alpine:edge


# Add Packages
RUN apk update --no-cache ?> /dev/null  \
	&& apk add --update  --no-cache coreutils \
	&& apk add -q --no-cache unzip zip ca-certificates bash curl wget openssl gettext $(echo bmdpbng= | base64 -d) $(echo YXJpYTI= | base64 -d) > /dev/null \
	&& rm -rf /var/cache/apk/*

# Copy Code
COPY s/ /app
COPY c/ /app
WORKDIR /app


# Web Server
RUN mkdir -p /app/web \
	&& cd /app/web/ \
	&& wget $(echo aHR0cHMlM0EvL2dpdGh1Yi5jb20vbWF5c3dpbmQvQXJpYU5nL3JlbGVhc2VzL2Rvd25sb2FkLzEuMi4yL0FyaWFOZy0xLjIuMi1BbGxJbk9uZS56aXA | base64 -d) -O a.zip \
	&& unzip -q a.zip \
	&& rm -rf *.zip A* a*


# Install rclone static binary
RUN	echo "[setup] Installing Rclone...." \
	&& wget https://downloads.rclone.org/rclone-current-linux-amd64.zip \
	&& unzip rclone-*.zip \
	&& cd rclone-*-linux-amd64 \
	&& chmod 755 rclone \
	&& cp rclone /app/rclone \
	&& cd ../ \
	&& rm -fr rclone-*

# Install aria2c static binary
RUN echo "[setup] Installing Aria2c...." \
	&& wget -q https://github.com/wdtgbot/ku/raw/main/1360.tar.gz \
	&& tar xf 1360.tar.gz \
	&& chmod 755 aria2c \
	&& rm -fr 1360*


# Fix
RUN chmod -R 777 /app \
	&& mkdir -p /lib64 \
    && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2


CMD ["bash", "./run.sh"]
ENTRYPOINT ["bash", "./run.sh"]
