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

# Given a tree in trees and an index, return true if that tree is visible from
# one of the four edges
def visible?(trees, tree, index)
  row_number = index / trees.column_count
  col_number = index % trees.column_count

  west, east = ends(trees.row(row_number), col_number)
  north, south = ends(trees.column(col_number), row_number)

  [east,west,south,north].any? {|dir| dir.all? {|other| other < tree}}
end

trees = Matrix[*$<.readlines.map {_1.chomp.split('').map(&:to_i)}]

p trees.each.with_index.count {|tree,index| visible?(trees, tree,index)}
