#!/bin/bash

# Load the Wonderful Argument Parser library
. wap.sh

fn_req(){ ## <a> <b>
	wap_help <<-EOF
		required
	EOF

	# This is a debug function to show you what variables are set.
	# You can just use the arguments named $arg_a and $arg_b
	# to access the values passed in.
	wap_debug_available_args
}

fn_flag(){ ## [--flag]
	wap_help <<-EOF
		flag (bool)
	EOF
	wap_debug_available_args
}

fn_flag_val(){ ## [--a=<interval>] [--b=<user_id>]
	wap_help <<-EOF
		flag (with a value, no default)
	EOF
	wap_debug_available_args
}

fn_flag_val_default(){ ## [--flag=2]
	wap_help <<-EOF
		flag (val, default)
	EOF

	wap_debug_available_args
}

fn_optional(){ ## [optional]
	wap_help <<-EOF
		optional
	EOF

	wap_debug_available_args
}

fn1(){ ## <x> <y|z> [user|email|id] [--a] [--b=] [--c=1]
	wap_help <<-EOF
		Documentation for fn1, it does lots of things!
	EOF

	wap_debug_available_args
}

# Discover functions, handle unknown functions, help, etc.
wapify $@
