#!/usr/bin/env ruby

# Given a drawing of crates, create a hash of stacks
def stacks(drawing)
  lines = drawing.reverse
  {}.tap do |s|
    # vivify the hash based on the first line (crate indexes)
    # this code assumes they are in numerical order 1-indexed, but is easily changed
    # to any arbitrary set of keys by remembering the order
    lines.shift.scan(/\d/).each { s[_1.to_i] = [] }
    # Now push each crate onto the newly generated stack, line by line
    lines.each do |line|
      # \s could be a space or the \n at the end
      line.scan(/...\s/).each.with_index do |crate, i|
        s[i+1] << $1 if /(\w)/ =~ crate
      end
    end
  end
end

drawing, instructions = $<.readlines.chunk {/\S/ =~ _1 ? :text : :_separator}.map(&:last)
s = stacks(drawing)

instructions.each do
  /move (\d+) from (\d) to (\d)/ =~ _1
  s[$3.to_i].push(*s[$2.to_i].pop($1.to_i).reverse)
end

# And the top crate of each stack is...
puts s.map {_2.last}.join
