# https://app.codility.com/programmers/lessons/92-tasks_from_indeed_prime_2016_college_coders_challenge/socks_laundering/
#

# A greedy algorithm should work fine here, because the units are all the same size.
# * First we count all the clean pairs we have
# * Next we find single clean socks that we can pair with single dirty socks, because this adds a pair of
#   clean socks to our supply but only costs us 1 unit of capacity in the washing machine
# * Finally we look for pairs of dirty socks until we fill the washing machine
#

def solution(k, c, d)
  capacity = k
  # bin clean and dirty socks by color, so we can match single clean socks with single dirty socks
  clean = Hash.new(0) # set value of uninitialized key to zero
  dirty = Hash.new(0)
  c.each { |s| clean[s] += 1 }
  d.each { |s| dirty[s] += 1 }

  pairs = 0

  # If we cared about performance, there is a lot we can do to optimize the following code, but since we do not,
  # I will emphasize clarity and correctness.

  # Pack the pairs of clean socks
  clean.each do |color, quantity|
    pairs += (quantity / 2).floor  # integer division does an implicit "floor", so we could get away with just "quantity / 2"
    clean[color] = quantity % 2
  end

  return pairs if capacity == 0 # If we cannot do wash, we can only take the clean pairs we have

  clean.reject! { |k, v| v == 0 } # throw out the empty bins

  # All that is left in clean are color bins with one sock in them. Pair them with dirty socks if possible
  clean.each_key do |color|
    next unless dirty[color] > 0
    # put a single dirty sock in the laundry, adjust the remaining capacity of the washing machine
    dirty[color] -= 1
    pairs += 1
    capacity -= 1
    return pairs if capacity == 0
    # We could remove the clean sock from its bin here, but we are never going to look at it again, so let us not bother
  end

  # All that is left is to wash dirty pairs of socks. The math could be slightly annoying because
  # pairs are 2 socks while the washing machine capacity is in single socks, so let us convert
  # the remaining capacity of the washing machine to pairs. It doesn't solve everything, but it's a bit of a help.
  cap_pairs = (capacity / 2).floor
  return pairs if cap_pairs == 0
  dirty.each_value do |v|
    to_wash = [(v / 2).floor, cap_pairs].min # be careful not to overload the washing machine
    pairs += to_wash
    cap_pairs -= to_wash
    return pairs if cap_pairs == 0
  end

  # We could wash more socks, but we don't have any more that make a pair.
  pairs
end


# solution(2,[1, 2, 1, 1],[1, 4, 3, 2, 4]) # should be 3
# solution(0, [1, 2, 3, 4], [3, 2, 1, 5]) # should be zero