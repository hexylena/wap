#!/bin/bash

# Load the Wonderful Argument Parser library
. wap.sh

# Define our function
fn() { ## <something> <sth2> [testing] [weeks|24] [--email|user@host] [--flag1] [--f3]
	echo "something=$arg_something"
	echo "     sth2=$arg_sth2"
	echo "  testing=$arg_testing"
	echo "    weeks=$arg_weeks"
	echo "    email=$arg_email"
	echo "    flag1=$arg_flag1"
	echo "       f3=$arg_f3"
}

# Parse the arguments.
# WAP searches out the function (in this script), and exports the appropriate variables.
wonderful_argument_parser fn $@

# Call the function
fn
