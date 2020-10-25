# Wonderful Argument Parser

A simple bash function signature parser that turns function comments into a usable CLI. No bucket or mop required, this library takes care of all the mess.

## Alternatives?

Case & Loop                               | Getopt
---                                       | ---
![an ugly case statement](.img/case.png) | ![getopt commands are completely unreadable](.img/getopts.png)
Not something to write dozens of times    | Completely incomprehensible for newcomers.

Very ugly.

## Instead, WAP

```
# Load the Wonderful Argument Parser library
. wap.sh

# Define our function
fn() { ## <something> <sth2> [weeks|1] [--email|user@host] [--flag1] [--f3]

	# These variables are auto-magically set.
	echo "something=$arg_something"
	echo "     sth2=$arg_sth2"
	echo "    weeks=$arg_weeks"
	echo "    email=$arg_email"
	echo "    flag1=$arg_flag1"
	echo "       f3=$arg_f3"
}

# Parse the arguments, do the magic
wonderful_argument_parser fn $@

# Call the function
fn
```

When you run this example:


```
$ ./example.sh a b
something=a
     sth2=b
    weeks=
    email=
    flag1=
       f3=
$ ./example.sh a b --f3 4
something=a
     sth2=b
    weeks=4
    email=
    flag1=
       f3=1
$ ./example.sh a b --f3 4 --email h@localhost
something=a
     sth2=b
    weeks=4
    email=h@localhost
    flag1=
       f3=1
$ ./example.sh a b --f3 4 --email h@localhost --flag1
something=a
     sth2=b
    weeks=4
    email=h@localhost
    flag1=1
       f3=1
```

Mandatory arguments are ensured:

```
$ ./example.sh
Required argument <something> is missing
Required argument <sth2> is missing
```

and

```
./example.sh a b c d e
Error: more positional arguments than should be possible
```

## Variables

Var               | Usage
----------------- | ---
`WAP_SHOULD_EXIT` | If this is set, then it will **not** exit
`WAP_DEBUG`       | If this is set, then some debugging info will be printed


## Q & A

Q  | A
-- | --
Why no short flags | Something something be explicit everywhere

## License

GPL-3.0
