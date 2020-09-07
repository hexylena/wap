# Wonderful Argument Parser

A simple bash parser utilising my favourite trick of grepping through your own file.

This builds off of the work in [`gxadmin`](https://github.com/usegalaxy-eu/gxadmin) and provides a pretty acceptable CLI parser without the annoyances of setting up, shifting arguments, or validating that there aren't too many or too few.


```
# Load the Wonderful Argument Parser library
. wap.sh

# Define our function
fn() { ## <something> <sth2> [weeks] [--email|user@host] [--flag1] [--f3]
	echo "something=$arg_something"
	echo "     sth2=$arg_sth2"
	echo "    weeks=$arg_weeks"
	echo "    email=$arg_email"
	echo "    flag1=$arg_flag1"
	echo "       f3=$arg_f3"
}

# Parse the arguments.
wonderful_argument_parser fn $@

# Call the function
fn
```

When you run this example:


```
$ ./example.sh a b 4
something=a
     sth2=b
    weeks=4
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
More positional arguments are required
1$
```

and

```
$ ./example.sh a b c d
Error: more positional arguments than should be possible
1$
```

## License

GPL-3.0
