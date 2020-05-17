# ------------------------------------------------------------------------
# NAME: DemoAddOneFilter.ps1
# AUTHOR: ed wilson, Microsoft
# DATE: 2/17/2009
#
# KEYWORDS: filter, demo
#
# COMMENTS: This script displays the entry into a filter 
#
# Best Practices
# ------------------------------------------------------------------------
Filter AddOne
{ 
 "add one filter"
  $_ + 1
}

1..5 | addOne 