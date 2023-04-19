#! /bin/bash
# userdata.sh

# set the server timezone
/bin/timedatectl set-timezone America/Los_Angeles

#  install basic packages
dnf install zip git -y

# install aws cmd 
cd /tmp
git clone https://github.com/toaigit/post-scripts.git
cd post-scripts
./install.aws

#  setup some variables
export BUCKETNAME="${s3bucket}"
export DOMAIN="${domain}"
export INSTID=`curl http://169.254.169.254/latest/meta-data/instance-id`
export REGION=`curl -s http://169.254.169.254/latest/meta-data/public-hostname | awk -F. '{print $2}'`
export PRIVIP=`curl -s curl http://169.254.169.254/latest/meta-data/local-ipv4`
#export DOMAIN=resourceonline.org
env 
export HN=`aws ec2 describe-instances --instance-id $INSTID --region $REGION --query 'Reservations[*].Instances[*].[PublicIpAddress,Tags[?Key==\`Name\`]]' --output text | grep Name | awk '{print $2}'`

#  add application owner account
useradd -s /bin/bash -m -d /home/appadmin -c "Application Admin" appadmin

#  set the hostname and the prompt
hostnamectl set-hostname $HN.$DOMAIN
echo "$PRIVIP $HN.local.io $HN" >> /etc/hosts
echo PS1=\"[\\u@$HN]\" >> /etc/bashrc
cat /etc/hosts | sed "s/localhost/localhost $HN/" > /tmp/hosts
cp -p /tmp/hosts /etc/hosts

#  mount additional volumes
cd /tmp/post-scripts
./runcmd-v2

#  clean up
/bin/rm /tmp/post-scripts

#  end of userdata.sh
