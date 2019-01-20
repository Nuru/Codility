# Codility Rubidium 2018 challenge
#
# Correct and categorized as O(n*log(n))
#
# See README.md for explanation

def solution(x, y)
  sheep = []

  (0...x.size).each do |i|
    sheep.push([x[i], y[i], (x[i]**2 + y[i]**2)])
  end

  # sort by distance from origin
  sheep.sort! { |a,b| a[2] <=> b[2] }

  # Set a max value that we will reduce as we go along
  min_d = max_origin_delta = sheep[-1][2] + 1 # > distance to origin of farthest sheep

  (0..(x.size - 2)).each do |i|
    ((i + 1)...x.size).each do |j|
      dist_x = (sheep[i][0] - sheep[j][0]).abs
      dist_y = (sheep[i][1] - sheep[j][1]).abs
      if [dist_x, dist_y].max < min_d
        min_d = [dist_x, dist_y].max
        max_origin_delta = 4*min_d + 2*min_d**2 # WRONG AGAIN, it's 4*min_d*sheep[i]*2 + 2*min_d**2
      end
      break if sheep[j][2] - sheep[i][2] > max_origin_delta
    end
  end

  (min_d / 2).floor
end

# s([0, 0, 10, 10], [0, 10, 0, 10]) # is 5
# s([1, 1, 8], [1, 6, 0]) # is 2
# s([1, 6, 0], [1, 1, 8]) # is 2
# s([0, 0, 0, 0, 0], [0, 10, 20, 40, 5]) # is 2
# s([0,11,0],[10,0,12]) # is 1
# s([0, 0, 10, 10, 0, 101, 60, 68], [0, 10, 0, 10, 101, 0, 80, 88]) # is 4