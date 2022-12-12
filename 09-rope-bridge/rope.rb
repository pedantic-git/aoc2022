#!/usr/bin/env ruby

class Rope
  attr_reader :head, :tail, :tail_visits

  def initialize
    @head = [0,0]
    @tail = [0,0]
    @tail_visits = [tail.dup]
  end

  def instruct!(instruction)
    dir, n = instruction.split
    n.to_i.times { move_head dir }
  end

  def inspect
    "Head %-8s Tail %-8s" % [head, tail]
  end

  def n_tail_visits
    tail_visits.uniq.count
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
  end

  # Note: x <=> 0 returns -1 for negative numbers and 1 for positive numbers
  def move_tail
    case head_distance
    in [0, v] if v.abs > 1
      tail[1] += v <=> 0
    in [h, 0] if h.abs > 1
      tail[0] += h <=> 0
    in [h, v] if h.abs > 1 || v.abs > 1
      tail[0] += h <=> 0
      tail[1] += v <=> 0
    else
      # Tail is close enough - don't move it
    end
    tail_visits.push tail.dup
  end

  def head_distance
    [head[0]-tail[0], head[1]-tail[1]]
  end

end

Rope.new.then do |rope|
  while inst = $<.gets
    rope.instruct!(inst)
  end
  puts "Tail visited: #{rope.n_tail_visits} locations"
end
