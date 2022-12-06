#!/usr/bin/env ruby

# The size of the marker
MS = 4 # or 14 for part 2

# Not very efficient, but concise, way of finding the marker
p $<.read.split('').each_cons(MS).with_index.find {|c,i| c.uniq.size == MS}[1] + MS

