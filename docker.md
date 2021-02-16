# Docker

Below are the steps in creating the [docker.sh](./docker.sh) shell script:

1. Begin the line with the shebang `#!/bin/bash` to specify that the bourne again shell is required to run this script.

2. The LF unix-style line ending is essential to avoid vague errors.

3. Use `docker pull` to make initial downloads of the required images.

4. Copy the provided static site html file from current working directory to user directory.

5. Run `docker run` to create the containers. We use the `-dit` flag to run them in detached mode with an interactive prompt on `/bin/bash`. Make sure to name the containers for further reference. In the Nginx case, map the local `8080` port to the container's `80` port. Copy the site contents from `~/site-packages` into a mounted volume.

6. We will need to use ping, which is available by default on the Kibana image. Install on the other containers by running `docker exec` with the appropriate install directives.

7. Create a bash array to reference the container names for repetitive commands.

8. Create a docker bridge network `entNet`.

9. Connect each container to this new network.

10. Inspect the network to confirm.

11. Run `docker exec` into each instance and ping the two other instances with two pulses each.

12. Run `docker exec` into the Kibana container and `curl` the Nginx container to verify web functionality.

13. Create the cleanup script to tidy things up.

14. Annotate with comments and echos for clarity.
