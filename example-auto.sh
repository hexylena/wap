#!/bin/bash

# Load the Wonderful Argument Parser library
. wap.sh

fn_req(){ ## <a> <b>
	wap_help <<-EOF
		required
	EOF

	echo $arg_a
	echo $arg_b
}

fn_flag(){ ## [--flag]
	wap_help <<-EOF
		flag (bool)
	EOF
	echo $arg_flag
}

fn_flag_val(){ ## [--flag=<interval>]
	wap_help <<-EOF
		flag (val, no default)
	EOF
	echo $arg_flag
}

fn_flag_val_default(){ ## [--flag=2]
	wap_help <<-EOF
		flag (val, default)
	EOF

	echo $arg_flag
}

fn_optional(){ ## [optional]
	wap_help <<-EOF
		optional
	EOF

	echo $arg_optional
}

fn_optional_default(){ ## [optional_default=4]
	wap_help <<-EOF
		optional_default
	EOF

	echo $arg_optional_default
}

fn1(){ ## <x> <y|z> [user|email|id] [--a] [--b=] [--c=1]
	wap_help <<-EOF
		Documentation for fn1, it does blah
	EOF

	wap_debug_available_args
}

# Discover functions, handle unknown functions, help, etc.
wapify $@
