# Taggle

A simple time tracker, which "tags" a timestamp with a simple message and
reports the delta in a human-readable format.

## Usage

```
$ taggle Writing taggle
$ taggle Showing taggle to coworkers
$ taggle Ticket #123
$ taggle Lunch
$ taggle -r
01h02m33s Writing taggle
00h05m45s Showing taggle to coworkers
03h21m02s Ticket #123
00h32m19s Lunch
$ ./bin/taggle -h
Usage: ./bin/taggle (options)
    -h, --help                       Show this help message
    -o, --output FILE                File to which time should be written (default: ~/.taggle
    -r, --report                     Print a time report
```
