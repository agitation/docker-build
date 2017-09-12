A build environment template for an Agitation app.

Usage
=====

**Before the first run:**

* Put this template into an empty directory on your build server.
* Clone the source repository into the `repo` subdirectory, e.g. `git clone https://github.com/my/project repo`.
* Optional: Check out the desired branch.
* Add a `app/config/parameters.yml` file with the required parameters.
* Make sure that the user running this script has access to all required Git repos (e.g. private repos behind SSH servers).
* Check if the `build.sh` script and the `Dockerfile` match your needs. If not, adapt them.

**Create a build:**

* Simply run the `build.sh` script. The first parameter to the script, if passed, will be used as the image tag.

**Important**

* Do NOT make local changes to the repo (except for the `parameters.yml` file). If changes are neccessary, apply them in the development environment.
* We will run `composer install` on the repo during the building process, so make sure that your `parameters.yml` is always up to date.
