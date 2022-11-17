#!/usr/bin/env bats
EXE=./example-auto.sh

@test "Ensure exits with one if no command specified" {
	run ${EXE}
	[ "$status" -eq 1 ]
}

@test "example a b" {
	run ./example.sh a b
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_email = user@host" ]
	[ "${lines[1]}" = "arg_req = a" ]
	[ "${lines[2]}" = "arg_req2 = b" ]
	[ "${lines[3]}" = "arg_weeks = 24" ]
}

@test "example a b optA" {
	run ./example.sh a b optA
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_email = user@host" ]
	[ "${lines[1]}" = "arg_optionalA = optA" ]
	[ "${lines[2]}" = "arg_req = a" ]
	[ "${lines[3]}" = "arg_req2 = b" ]
	[ "${lines[4]}" = "arg_weeks = 24" ]
}

@test "example a b c d" {
	run ./example.sh a b c d
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_email = user@host" ]
	[ "${lines[1]}" = "arg_optionalA = c" ]
	[ "${lines[2]}" = "arg_optionalB = d" ]
	[ "${lines[3]}" = "arg_req = a" ]
	[ "${lines[4]}" = "arg_req2 = b" ]
	[ "${lines[5]}" = "arg_weeks = 24" ]
}


@test "req/nothing" {
	run ${EXE} fn_req
	[ "$status" -eq 1 ]
}

@test "req/1" {
	run ${EXE} fn_req a
	[ "$status" -eq 1 ]
}

@test "req/2" {
	run ${EXE} fn_req a b
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_a = a" ]
	[ "${lines[1]}" = "arg_b = b" ]
}

@test "flag/0" {
	run ${EXE} fn_flag
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 0 ]
}

@test "flag/1" {
	run ${EXE} fn_flag --flag
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 1 ]
}

@test "flag_val/0" {
	run ${EXE} fn_flag_val
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 0 ]
}

@test "flag_val --a b" {
	run ${EXE} fn_flag_val --a b
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 1 ]
	[ "${lines[0]}" = "arg_a = b" ]
}

@test "flag_val --a c --b=d" {
	run ${EXE} fn_flag_val --a c --b=d
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 2 ]
	[ "${lines[0]}" = "arg_a = c" ]
	[ "${lines[1]}" = "arg_b = d" ]
}

@test "flag_val_default" {
	run ${EXE} fn_flag_val_default
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 1 ]
	[ "${lines[0]}" = "arg_flag = 2" ]
}

@test "flag_val_default --flag=1" {
	run ${EXE} fn_flag_val_default --flag=1
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 1 ]
	[ "${lines[0]}" = "arg_flag = 1" ]
}

@test "fn_optional" {
	run ${EXE} fn_optional
	[ "$status" -eq 0 ]
	[ "${#lines[@]}" -eq 0 ]
}

@test "fn_optional something" {
	run ${EXE} fn_optional something
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_optional = something" ]
}

@test "fn_optional_default" {
	run ${EXE} fn_optional_default
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_wetness = 9" ]
}

@test "fn_optional_default 123" {
	run ${EXE} fn_optional_default 123
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_wetness = 123" ]
}

@test "group_1 h m" {
	run ${EXE} group_1 h m
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_b = " ]
	[ "${lines[1]}" = "arg_c = 1" ]
	[ "${lines[2]}" = "arg_x = h" ]
	[ "${lines[3]}" = "arg_y = m" ]
}

@test "group_1 h m --a" {
	run ${EXE} group_1 h m --a
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_a = 1" ]
	[ "${lines[1]}" = "arg_b = " ]
	[ "${lines[2]}" = "arg_c = 1" ]
	[ "${lines[3]}" = "arg_x = h" ]
	[ "${lines[4]}" = "arg_y = m" ]
}

@test "group_1 h m --a --b=helena --c=saskia" {
	run ${EXE} group_1 h m --a --b=helena --c=saskia
	[ "$status" -eq 0 ]
	[ "${lines[0]}" = "arg_a = 1" ]
	[ "${lines[1]}" = "arg_b = helena" ]
	[ "${lines[2]}" = "arg_c = saskia" ]
	[ "${lines[3]}" = "arg_x = h" ]
	[ "${lines[4]}" = "arg_y = m" ]
}
