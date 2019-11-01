FROM sl:6
MAINTAINER Alexx Perloff "Alexx.Perloff@Colorado.edu"

ADD cvmfs/cernvm.repo /etc/yum.repos.d/cernvm.repo
ADD cvmfs/default.local /etc/cvmfs/default.local
ADD cvmfs/run.sh /root/run.sh
ADD cvmfs/append_to_bashrc.sh /root/.append_to_bashrc.sh
ADD cvmfs/krb5.conf /etc/krb5.conf

RUN yum update -y \
    && yum install -y https://ecsft.cern.ch/dist/cvmfs/cvmfs-release/cvmfs-release-latest.noarch.rpm \
    && yum -y install emacs openssh-server nano cvmfs man freetype openssl098e libXpm libXext wget git  tcsh zsh tcl  perl-ExtUtils-Embed perl-libwww-perl compat-libstdc++-33 libXmu  libXpm  zip e2fsprogs krb5-devel krb5-workstation strace libXft ImageMagick ImageMagick-devel mesa-libGL mesa-libGL-devel mesa-libGLU mesa-libGLU-devel glx-utils libXrender-devel libXtst-devel xorg-x11-server-Xorg xorg-x11-xauth xorg-x11-apps openmotif openmotif-devel xz-devel \
    && yum clean all \
    && rm -rf /tmp/.X* \
    && usermod -a -G root root \
#    && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key \
    && cat /root/.append_to_bashrc.sh >> /root/.bashrc \
    && mkdir .globus \
    && chmod 0700 .globus \
    && mkdir /cvmfs/cms.cern.ch \
    && echo "cms.cern.ch /cvmfs/cms.cern.ch cvmfs defaults 0 0" >> /etc/fstab \
    && mkdir /cvmfs/cms-ib.cern.ch  \
    && echo "cms-ib.cern.ch /cvmfs/cms-ib.cern.ch cvmfs defaults 0 0" >> /etc/fstab  \
    && mkdir /cvmfs/oasis.opensciencegrid.org  \
    && echo "oasis.opensciencegrid.org /cvmfs/oasis.opensciencegrid.org cvmfs defaults 0 0" >> /etc/fstab  \
    && mkdir /cvmfs/cms-lpc.opensciencegrid.org  \
    && echo "cms-lpc.opensciencegrid.org /cvmfs/cms-lpc.opensciencegrid.org cvmfs defaults 0 0" >> /etc/fstab  \
    && mkdir /cvmfs/sft.cern.ch \
    && echo "sft.cern.ch /cvmfs/sft.cern.ch cvmfs defaults 0 0" >> /etc/fstab  \
    && mkdir /cvmfs/cms-bril.cern.ch  \
    && echo "cms-bril.cern.ch /cvmfs/cms-bril.cern.ch cvmfs defaults 0 0" >> /etc/fstab  \
    && mkdir /cvmfs/cms-opendata-conddb.cern.ch \
    && echo "cms-opendata-conddb.cern.ch /cvmfs/cms-opendata-conddb.cern.ch cvmfs defaults 0 0" >> /etc/fstab

#Change the password 'cms-docker' to something unique
#RUN echo 'root:cms-docker' |chpasswd

EXPOSE 22
ENTRYPOINT /root/run.sh && /bin/bash
