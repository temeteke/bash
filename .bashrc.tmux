tmux () {
	case "$1" in
		update-environment|update-env)
			$(which tmux) show-environment | grep -v "^-" | while read var; do
				export "$var"
			done
			;;
		"")
			$(which tmux)
			;;
		*)
			$(which tmux) "$*"
			;;
	esac
}