
# https://app.codility.com/programmers/lessons/92-tasks_from_indeed_prime_2016_college_coders_challenge/diamonds_count/
# O(N**2), 100% https://app.codility.com/demo/results/training9X6Q72-B5C/


def solution(x, y)
  px = [] # all points, eventually sorted by x coord then y coord
  hy = Hash.new {|h, k| h[k] = []} # hy[y_coord] has sorted array of points with y = y_coord

  (0...x.size).each do |i|
    px[i] = [x[i], y[i]]
    hy[y[i]].push(px[i])
  end
  px.sort!
  hy.each_value {|v| v.sort!}

  count = 0
  (0..(px.size - 2)).each do |i| # for each point
    x_axis = px[i][0] # extract the x-axis for this point
    ((i+1)...px.size).each do |j| # loop over the remaining points...
      break if px[j][0] != x_axis # ...on the same x-axis
      y_dist = px[j][1] - px[i][1]
      throw [i, j] if y_dist <= 0
      next if (y_dist % 2) != 0   # skip unless the midpoint between the 2 points has an integer y coordinate
      mid_y = px[i][1] + (y_dist / 2)

      py = hy[mid_y] # all points with y = mid_y
      (0...py.size).each do |k|
        x_dist = x_axis - py[k][0]
        break if x_dist <= 0        # We only need to look on one side of the x-axis, so we are done when we hit or pass it
        target_x = x_axis + x_dist  # Look for a mirror point on the other side of the x-axis
        candidate_idx = ((k + 1)...py.size).bsearch {|n| py[n][0] >= target_x} # index of point with smallest y-coord >= target_x
        count += 1 if candidate_idx && (py[candidate_idx][0] == target_x) # We have a diamond if we found a point at (mid_y,target_x)
      end

    end

  end

  count
end

# solution([1, 1, 2, 2, 2, 3, 3],[3, 4, 1, 3, 5, 3, 4]) # is 2
# solution([1, 2, 3, 3, 2, 1],[1, 1, 1, 2, 2, 2]) # is 0