#!/bin/bash

set -e
export SYMFONY_ENV=prod

cd /srv/www

# insert config values from environment

for param in database_driver database_server_version database_host database_port database_name database_user database_pass mailer_transport mailer_host mailer_port mailer_user mailer_password mailer_encryption mailer_authmode mailer_testaccount; do
    echo "$param: ${!param}" >> /tmp/test.txt
    [ -z "${!param}" ] || perl -i -pe "s|$param\s?:.*$|$param: ${!param}|g" app/config/parameters.yml
done

# wait until database server is started and DB is initialized

mysql_command="mysql"
dbhost="$(grep database_host app/config/parameters.yml | perl -pe 's|^.*database_host\s?:\s*||g')"
dbname="$(grep database_name app/config/parameters.yml | perl -pe 's|^.*database_name\s?:\s*||g')"
dbuser="$(grep database_user app/config/parameters.yml | perl -pe 's|^.*database_user\s?:\s*||g')"
dbpass="$(grep database_pass app/config/parameters.yml | perl -pe 's|^.*database_pass\s?:\s*||g')"

try=0
ok=0

if [ "$dbname" ]; then
    [[ -z "$dbhost" || "$dbhost" = "null" ]] || mysql_command="$mysql_command -h$dbhost"
    [[ -z "$dbuser" || "$dbuser" = "null" ]] || mysql_command="$mysql_command -u$dbuser"
    [[ -z "$dbpass" || "$dbpass" = "null" ]] || mysql_command="$mysql_command -p$dbpass"

    until $mysql_command -e "USE $dbname" && ok=1; do
        [ $((++try)) -gt 30 ] && break
        sleep 1
    done
fi

if [ $ok -gt 0 ]; then
    app/console doctrine:schema:update --force --complete
    app/console cache:clear
    app/console agit:seeds:update

    chown -R www-data: /srv/www/app/cache /srv/www/app/logs
else
    exit 1
fi
