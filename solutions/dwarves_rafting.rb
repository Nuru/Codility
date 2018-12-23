# https://app.codility.com/programmers/lessons/91-tasks_from_indeed_prime_2016_challenge/dwarfs_rafting/
# Scored at https://app.codility.com/demo/results/training573SDQ-RYD/

# A Quad represents one quadrant of the raft
class Quad
  attr_reader :seats
  attr_accessor :fixed_dwarves
  attr_accessor :barrels

  def initialize(raft_length)
    @seats = (raft_length / 2) ** 2
    @fixed_dwarves = 0
    @barrels = 0
  end

  def max_dwarves
    @seats - @barrels
  end

  def min_dwarves
    @fixed_dwarves
  end

end

# An Axis represents 2 diagonally opposed quadrants of the raft. The 2 quadrants are required to balance.
class Axis
  def initialize(quad1, quad2)
    @quads=[quad1, quad2]
  end

  def available_seats
    return -1 if min_dwarves > max_dwarves
    (2 * max_dwarves) - (@quads[0].fixed_dwarves + @quads[1].fixed_dwarves)
  end

  private

  def max_dwarves # per quad
    [@quads[0].max_dwarves, @quads[1].max_dwarves].min
  end

  def min_dwarves # per quad
    [@quads[0].min_dwarves, @quads[1].min_dwarves].max
  end

end

# A Raft represents the whole raft: 2 Axes of 2 Quads each
class Raft
  attr_reader :axes

  def initialize(raft_length)
    raft_length
    @quads = []
    (0...4).each { |i| @quads[i] = Quad.new(raft_length) }
    @axes = [Axis.new(@quads[0], @quads[3]), Axis.new(@quads[1], @quads[2])]
    @row_split_after = raft_length / 2
    @col_split_after = ('A'.ord + @row_split_after - 1).chr
  end

  # Given a seat designation such as "1A", return the Quad the seat is in
  def quad_from_seat(seat)
    quad_idx = 0
    row = seat[0...-1].to_i
    quad_idx += 2 if row > @row_split_after
    col = seat[-1]
    quad_idx += 1 if col > @col_split_after
    @quads[quad_idx]
  end

  # Add a barrel at the given seat to the raft
  def add_barrel(seat)
    quad_from_seat(seat).barrels += 1
  end

  # Add a pre-boarded dwarf that cannot be moved to the given seat on the raft
  def add_fixed_dwarf(seat)
    quad_from_seat(seat).fixed_dwarves += 1
  end

  # The total number of seats available for new dwarves
  def available_seats
    return -1 if @axes.reduce(false) { |acc, ax| acc || ax.available_seats < 0 }

    @axes.reduce(0) { |sum, ax| sum + ax.available_seats }
  end
end

def solution(n, barrels, dwarves)
  raft = Raft.new(n)
  barrels.split(" ").each { |barrel| raft.add_barrel(barrel) }
  dwarves.split(" ").each { |dwarf| raft.add_fixed_dwarf(dwarf) }

  raft.available_seats
end