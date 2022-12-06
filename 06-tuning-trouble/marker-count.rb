#!/usr/bin/env ruby

# Not very efficient, but concise, way of finding the marker
p $<.read.split('').each_cons(4).with_index.find {|c,i| c.uniq.size == 4}[1] + 4

