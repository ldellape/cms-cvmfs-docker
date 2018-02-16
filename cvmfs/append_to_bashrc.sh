
# add some aliases that don't exist by default in this container
alias lla='ll -ah'

# Check to see if the cvmfs folders are mounted
echo "Checking CVMFS mounts ..."
if cvmfs_config probe >/dev/null; then
    echo -e "\tAll CVMFS folders mounted"
else
    echo -e "\tAt least one CVMFS foldersis not mounted. Will automatially execute run.sh"
    ./run.sh
fi

# source some CMS/VOMS specific setup scripts
source /cvmfs/cms.cern.ch/cmsset_default.sh
source /cvmfs/oasis.opensciencegrid.org/mis/osg-wn-client/current/el6-x86_64/setup.sh