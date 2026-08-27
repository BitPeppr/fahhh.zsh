autoload -Uz add-zsh-hook

__fahhh_last_exit=0
if (( ${+functions[precmd]} )) && [[ "${functions[precmd]}" != *__fahhh_last_exit* ]]; then
	# Save original as __fahhh_orig_precmd if not already saved
	if (( ! ${+functions[__fahhh_orig_precmd]} )); then
		functions[__fahhh_orig_precmd]="${functions[precmd]}"
	fi
fi

precmd() {
	__fahhh_last_exit=$?
	if (( ${+functions[__fahhh_orig_precmd]} )); then
		__fahhh_orig_precmd "$@"
	fi
}

__error_sound_precmd() {
	local dir="${0:A:h}"
	local sounds=($dir/*.mp3(N))
	if (( __fahhh_last_exit != 0 )) && (( ${#sounds} )); then
		local pick=$sounds[$(( RANDOM % ${#sounds} + 1 ))]
		afplay "$pick" &>/dev/null &!
	fi
}

__fahhh_save_exit() {
	if (( __fahhh_last_exit == 0 )); then
		local try=$?
		(( try != 0 )) && __fahhh_last_exit=$try
	fi
}

add-zsh-hook -D precmd __fahhh_save_exit 2>/dev/null
add-zsh-hook -D precmd __error_sound_precmd 2>/dev/null
add-zsh-hook precmd __fahhh_save_exit
add-zsh-hook precmd __error_sound_precmd
