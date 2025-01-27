FROM cern/alma9-base
MAINTAINER Alexx Perloff "Alexx.Perloff@Colorado.edu"

ADD cvmfs/cern.repo /etc/yum.repos.d/cern.repo
ADD cvmfs/cernvm.repo /etc/yum.repos.d/cernvm.repo
ADD cvmfs/default.local /etc/cvmfs/default.local
ADD cvmfs/krb5.conf /etc/krb5.conf
ADD cvmfs/run.sh /run.sh
ADD cvmfs/mount_cvmfs.sh /mount_cvmfs.sh
ADD cvmfs/vnc_utils.sh /usr/local/vnc_utils.sh

# Needed for centos, not Scientific Linux
# RUN rpm -Uvh https://www.itzgeek.com/msttcore-fonts-2.0-3.noarch.rpm

#RUN yum install -y deltarpm 
RUN yum update -y 
RUN yum install -y epel-release 
RUN yum repolist 
RUN yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm 
#RUN yum install -y cern-get-sso-cookie 
RUN yum install -y emacs nano vim python3 openssh-server cvmfs man freetype libXpm libXext wget git 
RUN yum install -y       tcsh zsh tcl  perl-ExtUtils-Embed perl-libwww-perl  libXmu  libXpm  zip e2fsprogs 
RUN yum install -y       krb5-devel krb5-workstation strace libXft ImageMagick ImageMagick-devel mesa-libGL mesa-libGL-devel 
RUN yum install -y       mesa-libGLU mesa-libGLU-devel glx-utils libXrender-devel libXtst-devel xorg-x11-server-Xorg xorg-x11-xauth 
RUN yum install -y        openmotif openmotif-devel xz-devel tigervnc-server xterm 
RUN yum install -y pip
RUN /usr/bin/python3 -m pip install --no-cache-dir --upgrade pip 
RUN yum clean all 
RUN rm -rf /tmp/.X* 
RUN for repo in cms.cern.ch cms-ib.cern.ch oasis.opensciencegrid.org cms-lpc.opensciencegrid.org \
       	   sft.cern.ch cms-bril.cern.ch cms-opendata-conddb.cern.ch ilc.desy.de unpacked.cern.ch; \
	   do mkdir /cvmfs/$repo; echo "$repo /cvmfs/$repo cvmfs defaults 0 0" >> /etc/fstab; \
	done 
RUN groupadd cmsusr 
RUN useradd -m -s /bin/bash -g cmsusr cmsusr 
# In sl6, the default limit of 1024 causes a problem if host UID == guest UID
# While this container uses sl7, this line is left for reference
#    && sed -i 's/1024/8192/' /etc/security/limits.d/90-nproc.conf
#RUN sed -i 's/4096/8192/' /etc/security/limits.d/20-nproc.conf

# Install noVNC and WebSockify
RUN wget --no-check-certificate --content-disposition -O /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz https://github.com/novnc/noVNC/tarball/v1.1.0 \
    # --no-check-cerftificate was necessary for me to have wget not puke about https
    # Curl version: curl -LJO https://github.com/novnc/noVNC/tarball/v1.1.0
    && tar -C /usr/local -xvf /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz \
    && rm /usr/local/novnc-noVNC-v1.1.0-0-g9fe2fd0.tar.gz \
    && ln -s /usr/local/novnc-noVNC-0e9bdff /usr/local/novnc \
    && git clone https://github.com/novnc/websockify /usr/local/novnc/utils/websockify

WORKDIR /home/cmsusr
ADD cvmfs/append_to_bashrc.sh .append_to_bashrc.sh
RUN cat .append_to_bashrc.sh >> .bashrc \
    && rm .append_to_bashrc.sh \
    && mkdir -p /home/cmsusr/.vnc
ADD cvmfs/xstartup /home/cmsusr/.vnc/xstartup

ENV GEOMETRY 1920x1080

RUN yum install -y gcc-11

ENTRYPOINT ["/run.sh"]
