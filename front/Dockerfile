FROM nginx:latest
# Override NGINX_CONFIG at build time
ARG NGINX_CONFIG=ci_80.conf
COPY $NGINX_CONFIG /etc/nginx/conf.d/default.conf
