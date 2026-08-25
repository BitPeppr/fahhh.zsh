autoload -Uz add-zsh-hook

__error_sound_precmd() {
	if (( $? != 0 )); then
		afplay "${0:A:h}/error_sound.mpd" &>/dev/null &!
	fi
}

add-zsh-hook precmd __error_sound_precmd
