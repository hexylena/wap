#!/bin/bash

# Load the Wonderful Argument Parser library
. wap.sh

# Define our function
fn() { ## <req> <req2> [optionalA] [optionalB] [--weeks=24] [--email=user@host] [--flag1] [--flag2]
	wap_help <<< "This is an example WAP-ified function"
	wap_debug_available_args
}

# Parse the arguments.
# WAP searches out the function (in this script), and exports the appropriate variables.
wonderful_argument_parser fn $@

# Call the function
fn
