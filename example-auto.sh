#!/bin/bash

# Load the Wonderful Argument Parser library
. wap.sh

# Define our function
fn1() { ## <something> <sth2> [testing] [weeks|24] [--email|user@host] [--flag1] [--f3]
	wap_help <<-EOF
		This does a lot of things with very many arguments. Prints out all of the arguments.
	EOF

	echo "something=$arg_something"
	echo "     sth2=$arg_sth2"
	echo "  testing=$arg_testing"
	echo "    weeks=$arg_weeks"
	echo "    email=$arg_email"
	echo "    flag1=$arg_flag1"
	echo "       f3=$arg_f3"
}

fn2() { ## <some> <other> [--args]
	wap_help <<-EOF
		This does something else, with some other arguments.
	EOF

	echo "     some=$arg_some"
	echo "    other=$arg_other"
	echo "     args=$arg_args"
}


# Discover functions, handle unknown functions, help, etc.
wapify $@
