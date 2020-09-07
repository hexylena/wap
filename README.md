# Wonderful Argument Parser

A simple ./argument parser utilising my favourite trick of grepping through your own file.


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

## License

GPL-3.0
