#! /usr/bin/env stap
#
# Copyright (C) 2010-2015 Red Hat, Inc.
# Written by William Cohen <wcohen@redhat.com>
#
# The linetimes.stp script takes two arguments: where to find the function
# and the function name. linetimes.stp will instrument each line in the
# function. It will print out the number of times that the function is
# called, a table with the average and maximum time each line takes,
# and control flow information when the script exits.
#
# For example all the lines of the do_unlinkat function:
#
# stap linetimes.stp kernel do_unlinkat

global calls, times, last_pp, region, cfg

probe $1.function(@2).call { calls <<< 1 }
probe $1.function(@2).return {
  t = gettimeofday_us()
  s = times[tid()]
  if (s) {
    e = t - s
    region[last_pp[tid()]] <<< e
    cfg[last_pp[tid()], pp()] <<< 1
  }
  delete times[tid()]
  delete last_pp[tid()]
}

probe $1.statement(@2 "@*:*") {
  t = gettimeofday_us()
  s = times[tid()]
  if (s) {
    e = t - s
    region[last_pp[tid()]] <<< e
    cfg[last_pp[tid()], pp()] <<< 1
  }
  times[tid()] = t
  last_pp[tid()] = pp()
}

probe end {
  printf("\n%s %s call count: %d\n", @1, @2, @count(calls));
  printf("\n%-58s %10s %10s\n", "region", "avg(us)", "max(us)");
  foreach (p+ in region) {
    printf("%-58s %10d %10d\n", p, @avg(region[p]), @max(region[p]));
  }

  printf("\n\ncontrol flow graph information\n")
  printf("from\n\tto\n=======================\n")
  foreach ([src+] in region) {
     printf("%-s\n", src)
     foreach ([s,dest+] in cfg[src,*]) { # slice for all dest's
        printf("\t%-s %d\n", dest, @count(cfg[src,dest]));
     }
  }
}