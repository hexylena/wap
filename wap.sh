#!/bin/bash
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

	# shellcheck disable=SC2068
	for x in $@; do
		args+=("$x");

		# If the help flag is in there, we can short-circuit
		if [[ "$x" == "--help" ]] || [[ "$x" == "-h" ]]; then
			return
		fi

		shift;
	done
	#echo "${signature[*]}"


	for arg in "${signature[@]}"; do
		if [[ "$arg" == '<'* ]]; then
			# This is a required argument
			positional_args+=("$(echo "$arg" | sed 's/^<//;s/>$//')")
		elif [[ "$arg" == '[--'* ]]; then
			# This is an optional argument
			optional_flag_args+=("$arg")
		elif [[ "$arg" == '['* ]]; then
			# This is an optional argument
			optional_args+=("$(echo "$arg" | sed 's/^\[//;s/\]$//')")
		else
			# This is an error
			echo "ERROR!!! Bad argument specification: $arg"
		fi
	done

	# Size of the arrays
	positional_count=${#positional_args[@]}
	optional_count=${#optional_args[@]}

	offset=0
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
				if [[ "$arg" == "[--"* ]]; then
					if [[ "$arg" == *'|'* ]]; then
						# This has another argument.
						# So we need to pop something else.
						# And increment offset so we don't re-process it
						if [[ "$arg" == '['$a_cur'|'* ]]; then
							val="${args[$offset+1]}"
							offset=$(( offset + 1 ))
							parsed_keys+=("${a_cur/--/}")
							parsed_vals+=("$val")
						fi
					else
						# This is just a flag
						if [[ "$arg" == '['$a_cur']' ]]; then
							parsed_keys+=("${a_cur/--/}")
							parsed_vals+=(1)
						fi
					fi
				fi
			done
		else
			# This is a non-flag, so maybe a positional, maybe an optional argument.
			# So we need to find the Nth positional (via positional_index)
			if (( (positional_index + optional_index) >= (positional_count + optional_count) )); then
				echo "Error: more positional arguments than should be possible"
				exit 1;
			fi

			if (( positional_index < positional_count )); then
				parsed_keys+=("${positional_args[$positional_index]}")
				parsed_vals+=("${a_cur}")
				positional_index=$((positional_index + 1))
			else
				# We're past the positional and into the optional
				k="${optional_args[$optional_index]}"
				parsed_keys+=("$(echo "$k" | sed 's/|.*//g')")
				parsed_vals+=("${a_cur}")
				optional_index=$(( optional_index + 1 ))
			fi

		fi
		offset=$(( offset + 1 ))
	done

	if (( optional_index < optional_count )); then
		for i in $(seq $optional_index $((optional_count - 1)) ); do
			if [[ "${optional_args[$i]}" == *'|'* ]]; then
				k="${optional_args[$i]}"
				parsed_keys+=("$(echo "$k" | sed 's/|.*//g')")
				parsed_vals+=("$(echo "$k" | sed 's/.*|//g')")
			fi
		done
	fi

	if (( positional_index < positional_count )); then
		echo "More positional arguments are required"
		exit 1;
	fi

	size=${#parsed_keys[@]}
	for i in $(seq 0 $((size - 1))); do
		#printf "\t%10s=%-10s\n" "${parsed_keys[$i]}" "${parsed_vals[$i]}"
		export arg_${parsed_keys[$i]}=${parsed_vals[$i]}
	done
}
