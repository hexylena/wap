#!/bin/bash
#WAP_SHOULD_EXIT=
#WAP_DEBUG=1

error() {
	(>&2 echo "$(tput setab 1)$*$(tput sgr0)")
}

wonderful_argument_parser() {
	# from the top, the function to look for
	fn=$1;
	# make it drop, so we can parse the rest
	shift;
	declare -a parsed_keys
	declare -a parsed_vals
	declare -a positional_args
	declare -a optional_flag_args
	declare -a optional_args
	declare -a args
	positional_index=0
	optional_index=0

	# shellcheck disable=SC2207
	signature=($(grep "${fn}()" "$0" | sed 's/.*## //g'))
	signature+=('[--help]') # This is always available
	# Not to specification.
	#signature+=('[-h]') # This is always available

	# shellcheck disable=SC2068
	for x in $@; do
		args+=("$x");
		shift;
	done

	if (( WAP_DEBUG == 1 )); then
		echo "Signature: ${signature[@]}"
	fi
	for arg in "${signature[@]}"; do
		if [[ "$arg" == '<'* ]]; then
			# This is a required argument
			positional_args+=("$(echo "$arg" | sed 's/^<//;s/>$//')")
		elif [[ "$arg" == '[--'* ]]; then
			# This is an optional argument
			optional_flag_args+=("$(echo "$arg" | sed 's/^\[//;s/\]$//')")
		elif [[ "$arg" == '['* ]]; then
			# This is an optional argument
			optional_args+=("$(echo "$arg" | sed 's/^\[//;s/\]$//')")
		else
			# This is an error
			error "ERROR!!! Bad argument specification: $arg"
		fi
	done

	# Size of the arrays
	positional_count=${#positional_args[@]}
	optional_count=${#optional_args[@]}

	if (( WAP_DEBUG == 1 )); then
		echo Positional args
		for arg in "${positional_args[@]}"; do echo "  $arg"; done;
		echo Optional args
		for arg in "${optional_args[@]}"; do echo "  $arg"; done;
		echo Optional flag args
		for arg in "${optional_flag_args[@]}"; do echo "  $arg"; done;
	fi

	# If the help flag is in there, we can short-circuit
	if [[ "$x" == "--help" ]] || [[ "$x" == "-h" ]]; then
		WAP_HELP=1
		WAP_HELP_POSITIONAL=
		for arg in "${positional_args[@]}"; do WAP_HELP_POSITIONAL="$WAP_HELP_POSITIONAL\n\t<$arg>"; done;
		WAP_HELP_OPTIONAL_FLAGS=
		for arg in "${optional_flag_args[@]}"; do WAP_HELP_OPTIONAL_FLAGS="$WAP_HELP_OPTIONAL_FLAGS\n\t[$arg]"; done;
		WAP_HELP_OPTIONAL=
		for arg in "${optional_args[@]}"; do WAP_HELP_OPTIONAL="$WAP_HELP_OPTIONAL\n\t[$arg]"; done;
		return
	fi

	offset=0

	# For every optional flag argument with a default value, we should set that.
	for arg in "${optional_flag_args[@]}"; do
		# Two types of args: with, without values
		if [[ "$arg" == "--"*'='* ]]; then
			key=$(echo "$arg" | sed 's/--//g;s/=.*//g')
			val=$(echo "$arg" | sed 's/--//g;s/.*=//g')

			# If it has <desc> then it's just a description, not a default.
			if [[ "$val" != '<'*'>' ]]; then
				parsed_keys+=("${key}")
				parsed_vals+=("${val}")
			fi
		fi
	done



	while true; do
		# Get the first bit of content from the arguments
		a_cur=${args[$offset]}
		if [[ "$a_cur" == "" ]]; then
			break
		fi

		if [[ "$a_cur" == "--"* ]]; then
			# This is a flag. So find the matching flag definition.
			for arg in "${optional_flag_args[@]}"; do
				# Two types of args: with, without values
				if [[ "$arg" == *'='* ]]; then
					# This has another argument.
					# So we need to pop something else.
					# And increment offset so we don't re-process it
					valueless_arg=$(echo "$arg" | sed 's/=.*//')
					valueless_acr=$(echo "$a_cur" | sed 's/=.*//')

					if [[ "$valueless_arg" == "$valueless_acr" ]]; then
						#echo "HI: a_cur=${a_cur} arg=${arg} valueless_arg=${valueless_arg} valueless_acr=${valueless_acr}"
						if [[ "${a_cur}" == "${valueless_acr}"'='* ]]; then
							val="$(echo "${a_cur}" | sed 's/.*=//g')"
						else
							val="${args[$offset+1]}"
							offset=$(( offset + 1 ))
						fi

						k="$(echo "$valueless_acr" | sed 's/^--//;s/-/_/g')"
						parsed_keys+=("${k}")
						parsed_vals+=("$val")

						if (( WAP_DEBUG == 1 )); then
							echo "Parsed ${k} = ${val}"
						fi
					fi
				else
					# This is just a flag
					if [[ "$arg" == $a_cur ]]; then
						k="$(echo "$a_cur" | sed 's/^--//;s/-/_/g')"
						parsed_keys+=("${k}")
						parsed_vals+=(1)

						if (( WAP_DEBUG == 1 )); then
							echo "Parsed ${k} = 1"
						fi
					fi
				fi
			done
		else
			# This is a non-flag, so maybe a positional, maybe an optional argument.
			# So we need to find the Nth positional (via positional_index)
			if (( (positional_index + optional_index) >= (positional_count + optional_count) )); then
				error "Error: more positional arguments than should be possible"
				if [[ -z $WAP_SHOULD_EXIT ]]; then
					exit 1;
				else
					return;
				fi
			fi

			if (( positional_index < positional_count )); then
				parsed_keys+=($(echo "${positional_args[$positional_index]}" | sed 's/|.*//g'))
				parsed_vals+=("${a_cur}")
				positional_index=$((positional_index + 1))
			else
				# We're past the positional and into the optional
				k="${optional_args[$optional_index]}"
				if [[ "$k" == *'='* ]]; then
					# Here there is a default supplied.
					k=$(echo "$k" | sed 's/=.*//g')
				fi

				parsed_keys+=("$(echo "$k" | sed 's/|.*//g')")
				parsed_vals+=("${a_cur}")
				optional_index=$(( optional_index + 1 ))
			fi

			if (( WAP_DEBUG == 1 )); then
				echo "Parsed ${parsed_keys[@]} = ${parsed_vals[@]}"
			fi
		fi
		offset=$(( offset + 1 ))
	done

	# Set all default optional args, if they aren't set
	#if (( optional_index < optional_count )); then
		#for i in $(seq $optional_index $((optional_count - 1)) ); do
			#if [[ "${optional_args[$i]}" == *'='* ]]; then
				#parsed_keys+=("$(echo "$optional_args" | sed 's/=.*//g')")
				#parsed_vals+=("$(echo "$optional_args" | sed 's/.*=//g')")
			#fi
		#done
	#fi

	if (( positional_index < positional_count )); then
		for i in $(seq $positional_index $(( positional_count - 1 )) ); do
			error "Required argument <${positional_args[$i]}> is missing"
		done
		if [[ -z $WAP_SHOULD_EXIT ]]; then
			exit 1;
		else
			return;
		fi
	fi

	size=${#parsed_keys[@]}
	for i in $(seq 0 $((size - 1))); do
		if (( WAP_DEBUG == 1)); then
			printf "SETTING\t%10s=%-10s\n" "${parsed_keys[$i]}" "${parsed_vals[$i]}"
		fi
		export arg_${parsed_keys[$i]}=${parsed_vals[$i]}
	done
}

wap_help() {
	if (( WAP_HELP == 1 )); then
		echo HELP [$fn]
		echo
		cat - | fold -w 80 | sed 's/^/\t/'
		echo
		echo -e "Positional Arguments"
		echo -e $WAP_HELP_POSITIONAL
		echo
		echo -e "Optional Arguments"
		echo -e $WAP_HELP_OPTIONAL
		echo -e $WAP_HELP_OPTIONAL_FLAGS
		exit 1
	fi
}

wap_debug_available_args() {
	for x in $(compgen -v | grep ^arg_ | sort); do
		echo "${x} = ${!x}"
	done
}

wapify() {
	# Discover functions
	fn=$1; shift;
	LC_ALL=C type "$fn" 2> /dev/null | grep -q 'function'
	ec=$?

	if (( ec != 0 )); then
		echo "Available commands:"
		echo
		grep '()\s*{\s*##' $0 | sed 's/().*//g' | sort
		exit 1
	fi

	wonderful_argument_parser $fn $@
	$fn
}
