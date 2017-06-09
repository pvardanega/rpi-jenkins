Runs Jenkins on a raspberry pi.

Installed:

- git
- oracle jdk8
- maven 3
- docker + compatibility for docker-maven-plugin from spotify
- Jenkins

`docker run -p 8080:8080 -p 50000:50000 pvardanega/rpi-jenkins`

By default, all jenkins data are stored in /var/jenkins_home. If you want to provide a volume and attach it to the container, just:

`docker run -p 8080:8080 -p 50000:50000 -v $PWD/jenkins:/var/jenkins_home pvardanega/rpi-jenkins`
