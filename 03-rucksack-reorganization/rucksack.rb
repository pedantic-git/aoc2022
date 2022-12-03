#!/usr/bin/env ruby

# Break the string into two arrays of items, representing the two equal-sized
# compartments
def rucksack(str)
  str.chomp.split('').then { _1.each_slice(_1.size / 2)}.to_a
end

# Find the common element in a given rucksack's two compartments and return its priority
def common(rucksack)
  priority(rucksack.reduce(:&).first)
end

# Get the priority for a given item
def priority(item)
  (item.ord - 96) % 58 # 58 is the number of positions back in ASCII that A appears before z
end

p $<.readlines.sum {|str| common(rucksack str)}
