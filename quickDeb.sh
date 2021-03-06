#!/usr/bin/bash

flag=$1
# 判断权限
p="sudo"
user=$(whoami)
if [ "$user" == "root" ]; then
	p=
fi
function install_all() {
	# 安装 SpaceVim
	curl -sLf https://spacevim.org/cn/install.sh | sed -E 's/(https:\/\/(github|raw.githubusercontent))/https:\/\/ghproxy.com\/\1/g' | bash
	# 安装 gdb 插件: gef
	pip install capstone unicorn keystone-engine ropper
	git clone https://ghproxy.com/https://github.com/hugsy/gef.git ~/.gdb-plugin/gef
	echo "source ~/.gdb-plugin/gef/gef.py" >>~/.gdbinit
	# 安装 oh-my-zsh
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		sh -c "$(curl -fsSL https://ghproxy.com/https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sed -E 's/(https:\/\/(github|raw.githubusercontent))/https:\/\/ghproxy.com\/\1/g')"
	fi
}

# 换源
id=$(cat /etc/os-release | grep ^ID= | cut -d'=' -f 2)
codename=$(cat /etc/os-release | grep VERSION_CODENAME | cut -d'=' -f2)
$p curl https://mirrors.ustc.edu.cn/repogen/conf/$id-https-4-$codename -so /etc/apt/sources.list

if [ "$flag" == "-S" -o "$flag" == "--source-only" ]; then
	exit
fi

# 安装软件
$p apt update
$p apt install git vim zsh python3 python3-pip python-is-python3 gcc make gdb openssh-server openssh-client cmake screen checkinstall -y
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

if [ "$flag" == "-A" -o "$flag" == "--install-all" ]; then
	install_all
fi
