# https://raim.codingfarm.de/blog/2013/01/30/tmux-update-environment/
tmux() {
	local tmux=$(type -fp tmux)
	case "$1" in
		update-environment|update-env|env-update)
			local v
			while read v; do
				if [[ $v == -* ]]; then
					unset ${v/#-/}
				else
					# Add quotes around the argument
					v=${v/=/=\"}
					v=${v/%/\"}
					eval export $v
				fi
			done < <(tmux show-environment)
			;;
		*)
			$tmux "$@"
			;;
	esac
}
