# 環境固有の設定を読み込む
if [ -f ~/.bash_logout.local ]; then
    source ~/.bash_logout.local
fi

if [ -z "$TMUX" ]; then
	eval `ssh-agent -ks`	# k:kill s:bash syntax
fi