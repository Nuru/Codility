# Codility Rubidium 2018 challenge https://app.codility.com/programmers/challenges/rubidium2018/
#
# This was the first solution I submitted.
# This won the Golden award (100% correctness & 100% performance) despite the fact that it is flawed.
#
# The solution to the problem is defined by the 2 sheep with the smallest max(delta_x, delta_y).
# This algorithm sorts the sheep by distance from the origin point and assumes that the 2 sheep that define
# the solution will be adjacent in that sorted list. That is not a bad heuristic, but it is not guaranteed.
# This particular solution fails on s([0,11,0],[10,0,12]) because the closest sheep are at (0,10) and (0,12),
# but the sheep at (11,0) comes between them in the sorted list.
#
# On the plus side, it is O(n*log(n)) and works often enough that none of Codility's tests found a mistake.
# (Further evidence that testing is not an adequate measure of correctness, which fuels my beef with TDD.)
#
# The other implmentations in this folder are correct.
#

def solution(x, y)
  sheep = []

  (0...x.size).each do |i|
    sheep.push([x[i], y[i]])
  end

  min_d = 123456 # larger then max position
  sheep.sort! { |x,y| (x[0]**2 + x[1]**2) <=> (y[0]**2 + y[1]**2) }
  (0..(x.size - 2)).each do |i|
    dist = (sheep[i+1][0] - sheep[i][0]).abs
    next if dist > min_d
    offset =(sheep[i+1][1] - sheep[i][1]).abs
    min_d = [min_d, [dist, offset].max].min
  end

  (min_d / 2).floor
end

# solution([0, 0, 10, 10], [0, 10, 0, 10]) # is 5
# solution([1, 1, 8], [1, 6, 0]) # is 2
# solution([1, 6, 0], [1, 1, 8]) # is 2
# solution([0, 0, 0, 0, 0], [0, 10, 20, 40, 5]) # is 2
# solution([0,11,0],[10,0,12]) # is 1