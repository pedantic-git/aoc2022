#!/usr/bin/env ruby

# Get the range objects for the given assignment string (like "2-4,6-8")
def ranges(assignment)
  /\A(\d+)-(\d+),(\d+)-(\d+)\Z/ =~ assignment
  return $1.to_i..$2.to_i, $3.to_i..$4.to_i
end

# Given an assignment will return true if one of the ranges fully contains the other range
def total_overlap?(assignment)
  r1, r2 = ranges(assignment)
  r1.cover?(r2) || r2.cover?(r1)
end

# The same but if there's any overlap at all
def some_overlap?(assignment)
  r1, r2 = ranges(assignment)
  # Range x and y *don't* overlap if they are sorted (x.begin < y.begin)
  # and the ends don't meet in the middle (x.end < y.begin)
  !(
    (r1.begin < r2.begin && r1.end < r2.begin) || 
    (r2.begin < r1.begin && r2.end < r1.begin)
  )
end

assignments = $<.readlines

p assignments.count(&method(:total_overlap?))
p assignments.count(&method(:some_overlap?))