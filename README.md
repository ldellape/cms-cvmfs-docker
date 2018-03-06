This project is used to create a Docker container which can access the CMS LHC experiment's CVMFS file system.

Branch|Build|Type|Pulls|Stars|Docker Hub
---|---|---|---|---|---
latest | [![Docker Build Status](https://img.shields.io/docker/build/aperloff/cms-cvmfs-docker.svg)](https://img.shields.io/docker/build/aperloff/cms-cvmfs-docker.svg) | [![Docker Build Type](https://img.shields.io/docker/automated/aperloff/cms-cvmfs-docker.svg)](https://img.shields.io/docker/automated/aperloff/cms-cvmfs-docker.svg) | [![](https://img.shields.io/docker/pulls/aperloff/cms-cvmfs-docker.svg)](https://img.shields.io/docker/pulls/aperloff/cms-cvmfs-docker.svg) | [![](https://img.shields.io/docker/stars/aperloff/cms-cvmfs-docker.svg)](https://img.shields.io/docker/stars/aperloff/cms-cvmfs-docker.svg) | [cms-cvmfs-docker](https://hub.docker.com/r/aperloff/cms-cvmfs-docker/)

--------------------------------------------
Setting up the container

Change the password used to login via ssh to the container
- open the Dockerfile file and find the line containing 'chpasswd'
- change the default password to something unique

In the directory containing the Dockerfile file, run this commands
> docker build -t cms-cvmfs-docker .

If you would rather not build the container yourself, you can always check it out from Docker Hub.
> docker pull aperloff/cms-cvmfs-docker:[tag]

The number of tags varies from time to time based on the current number of branches in GitHub. There will always be a `latest` tag, which is built from the master branch.

--------------------------------------------
Starting the container for the first time

To run the container as a background daemon
> docker run -d -P --privileged --name cms-cvmfs -v <local directory on your machine containing files you want to access>:/root/<subdirectory in container to get files> cms-cvmfs-docker

To determine which port to use when doing ssh into the container
> docker port cms-cvmfs 22

the output should be something like
0.0.0.0:32768

Then to ssh into the container, use the obtained from the previous command, e.g.
> ssh root@0.0.0.0 -p 32768

Use the password you set in the Dockerfile

Run the following command the very first time you run the container in order to mount the cvmfs file system
> ./run.sh

--------------------------------------------
Setting up an CMSSW area

Once inside the container, you can setup the CMSSW area in the standard way

- do the initial setup to get the 'scram' command
> source /cvmfs/cms.cern.ch/cmsset_default.sh
- move to a directory you want to make a CMSSW work area
- see what CMSSW versions are available
> scram list -a CMSSW 
- setup a work area for a specific version, e.g.
> scram project CMSSW_8_0_0

--------------------------------------------
Setting up XRootD and VOMS software

> source /cvmfs/oasis.opensciencegrid.org/mis/osg-wn-client/current/el6-x86_64/setup.sh
- you will need to set up your own grid certificate
> mkdir .globus
> cd .globus/
> openssl pkcs12 -in mycert.p12 -clcerts -nokeys -out usercert.pem
> openssl pkcs12 -in mycert.p12 -nocerts -out userkey.pem
> chmod 400 userkey.pem
> chmod 400 usercert.pem
> cd ..
> chmod 700 .globus/
- for some reason you need to specify the usercert.pem and userkey.pem files manually
> voms-proxy-init -voms cms --valid 192:00 -cert .globus/usercert.pem -key .globus/userkey.pem

--------------------------------------------
Stopping a container

After logging out of the ssh session in the docker container, you can temporarily stop the container daemon by doing
> docker stop cms-cvmfs

--------------------------------------------
Restarting a container

You can restart a container after it had been stopped by doing
> docker start cms-cvmfs

NOTE: after stopping and restarting a container, the port to use when doing ssh may have changed, make sure to rerun
> docker port cms-cvmfs 22

--------------------------------------------
Removing a container

If you decide you no longer need that particular container (perhaps you want to start another fresh one), you can delete that container instance by doing
> docker rm cms-cvmfs


--------------------------------------------
Acknowledgements

This work was based largely on the following work of others
https://twiki.cern.ch/twiki/bin/view/Main/DockerCVMFS
https://github.com/cms-sw/cms-docker/blob/master/cmssw/Dockerfile
http://cmsrep.cern.ch/cmssw/cms/slc6_amd64_gcc530-driver.txt
