# https://app.codility.com/programmers/lessons/90-tasks_from_indeed_prime_2015_challenge/slalom_skiing/
#

# I did not solve this without help. I learned from other people that this problem could be mapped
# to a classic CS problem of Longest Increasing Subsequence by mirroring the slope to account for
# the change in direction. The solution to Longest Increasing Subsequence is adapted from Wikipedia.
# I had never heard of "Longest Increasing Subsequence" before and certainly would not have come up
# with this efficient of a solution on my own in under 2 hours as the challenge demanded.
#
# Passing gates going left is the same as finding an increasing sequence of distances from the right.
# If we could only go left, the solution would be the Longest Increasing Subsequence of gates.
# However, they have thrown in a complication, which is that we can change direction. Well, we still want to
# find the Largest Increasing Subsequence, because that is what we know how to do, so we wan to set it up that
# once we change direction, we can continue to increase the subsequence. We do that by creating a mirror image,
# so that while we were previously going right and decreasing the value, we now are going mirror-right which is
# left again and increasing the value.
#
# But we still have to be careful. Once we have turned, and are now on our mirror-image slope, we cannot
# go back to the original slope. Because we are looking for an ever-increasing subsequence, we can ensure
# this by making sure that our mirror-image slope, which has larger values than the original slope, always
# comes before the original slope.
#
# We can turn left again, which by now is sort of an induction. We create a mirror image of the mirror image,
# which is the orignal image, offset it ot be greater magnitude that the first mirror image, and make sure
# that its gates come before the mirror images gates.
#
def solution(a)
  # We have to be careful to put the pseudo gates in the right order, otherwise we could ski past the
  # finish line and continue to ski on the mirror image gates. To ensure that once we turn, we cannot
  # access any of the gates on the slope image prior to the turn, we have to put the pseudo gates
  # in the sequence in order from farthest to nearest.
  offset = a.max * 2 + 2 # we want to make sure that no points on the offset maps overlaps points on the other maps
  gates = []
  a.each do |g|
    gates.push(offset + g)  # the second set of gates, after the second turn, going left again
    gates.push(offset - g)
    gates.push(g)
  end
  # Now all we have to do is find the length of the longest increasing subsequence of gates
  # m[i] holds the last value in the best sequence of length i
  # I don't know why it's called "m", maybe for "memoize", but that's what it is called in the
  # literature I'm stealing from, so I'll use it.

  max_length = 1
  m = [-1, gates.shift]
  gates.each do |g|
    # Find the longest sequence to add this gate to.
    # Built in bsearch finds the minimum value greater than, so actually it returns the shortest sequence
    # we cannot add this gate to, which is fine. By adding this gate to the sequence one shorter, we
    # create a new, better sequence of this length.
    too_long_idx = (1..max_length).bsearch { |i| m[i] > g }
    unless too_long_idx
      max_length += 1
      m[max_length] = g
    else
      m[too_long_idx] = g
    end
  end
  max_length
end

# solution([15, 13, 5, 7, 4, 10, 12, 8, 2, 11, 6, 9, 3]) # should be 8
# solution([1,5]) # should be 2