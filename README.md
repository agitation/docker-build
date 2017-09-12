A build environment template for an Agitation app.

Usage
=====

**Before the first run:**

* Put this template into an empty directory on your build server.
* Go to the `repo` directory and clone the source repository. Optional: Check out the desired branch.
* Add a `app/config/parameters.yml` file with the required parameters.
* Make sure that the user running this script has access to all required Git repos (e.g. private repos behind SSH servers).
* Check if the `build.sh` script and the `Dockerfile` match your needs. If not, adapt them.

**Create a build:**

* Simply run the `build.sh` script. The first parameter to the script, if passed, will be used as the build tag.
* The script will print the image ID to STDOUT and can then be started as a container.

**Important**

* Do NOT make local changes to the repo. If changes are neccessary, apply them in the development environment.
* We will run `composer install` on the repo during the building process, so make sure that your `parameters.yml` is always up to date.
