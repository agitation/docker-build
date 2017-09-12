FROM agitation/app:latest

COPY dist/ /
COPY repo/ /srv/www/
