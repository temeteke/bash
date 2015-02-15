# tmux and ssh-agent
# via http://robinwinslow.co.uk/2012/07/20/tmux-and-ssh-auto-login-with-ssh-agent-finally.html
if [ -z "$TMUX" ]; then
	# we're not in a tmux session


	# if ssh auth variable is missing
	if [ -z "$SSH_AUTH_SOCK" ]; then
		export SSH_AUTH_SOCK="$HOME/.ssh/.auth_socket"
	fi

	# if socket is available create the new auth session
	if [ ! -S "$SSH_AUTH_SOCK" ]; then
		eval `ssh-agent -s -a $SSH_AUTH_SOCK`	# s:bash syntax
		echo $SSH_AGENT_PID > $HOME/.ssh/.auth_pid
	fi

	# if agent isn't defined, recreate it from pid file
	if [ -z $SSH_AGENT_PID ]; then
		export SSH_AGENT_PID=`cat $HOME/.ssh/.auth_pid`
	fi

	# Add all default keys to ssh auth
	#ssh-add 2>/dev/null

	# start tmux
	# via http://www.omakase.org/misc/tmux_screen.html
	if which tmux > /dev/null 2>&1; then
		if [ -z "$(tmux ls)" ] ; then
			tmux
		else
			tmux attach
		fi
	fi
fi

# bash completion
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if which git > /dev/null 2>&1; then
	# Mac
	if [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
		source /usr/local/etc/bash_completion.d/git-prompt.sh
	fi
	if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
		source /usr/local/etc/bash_completion.d/git-completion.bash
	fi
	# Ubuntu
	#if [ -f /etc/bash_completion.d/git-prompt ]; then
	#	source /etc/bash_completion.d/git-prompt
	#fi
	#if [ -f /etc/bash_completion.d/git ]; then
	#	source /etc/bash_completion.d/git
	#fi
	# FreeBSD
	if [ -f /usr/local/share/git-core/contrib/completion/git-prompt.sh ]; then
		source /usr/local/share/git-core/contrib/completion/git-prompt.sh
	fi
	if [ -f /usr/local/share/git-core/contrib/completion/git-completion.bash ]; then
		source /usr/local/share/git-core/contrib/completion/git-completion.bash
	fi
	# Fedora
	if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
		source /usr/share/git-core/contrib/completion/git-prompt.sh
	fi
	# Arch Linux
	if [ -f /usr/share/git/completion/git-completion.bash ]; then
		source /usr/share/git/completion/git-completion.bash
	fi
	if [ -f /usr/share/git/completion/git-prompt.sh ]; then
		source /usr/share/git/completion/git-prompt.sh
	fi
	GIT_PS1_SHOWDIRTYSTATE=true
fi

# プロンプト
# via http://d.hatena.ne.jp/notogawa/20120720/1342756620
if type __git_ps1 > /dev/null 2>&1; then
	PS1_GIT='\[\033[0;31m\]$(__git_ps1)'
else
	PS1_GIT=''
fi
PS1_LEFT='\[\033[0;33m\]\u@\h \[\033[0;34m\]\w'$PS1_GIT
PS1_RIGHT='\[\033[0;36m\][`date "+%F %T"`]'
PS1_2='\[\033[0;37m\]\$ '
if [ $[COLUMNS] -eq 0 ]; then
	export PS1="$PS1_LEFT $PS1_RIGHT\n$PS1_2\[\033[0m\]"	# for Cygwin
else
	export PS1="$PS1_LEFT\r"'\[\033[$[COLUMNS-21]C\]'"$PS1_RIGHT\n$PS1_2\[\033[0m\]"
fi

export CLICOLOR=1

# コマンドのエイリアス
alias sl=ls
alias l=ls
alias crontab='crontab -i'
alias less='less -R'

if echo $OSTYPE | grep linux > /dev/null || [ $OSTYPE = "cygwin" ]; then
	alias ls='ls -v --color=auto --time-style=long-iso'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi

# Cygwinの文字化け対策
# via http://orumin.blogspot.jp/2012/05/cygwin-linuxwindows-gccvimusb.html
if [ $OSTYPE = "cygwin" ] && type cocot > /dev/null 2>&1; then
	alias ipconfig="cocot ipconfig"
	alias ifconfig="cocot ipconfig"
	alias ping="cocot ping"
	alias arp="cocot arp"
	alias nslookup="cocot nslookup"
	alias traceroute="cocot tracert"
	alias tracert="cocot tracert"
	alias route="cocot route"
	alias netstat="cocot netstat" 
fi

# エディタの設定
if type vim > /dev/null 2>&1; then
	export EDITOR=vim
	export SVN_EDITOR=vim
fi

# 環境固有の設定を読み込む
if [ -f ~/.bashrc.local ]; then
    source ~/.bashrc.local
fi

# 日本語の設定
case $TERM in
	linux) export LANG=C ;;
	*) export LANG=ja_JP.UTF-8 ;;
esac

# Ctrl-s,Ctrl-qがVimとかでつかえるようにする
# via http://d.hatena.ne.jp/ksmemo/20110214/p1
# via http://www.akamoz.jp/you/uni/shellscript.htm
if [ -t 0 ]; then
	stty -ixon -ixoff
fi

# cd to public
function cdp {
	[ $# -eq 0 ] && path=$PWD || path=$*
	path=$(cd $(dirname "$path") && pwd)/$(basename "$path")
	case $path in
		/home/$USER*) cd ${path/\/home\/$USER/\/home\/public} ;;
		/home/public*) cd ${path/\/home\/public/\/home\/$USER} ;;
	esac
}