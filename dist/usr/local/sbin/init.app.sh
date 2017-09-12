#!/bin/bash

set -e
export SYMFONY_ENV=prod

cd /srv/www

# insert config values from environment

for param in database_driver database_server_version database_host database_port database_name database_user database_password mailer_transport mailer_host mailer_port mailer_user mailer_password mailer_encryption mailer_authmode mailer_testaccount; do
    echo "$param: ${!param}" >> /tmp/test.txt
    [ -z "${!param}" ] || perl -i -pe "s|$param\s?:.*$|$param: ${!param}|g" app/config/parameters.yml
done

# wait until database server is started and DB is initialized

dbname="$(grep database_name app/config/parameters.yml | perl -pe 's|^.*database_name\s?:\s*||g')"
try_count=0
ok=0

if [ "$dbname" ]; then
    until mysql -e "USE $dbname" && ok=1; do
        [ $((++try_count)) -gt 30 ] && break
        sleep 1
    done
fi

if [ $ok -gt 0 ]; then
    app/console doctrine:schema:update --force --complete
    app/console cache:clear
    app/console agit:seeds:update
else
    exit 1
fi
