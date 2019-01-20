# PolygonConcavityIndex https://app.codility.com/programmers/lessons/99-future_training/polygon_concavity_index/
# Score 100%   https://app.codility.com/demo/results/training5D86R6-SBM/
# Detected complexity O(n) but it has a n*log(n) sort.
# The tricky part is closing the polygon correctly at the end.

class Point2D
  attr_accessor :x, :y
end

class Point2D
  attr_accessor :index
  def <=>(other)
    o = Point2D.orientation_with_root(self, other)
    o != 0 ? o : Point2D.compare_distance_from_root(self, other)
  end

  def to_s
    "(#{@x}, #{@y})"
  end

  def inspect
    "##{@index}=#{to_s}"
  end

  class << self
    attr_accessor :root

    # Determine the orientation of b to a with respect to the root.
    # > 0 is counterclockwise, < 0 clockwise, == 0 co-linear
    def orientation_with_root(a, b)
      orientation(root, a, b)
    end

    def orientation(a, b, c)
      (c.y - b.y)*(b.x - a.x) - (b.y - a.y)*(c.x - b.x)
    end

    def compare_distance_from_root(a, b)
      ((a.x - root.x)**2 + (a.y - root.y)**2) - ((b.x - root.x)**2 + (b.y - root.y)**2)
    end
  end
end

def solution(a)
  # Find the bottom point. In case of tie, find the rightmost, because we want to go clockwise.
  # We will c
  # all this point the root.
  root = a[0]
  a.each_with_index do |p, i|
    p.index = i
    next if p.y > root.y
    if p.y == root.y
      root = p if p.x > root.x
    else
      root = p
    end
  end

  Point2D.root = root
  a.sort! # Sort clockwise from root

  inner_point_index = -1 # No inner point found
  (0..(a.size - 3)).each do |i|
    next if Point2D.orientation(a[i], a[i+1], a[i+2]) <= 0
    inner_point_index = a[i+1].index
    # Special case: all the remaining points and the root are co-linear
    inline = Point2D.orientation(root, a[i+1], a[i+2]) == 0
    if inline
      ((i + 1)..(a.size - 3)).each do |j|
        inline &&= Point2D.orientation(root, a[j+1], a[j+2]) == 0
      end
      # so we should have checked against the farthest one rather than the nearest one
      inner_point_index = -1 if inline && Point2D.orientation(a[i-1], a[i], a[-1]) <= 0
    end
    break
  end

  inner_point_index
end


=begin

##################################### CUT HERE
#
#     puts "i=#{i}: #{a[i]}, #{a[i+1]}, #{a[i+2]} has orientation #{Point2D.orientation(a[i], a[i+1], a[i+2])}"

def test1 # Should return -1
  a = Array.new(5) { Point2D.new }
  a[0].x = -1;  a[0].y =  3
  a[1].x =  1;  a[1].y =  2
  a[2].x =  3;  a[2].y =  1
  a[3].x =  0;  a[3].y = -1
  a[4].x = -2;  a[4].y =  1
  solution(a)
end

def test2 # Should find 2 or 6
  a = Array.new(7) { Point2D.new }
  a[0].x = -1;  a[0].y =  3
  a[1].x =  1;  a[1].y =  2
  a[2].x =  1;  a[2].y =  1
  a[3].x =  3;  a[3].y =  1
  a[4].x =  0;  a[4].y = -1
  a[5].x = -2;  a[5].y =  1
  a[6].x = -1;  a[6].y =  2
  solution(a)
end

def test3 # Should not find anything
  a = Array.new(8) { Point2D.new }
  a[0].x = -1;  a[0].y =  3
  a[1].x =  1;  a[1].y =  2
  a[2].x =  1;  a[2].y =  -1
  a[3].x =  3;  a[3].y =  1
  a[4].x =  0;  a[4].y = -1
  a[5].x = -2;  a[5].y =  1
  a[6].x = -3;  a[6].y =  2
  a[7].x = -1;  a[7].y =  0
  solution(a)
end

def test4 # Test of final points co-linear, should return -1
  a = Array.new(7) { Point2D.new }
  a[0].x =  0;  a[0].y =  0
  a[1].x =  -1;  a[1].y =  0
  a[2].x =  -2;  a[2].y =  0
  a[3].x =  -3;  a[3].y =  0
  a[4].x =  0;  a[4].y =  5
  a[5].x =  0;  a[5].y =  3
  a[6].x =  0;  a[6].y =  1
  solution(a)
end
=end
