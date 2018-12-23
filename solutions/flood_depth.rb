# https://app.codility.com/programmers/lessons/90-tasks_from_indeed_prime_2015_challenge/flood_depth/
# Scored O(N) at https://app.codility.com/demo/results/trainingX8A6ZX-7SH/

def solution(a)
  left_peak = 0
  prev_height = 0
  nadir = 0
  max_depth = 0

  a.each do |height|
    if height > prev_height # rising landscape, check for pool behind
      if height >= left_peak # start of new pool, calculate depth of finished pool and reset
        depth = left_peak - nadir
        max_depth = depth if depth > max_depth
        left_peak = height
        nadir = height
      else # lower limit on depth
        depth = height - nadir
        max_depth = depth if depth > max_depth
      end
    else # falling (or level) landscape, check for new nadir
      nadir = height if height < nadir
    end
    prev_height = height
  end

  max_depth
end

# solution([1,3,2,1,2,1,5,3,3,4,2]) is 2
# solution([1,3,1,2,1,2,1,5,3,3,4,2]) is 2
# solution([1,3,2,1,2,1,5,3,3,4,2,5]) is 3
# solution([5,8]) is 0
# solution([1,3,2,1,2,1]) is 1