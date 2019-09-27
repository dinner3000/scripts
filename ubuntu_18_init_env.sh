#!/bin/sh -ex

#Set proxy if needed
export all_proxy=http://172.16.52.1:33888

#Oh my zsh - install
apt install -y zsh
curl -Lo omz_install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chmod +x omz_install.sh 
./omz_install.sh 
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosugg
git clone git://github.com/wting/autojump.git
cd autojump && ./install.py

#Oh my zsh - setup
#~/.zshrc -- custom omz
#ZSH_THEME="ys"
#DISABLE_UPDATE_PROMPT="true"
#plugins=( git node npm mvn autojump zsh-autosuggestions )
#[[ -s /root/.autojump/etc/profile.d/autojump.sh ]] && source /root/.autojump/etc/profile.d/autojump.sh
#autoload -U compinit && compinit -u

#Docker - install
apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository    "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt install docker-ce docker-ce-cli containerd.io
apt install -y docker-compose

#Docker setup
#/lib/systemd/system/docker.service - add below lines if needed
#Environment="HTTP_PROXY=http://172.16.52.1:33888" "HTTPS_PROXY=http://172.16.52.1:33888" "NO_PROXY=172.16.52.134"
#/etc/docker/daemon.json - add below lines if needed
#  "insecure-registries": [
#    "hub.devops.local",
#    "hub.devops.local:5000",
#    "172.16.52.129",
#    "172.16.52.129:5000"
#  ],
#  "registry-mirrors": [
#    "https://dockerhub.azk8s.cn",
#    "https://docker.mirrors.ustc.edu.cn",
#    "http://hub-mirror.c.163.com"
#  ],
systemctl daemon-reload; systemctl restart docker
docker run --rm hello-word

#Nodejs
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
apt install -y nodejs

apt install -y git maven
apt-get install gcc g++ make
apt install -y openjdk-8-jdk

git clone https://github.com/gcuisinier/jenv.git ~/.jenv
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.bash_profile
echo 'eval "$(jenv init -)"' >> ~/.bash_profile
echo 'export PATH="$HOME/.jenv/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(jenv init -)"' >> ~/.zshrc
jenv add /usr/lib/jvm/java-11-openjdk-amd64 
jenv add /usr/lib/jvm/java-8-openjdk-amd64
jenv versions
export JENV_ROOT=/usr/local/opt/jenv
eval "$(jenv init -)"
jenv doctor
jenv global 1.8
