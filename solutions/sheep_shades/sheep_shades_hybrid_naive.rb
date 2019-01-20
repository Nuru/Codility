# Codility Rubidium 2018 challenge
#
# This was categorized as (n*log(n)) but only got a silver award
# It timed out when a large number of points were arranged on a single line

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
      break if [dist_x, dist_y].min > min_d
    end
  end

  (min_d / 2).floor
end

# s([0, 0, 10, 10], [0, 10, 0, 10]) # is 5
# s([1, 1, 8], [1, 6, 0]) # is 2
# s([1, 6, 0], [1, 1, 8]) # is 2
# s([0, 0, 0, 0, 0], [0, 10, 20, 40, 5]) # is 2
# s([0,11,0],[10,0,12]) # is 1