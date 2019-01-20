# Codility Rubidium 2018 challenge https://app.codility.com/programmers/challenges/rubidium2018/
#
# Correct and categorized as O(n*log(n))
#
# We sort the sheep according to their distance from the origin.
#
# As we go along, we keep track of the max shade size allowed by the sheep we have looked at.
#
# For each sheep, we consider the sheep fuather from the origin until we get to a sheep
# that is so far from the origin that no matter what its x and y coordinates are, it is too far
# for its shade to overlap the current sheep's at the current maximum size.
# (There is a little geometry involved, but pretty much only the Pythagorean theorem is needed to
# demonstrate that the formula used is correct.)
# I guess you could fix this by making a second pass through the list. The first pass (what is currently implemented)
# sets an upper bound on the distance between the closest sheep. Call that dq. The second pass goes through the
# list again, but checks each sheep against sheep after the adjacent sheep until it has gets to a sheep that is
# at least 2*(dq**2) away from it. But that seems overly complicated and technically Ω(n**2). Still, it might be
# the best set of trade-offs if this were a real-world problem seeking real-world efficiency.
#

def solution(x, y)
  sheep = []

  (0...x.size).each do |i|
    sheep.push([x[i], y[i]])
  end

  min_d = 123456 # larger then max position
  # sort by distance from origin
  sheep.sort! { |x,y| (x[0]**2 + x[1]**2) <=> (y[0]**2 + y[1]**2) }
  (0..(x.size - 2)).each do |i|
    ((i + 1)...x.size).each do |j|
      dist_x = (sheep[i][0] - sheep[j][0]).abs
      dist_y = (sheep[i][1] - sheep[j][1]).abs
      min_d = [min_d, [dist_x, dist_y].max].min
      break if dist_x**2 + dist_y**2 > min_d**2
    end
  end

  (min_d / 2).floor
end

# s([0, 0, 10, 10], [0, 10, 0, 10]) # is 5
# s([1, 1, 8], [1, 6, 0]) # is 2
# s([1, 6, 0], [1, 1, 8]) # is 2
# s([0, 0, 0, 0, 0], [0, 10, 20, 40, 5]) # is 2
# s([0, 0, 0, 0], [0, 10, 20, 40]) # is
# s([0,11,0],[10,0,12]) # is 1