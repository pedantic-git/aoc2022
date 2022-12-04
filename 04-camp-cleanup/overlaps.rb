#!/usr/bin/env ruby

# Given an assignment like "2-4,6-8" - will return true if one of the ranges
# fully contains the other range
def overlap?(assignment)
  /\A(\d+)-(\d+),(\d+)-(\d+)\Z/ =~ assignment
  r1, r2 = $1.to_i..$2.to_i, $3.to_i..$4.to_i
  r1.cover?(r2) || r2.cover?(r1)
end

p $<.readlines.count(&method(:overlap?))
