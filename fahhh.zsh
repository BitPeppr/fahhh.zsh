# Fahhh.zsh, motivational terminal sound effects for zsh. If you can optimise the below, please do; I've no idea what I'm doing with zsh scripting, but it seems to work. Hopefully one day it'll actually become reliable / stable. 
#
# Oftentimes it seems there's a sort of 'race condition' going on? It seemed to conflict with p10k, among other things. 

autoload -Uz add-zsh-hook

add-zsh-hook -D precmd __fahhh_save_exit 2>/dev/null
add-zsh-hook -D precmd __error_sound_precmd 2>/dev/null
add-zsh-hook -D precmd __fahhh_precmd 2>/dev/null
if (( ${+functions[__fahhh_save_exit]} )); then
	unfunction __fahhh_save_exit 2>/dev/null
fi
if (( ${+functions[__error_sound_precmd]} )); then
	unfunction __error_sound_precmd 2>/dev/null
fi
if (( ${+functions[precmd]} )) && [[ "${functions[precmd]}" == *__fahhh_last_exit* ]]; then
	if (( ${+functions[__fahhh_orig_precmd]} )); then
		functions[precmd]="${functions[__fahhh_orig_precmd]}"
		unfunction __fahhh_orig_precmd 2>/dev/null
	else
		unfunction precmd 2>/dev/null
	fi
fi
if (( ${+functions[__fahhh_orig_precmd]} )); then
	unfunction __fahhh_orig_precmd 2>/dev/null
fi
unset __fahhh_last_exit 2>/dev/null

typeset -g __fahhh_dir
__fahhh_dir="${${(%):-%x}:A:h}"
if [[ -z "$__fahhh_dir" || "$__fahhh_dir" == "." || ! -d "$__fahhh_dir" ]]; then
	__fahhh_dir="${0:A:h}"
fi
if [[ -z "$__fahhh_dir" || ! -d "$__fahhh_dir" ]]; then
	__fahhh_dir="${${funcfiletrace[1]%:*}:A:h}"
fi

__fahhh_precmd() {
	local rc=$?
	local dir=$__fahhh_dir
	if [[ -z "$dir" || ! -d "$dir" ]]; then
		dir="${${(%):-%x}:A:h}"
		[[ -z "$dir" || ! -d "$dir" ]] && dir="${0:A:h}"
		__fahhh_dir=$dir
	fi
	local sounds=($dir/*.mp3(N))
	if (( rc != 0 )) && (( ${#sounds} )); then
		local pick=$sounds[$(( RANDOM % ${#sounds} + 1 ))]
		afplay "$pick" &>/dev/null &!
	fi
	return $rc
}

add-zsh-hook -D precmd __fahhh_precmd 2>/dev/null
typeset -ga precmd_functions 2>/dev/null
if (( ! ${precmd_functions[(I)__fahhh_precmd]} )); then
	precmd_functions=(__fahhh_precmd $precmd_functions)
fi
