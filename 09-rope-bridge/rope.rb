#!/usr/bin/env ruby

N_KNOTS = 2 # Change to 10 for part 2

class Rope
  attr_reader :knots, :tail_visits

  def initialize(n)
    @knots = Array.new(n) { [0,0] }
    @tail_visits = []
    record_tail_position
  end

  def instruct!(instruction)
    dir, n = instruction.split
    n.to_i.times { move_head dir }
  end

  def inspect
    knots.inspect
  end

  def n_tail_visits
    tail_visits.uniq.count
  end

  private

  def move_head(dir)
    case dir
    when 'U'
      knots.first[1] -= 1
    when 'D'
      knots.first[1] += 1
    when 'L'
      knots.first[0] -= 1
    when 'R'
      knots.first[0] += 1
    end

    1.upto(knots.length - 1) do |i|
      move_knot(i)
    end
  end

  # Note: x <=> 0 returns -1 for negative numbers and 1 for positive numbers
  def move_knot(i)
    case distance_to_previous(i)
    in [0, v] if v.abs > 1
      knots[i][1] += v <=> 0
    in [h, 0] if h.abs > 1
      knots[i][0] += h <=> 0
    in [h, v] if h.abs > 1 || v.abs > 1
      knots[i][0] += h <=> 0
      knots[i][1] += v <=> 0
    else
      # Tail is close enough - don't move it
    end
    record_tail_position
  end

  def distance_to_previous(i)
    [
      knots[i-1][0] - knots[i][0], 
      knots[i-1][1] - knots[i][1]
    ]
  end

  def record_tail_position
    tail_visits << knots[-1].dup
  end

end


Rope.new(N_KNOTS).then do |rope|
  while inst = $<.gets
    rope.instruct!(inst)
  end
  puts "Tail visited: #{rope.n_tail_visits} locations"
end
