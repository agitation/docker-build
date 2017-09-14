FROM agitation/app:latest

RUN rm -r /srv/www/*

COPY dist/ /
COPY repo/ /srv/www/
