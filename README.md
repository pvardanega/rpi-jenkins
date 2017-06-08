Runs Jenkins on a raspberry pi

`docker run -p 8080:8080 -p 50000:50000 pvardanega/jenkins`

By default, all jenkins data are stored in /var/jenkins_home. If you want to provide a volume and attach it to the container, just:

`docker run -p 8080:8080 -p 50000:50000 -v $PWD/jenkins:/var/jenkins_home pvardanega/rpi-jenkins`