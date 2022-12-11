#!/usr/bin/env ruby

class Rope
  attr_reader :head, :tail

  def initialize
    @head = [0,0]
    @tail = [0,0]
  end

  def instruct!(instruction)
    dir, n = instruction.split
    n.to_i.times { move_head dir }
  end

  def inspect
    "Head %-8s Tail %-8s" % [head, tail]
  end

  private

  def move_head(dir)
    case dir
    when 'U'
      head[1] -= 1
    when 'D'
      head[1] += 1
    when 'L'
      head[0] -= 1
    when 'R'
      head[0] += 1
    end
    move_tail
    p self
  end

  def move_tail
  end

end

Rope.new.then do |rope|
  while inst = $<.gets
    rope.instruct!(inst)
  end
end