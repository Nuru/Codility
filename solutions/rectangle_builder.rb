# https://app.codility.com/programmers/lessons/91-tasks_from_indeed_prime_2016_challenge/rectangle_builder_greater_area/
# O(N*log(N))  https://app.codility.com/demo/results/trainingJQFR65-NKA/

def solution(pieces, area)
  limit = 1e9.ceil
  long_enough = Math.sqrt(area).ceil # Any pair of long_enough sides encloses enough area
  sides = Hash.new(0)
  rects = 0
  # Count the number of pieces of each length
  pieces.each do |i|
    sides[i] += 1
    rects += 1 if i >= long_enough && sides[i] == 4 # Handle squares specially. All other code requires sides of different length.
  end


  sides.reject! { |k,v| v < 2 } # throw out pieces where we do not have 2 of that length
  sides = sides.keys.sort # sides is now a sorted array of valid side lengths for rectangles we can build with the available pieces

  small_idx = 0
  high_idx = sides.size
  # iterate over the sides from smallest to long_enough
  while small_idx < sides.size && (small_side = sides[small_idx]) < long_enough
    low_idx = small_idx + 1
    # find the smallest side that makes a big enough rectangle when paired with the current side
    match_idx = (low_idx...high_idx).bsearch { |i| sides[i] * small_side >= area } || sides.size
    rects += sides.size - match_idx # We can make rectangles with the side we found and all the sides longer than it
    return -1 if rects > limit
    small_idx += 1
    high_idx = match_idx + 1 if match_idx < sides.size # going forward, we don't need to look for a side bigger than the one we just found
  end


  if small_idx < sides.size
    # the remaining sides are all long enough to pair with any of the other remaining sides
    big_sides = sides.size - small_idx
    rects += (big_sides * (big_sides - 1)) /2 # Combination of big_sides things taken 2 at a time
  end

  rects > limit ? -1 : rects
end
