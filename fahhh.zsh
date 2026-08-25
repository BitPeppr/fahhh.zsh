autoload -Uz add-zsh-hook

__error_sound_precmd() {
	local last_exit=$?
	local dir="${0:A:h}"
	local sounds=($dir/*.mp3(N))
	if (( last_exit != 0 )) && (( ${#sounds} )); then
		local pick=$sounds[$(( RANDOM % ${#sounds} + 1 ))]
		afplay "$pick" &>/dev/null &!
	fi
}

add-zsh-hook precmd __error_sound_precmd
