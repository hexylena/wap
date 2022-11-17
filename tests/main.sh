#!/bin/bash

# Load the Wonderful Argument Parser library
. wap.sh

fn_req(){ ## <a> <b>
	wap_help <<< "fn1"
	wap_debug_available_args
}

fn_flag(){ ## [--flag]
	wap_help <<< "fn1"
	wap_debug_available_args
}

fn_flag_val(){ ## [--a=<desc>] [--b=<blah>]
	wap_help <<< "fn1"
	wap_debug_available_args
}

fn_flag_val_default(){ ## [--flag=2]
	wap_help <<< "fn1"
	wap_debug_available_args
}

fn_optional(){ ## [optional]
	wap_help <<< "fn1"
	wap_debug_available_args
}

fn_optional_default(){ ## [wetness=9]
	wap_help <<< "fn1"
	wap_debug_available_args
}

fn1(){ ## <x> <y|z> [user|email|id] [--a] [--b=] [--c=1]
	wap_help <<< "fn1"
	wap_debug_available_args
}

# Discover functions, handle unknown functions, help, etc.
wapify $@
