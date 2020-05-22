# cts_flask_service
## Description
This is a template for new python/flask microservices.

### Local Setup
```bash
$ virtualenv --python=python3.7 venv
$ source venv/bin/activate
(env) $ pip install -r requires/development.txt
(env) $ pytest
```

```bash
export FLASK_ENV=development
export FLASK_APP=service.create_app
$ flask run
```

### Running with Docker
All dockerized projects require Yapta's JFROG credentials, if you've set them up before skip this. Simple add this to
your .bashrc or .zshrc

```bash
export JFROG_USER=<user> JFROG_PASS=<pass>
```
Then you can either restart your terminal or run either command:
```bash
source ~/.bashrc
source ~/.zshrc
```

Everything for running it in Docker has been packaged nicely in the Makefile. There is a section at the top which
includes variables that are used during the build process. To see what options are available in `make` simply run: 
```bash
make help
```
This will output the available commands, which should look something like below:
```
help                           Help command to see what commands are available and what they do
print-vars                     Print all configured variables that are required for startup
build                          Build the container
build-nc                       Build the container without caching
test                           Test the built application
run                            Run container on port configured in variables
up                             Build containers and run it on port configured in variables
destroy                        Stop and remove running container
```

### Notes for running locally
There are additional steps in the Makefile that you will probably not need unless you are debugging the build pipeline.
