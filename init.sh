#!/bin/bash

pass=$1

cat > /tmp/password.py <<EOF
import bcrypt
import sys
if not sys.argv[1]:
  sys.exit(10)
plaintext_pwd=sys.argv[1]
encrypted_pwd=bcrypt.hashpw(sys.argv[1], bcrypt.gensalt(rounds=10, prefix=b"2a"))
isCorrect=bcrypt.checkpw(plaintext_pwd, encrypted_pwd)
if not isCorrect:
  sys.exit(20);
print "{}".format(encrypted_pwd)
EOF

chmod +x /tmp/password.py

echo "Installing EPEL..."
sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm &> /dev/null

echo "Updating Packages..."
sudo yum update -y &> /dev/null

echo "Installing Java..."
cd /opt
wget  "https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.rpm" &> /dev/null
chmod +x /opt/jdk-17_linux-x64_bin.rpm &> /dev/null
sudo yum install -y java-1.8.0-openjdk-devel &> /dev/null
sudo rpm -Uvh /opt/jdk-17_linux-x64_bin.rpm  &> /dev/null

echo "Installing Jenkins XMLSTARTLET pip..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo &> /dev/null
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key &> /dev/null
sudo yum install -y jenkins xmlstarlet pip &> /dev/null


echo "Installing bcrypt..."
pip install bcrypt &> /dev/null

echo "Starting Jenkins..."
sudo systemctl start jenkins &> /dev/null
cd /var/lib/jenkins/users/admin* &> /dev/null


echo "Applying Password..."
admin_password=$(python /tmp/password.py $pass 2>&1) 
xmlstarlet -q ed --inplace -u "/user/properties/hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash" -v '#jbcrypt:'"$admin_password" config.xml &> /dev/null


echo "Restarting Jenkins..."
sudo systemctl restart jenkins &> /dev/null

echo "Installing Jenkins Plugins..."

cd /var/lib/jenkins/
wget http://localhost:8080/jnlpJars/jenkins-cli.jar &> /dev/null

plugins="cloudbees-folder antisamy-markup-formatter build-timeout credentials-binding timestamper ws-cleanup ant gradle github-branch-source pipeline-github-lib pipeline-stage-view git ssh-agent ssh-slaves mailer matrix-auth pam-auth email-ext"
for plugin in $plugins; do
  java -jar /var/lib/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$pass install-plugin $plugin 
done
java -jar /var/lib/jenkins/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:$pass safe-restart &> /dev/null 


echo "Cleanup"
sudo yum remove -y xmlstarlet &> /dev/null
sudo yum clean -y all &> /dev/null

echo "Done"