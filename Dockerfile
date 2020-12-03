FROM php:7.2-apache

ARG VERSION

RUN curl https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions -o /usr/local/bin/install-php-extensions \
	&& chmod +x /usr/local/bin/install-php-extensions && sync && install-php-extensions gd mysqli \
	&& apt-get update && apt-get install -y git

COPY . /var/www/html/

RUN if test -z $VERSION ; then echo "Using master branch" ; else echo "Using tag/$VERSION" ; git checkout tags/$VERSION ; fi \
	&& rm -rf .git* \
	&& chown -R www-data:www-data *

ENTRYPOINT docker-php-entrypoint apache2-foreground
