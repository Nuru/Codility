# Codility Rubidium 2018 challenge
#
# Silver award because it's O(n**2)
#
# This is not the fastest, but it is the easiest to code and easiest to demonstrate correctness.

def solution(x, y)
  sheep = []

  (0...x.size).each do |i|
    sheep.push([x[i], y[i]])
  end

  min_d = 123456 # larger then max position
  (0..(x.size - 2)).each do |i|
    ((i + 1)...x.size).each do |j|
      dist_x = (sheep[i][0] - sheep[j][0]).abs
      dist_y = (sheep[i][1] - sheep[j][1]).abs
      min_d = [min_d, [dist_x, dist_y].max].min
    end
  end

  (min_d / 2).floor
end

# solution([0, 0, 10, 10], [0, 10, 0, 10]) # is 5
# solution([1, 1, 8], [1, 6, 0]) # is 2
# solution([1, 6, 0], [1, 1, 8]) # is 2
# solution([0, 0, 0, 0, 0], [0, 10, 20, 40, 5]) # is 2
# solution([0,11,0],[10,0,12]) # is 1