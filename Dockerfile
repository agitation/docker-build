FROM agitation/app:latest

RUN rm -r /srv/www/*

COPY dist/ /
COPY repo/ /srv/www/

RUN sed -i -e "s|agit_build:.*$|agit_build: ${version}|g" /srv/www/app/config/build.yml
