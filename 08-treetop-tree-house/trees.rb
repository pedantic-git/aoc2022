#!/usr/bin/ruby

require 'matrix'

# Given an enumerable and an index, returns all the elements to the left of i and
# all the elements to the right of i but not i itself
def ends(e, i)
  right = e.to_a
  left = right.slice!(0, i)
  right.shift
  [left, right]
end

# Given a tree in trees and an index, return the trees visible in each of the four
# directions, in the order north, east, south, west
def directions(trees, tree, index)
  row_number = index / trees.column_count
  col_number = index % trees.column_count

  west, east = ends(trees.row(row_number), col_number)
  north, south = ends(trees.column(col_number), row_number)

  [north, east, south, west]
end

# Given a tree in trees and an index, return true if that tree is visible from
# one of the four edges
def visible?(trees, tree, index)
  directions(trees, tree, index).any? {|dir| dir.all? {|other| other < tree}}
end

# Given a tree in trees and an index, work out the scenic score
def score(trees, tree, index)
  dirs = directions(trees,tree,index)
  # North and west are counting in the opposite direction (towards the tree)
  # so reverse them
  dirs[0].reverse! ; dirs[3].reverse!
  dirs.map {|dir| until_block(dir, tree).length}.reduce(:*)
end

# Just the elements of this array that can be seen (up to the first one that is)
# >= to tree
def until_block(arr, tree)
  arr.slice_after {|other| other>=tree}.first || []
end

trees = Matrix[*$<.readlines.map {_1.chomp.split('').map(&:to_i)}]

puts "Number of visible trees: #{trees.each.with_index.count {|tree,index| visible?(trees, tree,index)}}"
puts "Largest scenic score: #{trees.each.with_index.map {|tree,index| score(trees, tree, index)}.max}"
