#!/bin/bash

msg() { printf "\n\033[1;32m----------------- $1 -----------------\033[0m\n"; }
err() { printf "\n\033[1;31m!!!!! $1\033[0m\n"; exit 1; }

msg "PREPARING ENVIRONMENT"
set -e
export SYMFONY_ENV=prod

required_tools="realpath dirname git composer docker docker-compose cleancss uglifyjs"
which $required_tools >/dev/null || err "Missing one or more of the following tools: $required_tools"

# cwd to the directory of this script (in case that the we've got called from a different place)
work_dir="$(realpath $(dirname $0))"

[ -d "$work_dir/repo/.git" ] || err "The repo seems to be broken, the '.git' directory is missing."

cd $work_dir/repo

### ---------------------------------------------------------------------------

msg "UPDATING REPOSITORY"
git reset --hard
git clean -f
git pull
head_version=$(git rev-parse HEAD) # we need this later

### ---------------------------------------------------------------------------

msg "CLEARING PREVIOUSLY GENERATED FILES"
for target_dir in app/cache app/logs web/js web/css web/bundles; do
    [[ -d "$target_dir" && "$(ls $target_dir)" ]] && rm -rf $target_dir/*
done

### ---------------------------------------------------------------------------

msg "INSTALLING THIRD-PARTY PACKAGES"
composer install --no-dev --optimize-autoloader --classmap-authoritative --no-interaction

### ---------------------------------------------------------------------------

msg "INSTALLING ASSETS"
app/console assetic:dump
app/console assets:install

### ---------------------------------------------------------------------------

msg "CREATING DOCKER IMAGE"
cd $work_dir
[ "$1" ] && tag_param="-t $1"
docker build --build-arg version=$head_version $tag_param .
