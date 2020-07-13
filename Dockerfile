FROM sl:7
MAINTAINER Alexx Perloff "Alexx.Perloff@Colorado.edu"

ADD cvmfs/cernvm.repo /etc/yum.repos.d/cernvm.repo
ADD cvmfs/default.local /etc/cvmfs/default.local
ADD cvmfs/krb5.conf /etc/krb5.conf
ADD cvmfs/run.sh /run.sh
ADD cvmfs/mount_cvmfs.sh /mount_cvmfs.sh

# Needed for centos, not Scientific Linux
# RUN rpm -Uvh https://www.itzgeek.com/msttcore-fonts-2.0-3.noarch.rpm

RUN yum install -y deltarpm \
    && yum update -y \
    && yum install -y epel-release \
    && yum repolist \
    && yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
    && yum install -y emacs nano openssh-server nano cvmfs man freetype openssl098e libXpm libXext wget git \
       tcsh zsh tcl  perl-ExtUtils-Embed perl-libwww-perl compat-libstdc++-33 libXmu  libXpm  zip e2fsprogs \
       krb5-devel krb5-workstation strace libXft ImageMagick ImageMagick-devel mesa-libGL mesa-libGL-devel \
       mesa-libGLU mesa-libGLU-devel glx-utils libXrender-devel libXtst-devel xorg-x11-server-Xorg xorg-x11-xauth \
       xorg-x11-apps openmotif openmotif-devel xz-devel fluxbox tigervnc-server xterm \
    && yum clean all \
    && rm -rf /tmp/.X* \
    && for repo in cms.cern.ch cms-ib.cern.ch oasis.opensciencegrid.org \
       	   cms-lpc.opensciencegrid.org sft.cern.ch cms-bril.cern.ch cms-opendata-conddb.cern.ch; \
	   do mkdir /cvmfs/$repo; echo "$repo /cvmfs/$repo cvmfs defaults 0 0" >> /etc/fstab; \
	done \
    && groupadd cmsuser \
    && useradd -m -s /bin/bash -g cmsuser cmsuser \
# In sl6, the default limit of 1024 causes a problem if host UID == guest UID
# While this container uses sl7, this line is left for reference
#    && sed -i 's/1024/8192/' /etc/security/limits.d/90-nproc.conf
    && sed -i 's/4096/8192/' /etc/security/limits.d/20-nproc.conf

WORKDIR /home/cmsuser
ADD cvmfs/append_to_bashrc.sh .append_to_bashrc.sh
RUN cat .append_to_bashrc.sh >> .bashrc \
    && mkdir -p /home/cmsuser/.vnc
ADD cvmfs/xstartup /home/cmsuser/.vnc/xstartup

ENV GEOMETRY 1920x1080

ENTRYPOINT ["/run.sh"]
