# https://app.codility.com/programmers/lessons/91-tasks_from_indeed_prime_2016_challenge/tree_product/
# Perfect score, O(n log n)  https://app.codility.com/demo/results/trainingT8ASPQ-2K5/

# Solving this challenge with an algorithm that works in O(n**2) was not that big of a challenge, so I didn't bother.
# Figuring out the optimal trisection of a graph in O(n log n) time was very, very challenging.
#


# Mapping the language of the problem to common tree graph terminology:
# "Posts" -> nodes,  "bridges" -> edges, "area" -> a component, "Destroying a bridge" -> cutting an edge.
# Note: nodes are usually called vertices (singular: vertex) in the larger context of mathematical graph theory.

# Edges is a hash of integers that index into the global tree array. Hash for quick insert and delete.
# We delete the edges when we connect the associated node. Children and Parent are actual nodes.

class Assert < StandardError; end
class Node

  attr_reader :id, :edges, :children, :parent, :weight

  def initialize(my_id)
    @id = my_id     # Not strictly necessary, but handy for debugging
    @edges = {}     # IDs of other nodes we are connected to
    @children = []  # References to our children so we can navigate the tree top-to-bottom. Empty for leaves.
    @parent = nil   # A reference to our parent so we can navigate the tree bottom-to-top. Nil for the root.
    @weight = 1     # The number of nodes in the component the node is left in after cutting the parent edge
    @heavy_child = nil # The child with the largest weight
  end

  # For processing the input. Registers an ID of a node we are connected to.
  def add_edge(node_id)
    @edges[node_id] = true
  end

  # For building the tree. Attaches a subtree to this node.
  # Every path from the subtree to any other node goes through self.
  def add_subtree(node)
    raise Assert.new("Adding unrecognized child #{node.id} to node #{@id}") unless @edges.delete(node.id)
    @heavy_child = nil
    children.push(node)
    @weight += node.weight
  end

  # For building the tree. Attaches self to our parent. The only path to our children is through self.
  def set_parent(node)
    raise Assert.new("Setting parent #{node.id} not in edges") unless @edges.delete(node.id)
    @parent = node
  end

  # Find the child with the largest weight.
  # This is used so rarely and in such specific situations that general search optimizations actually slow it down.
  def heavy_child
    return @heavy_child unless @heavy_child.nil?
    @heavy_child = @children.first
    @children.each { |c| @heavy_child = c if c.weight > @heavy_child.weight }
    @heavy_child
  end

  # Execute the block on the tree in depth-first, pre-order
  def self.pre_order(root, &block)
    yield root
    root.children.each {|c| self.pre_order(c, &block)}
  end

  # Execute the block on the tree in depth-first, post-order
  def self.post_order(root, &block)
    root.children.each {|c| self.post_order(c, &block)}
    yield root
  end


  # Given an array of nodes that have their edges set, build the tree in a way that guarantees
  # no child of the root has weight > tree_size / 2. This is very important to the rest of the algorithm.
  # Requires that node_array[i].id == i.
  def self.build_tree(node_array)
    min_root_weight = (node_array.size / 2) + 1 # If we find a node this size, make it the root

    q = []
    # queue up the leaves
    node_array.each { |node| q.push(node) if node.edges.size == 1 }
    # build from the bottom up, until we find the root
    while q.size > 1
      v = q.shift # v for vertex, because I do not want to use n
      raise Assert.new("node #{v.id} processed as leaf but has #{v.edges.size} edges left") unless v.edges.size == 1 || v.weight >= min_root_weight

      # This is a little tricky. We want to make sure that no child of the root has weight > n /2
      # Since every non-leaf node can be either child or parent to its neighbor, we can force
      # this by refusing to add parents to any node that is too heavy, and instead wait for
      # the parents to come around and add themselves as children. Because the only way for a tree
      # to have 2 nodes that have weight > n/2 is for one to be a child of the other, we can
      # be sure that if we never attach an overweight node as a child, the tree will only have
      # one such node.
      if v.weight < min_root_weight
        parent = node_array[v.edges.keys.first]
        v.set_parent(parent)
        parent.add_subtree(v)
        q.push(parent) if parent.edges.size == 1
      else
        # It often happens that the center of the tree is the best root, in which case it comes out of this loop last.
        # To preserve that behavior and ensure we process all the children when we find the root
        # early, we just push it onto the end of the queue again.
        q.push(v)
      end
    end
    # Last one left is root
    root = q.shift

    raise Assert.new("Nominated #{root.id} as root but it has #{root.edges.size} edges left") unless root.edges.size == 0
    raise Assert.new("Nominated #{root.id} as root but it has #{root.weight} weight") unless root.weight == node_array.size
    raise Assert.new("Root has child with weight > n/2 {node_array.size / 2}:\n   #{root.inspect}") if root.heavy_child.weight >= min_root_weight

    root
  end

  # Helper functions for development, not strictly necessary for the solution
  def to_s
    "\##{@id}"
  end

  def inspect
    str = "\##{@id}=#{@weight}"
    unless children.empty?
      str += "\n    |\n  " + @children.reduce("") { |s, c| s += "  \##{c.id}=#{c.weight}" }
    end
    str
  end
end


# The main program
def s(a, b)
  raise Assert "Bad input" unless a.size == b.size

  root = nil
  tree = Array.new(a.size + 1) # tree stores n+1 nodes (guard posts)
  # We can save ourselves some hassle and rely on stronger assumptions if we eliminate the special cases early
  return tree.size unless tree.size > 4

  (0...tree.size).each { |i| tree[i] = Node.new(i) }

  # Add edges to nodes. The first step of building the tree.
  (0...a.size).each do |i|
    tree.fetch(a[i]).add_edge(b[i])
    tree.fetch(b[i]).add_edge(a[i])
  end

  root = Node.build_tree(tree)
  best_bisection = root.heavy_child.weight
  best_bisection_result = best_bisection * (tree.size - best_bisection)

  # Start working on finding the best trisection

  # Find the heaviest branch of the tree. We want to process it separately because it is special.
  heavy_subtree = root.heavy_child

  # Build cut lists
  # In the end, we want a sorted array with unique values, and Array.uniq is going to put the array in a hash
  # anyway, so we might as well just build the hash up front.
  heavy_cuts = {1 => true} # a list of possible subtree sizes resulting from a single cut on the heavy branch
  other_cuts = {1 => true} # list of possible subtree sizes resulting from a single cut anywhere but the heavy branch.

  root.children.each do |s|
    next if s.weight == 1
    if s == heavy_subtree
      Node.post_order(s) { |c| heavy_cuts[c.weight] = true }
    else
      Node.post_order(s) { |c| other_cuts[c.weight] = true }
    end
  end


  # convert to sorted arrays so we can do binary searches on them
  # This and future searches we do is what makes the whole algorithm O(n log n) instead of O(n)
  heavy_cuts = Cutlist.new(heavy_cuts.keys.sort)
  other_cuts = Cutlist.new(other_cuts.keys.sort)

  #   *Here is the magic*
  #
  # We have arranged the tree such that
  # 1) the maximum possible weight of the heavy subtree is n > 2, and
  # 2) no other subtree is heavier than the heavy subtree
  #
  # Condition 1 means that the only possible way the best trisection would involve 2 cuts on the heavy branch
  # is if the best possible trisection is the best bisection of the heavy branch separated from the rest of the tree.
  #
  # Condition 2 means that we can never find a better trisection without cutting on the heavy branch than
  # we can find by cutting the heavy branch at the root and bisecting the rest of the tree. Along with condition 1,
  # this means the second cut will not be on the heavy branch, so we only need to check cuts on the remaining branches.
  #

  # Check condition 1
  heavy_bisection = heavy_cuts.closest_to(heavy_subtree.weight / 2.0)
  best_trisection_result = heavy_bisection * (heavy_subtree.weight - heavy_bisection) * (tree.size - heavy_subtree.weight)

  # Check condition 2
  # We test cuts of the heavy branch against the best bisection of the rest of the tree until the subtree of h is too small.
  heavy_cuts.reverse!
  heavy_cuts.each do |h|
    other_bisection = other_cuts.closest_to((tree.size - h) / 2.0)
    other_trisection_result = h * other_bisection * (tree.size - (h + other_bisection))
    best_trisection_result = other_trisection_result if best_trisection_result < other_trisection_result
    # If the subtree under h is smaller than the other 2 components, it will not help to make it even smaller
    break if h < other_bisection && h < (tree.size - (h + other_bisection))
  end

  [tree.size, best_bisection_result, best_trisection_result].max
end

class Cutlist < Array
  # Find the element in the self closest to target value x.
  # REQUIRES the array to be sorted smallest to largest, and contain at least 1 value.
  # O(log n) where n is size of ary
  def closest_to(x)
    raise ArgumentError.new if size == 0 or x < 0
    # First, find the smallest value in ary >= x
    i = (0...size).bsearch { |i| self[i] >= x }
    return self[-1] if i.nil?
    return self[i] if i == 0 || self[i] == x
    # Finally, check if the next lower value is closer to x, and return the best value
    raise ArgumentError.new("Array not sorted smallest to largest") unless self.fetch(i-1) < self.fetch(i)
    (x - self[i]).abs < (x - self[i-1]).abs ? self[i] : self[i-1]
  end
end

#
#   A[0] = 0    B[0] = 1
#   A[1] = 1    B[1] = 2
#   A[2] = 1    B[2] = 3
#   A[3] = 3    B[3] = 4
#   A[4] = 3    B[4] = 5
#   A[5] = 6    B[5] = 3
#   A[6] = 7    B[6] = 5

# ([0,1,1,3,3,6,7], [1,2,3,4,5,3,5])
# ([0, 1, 1, 3, 3, 6, 7], [1, 2, 3, 4, 5, 3, 5]) # 18
#
# ([0, 1], [1, 2]) # 3
#
# 1 heavy node, 1 path branch that has to be bisected.
# ([0, 1, 2, 3, 4, 5, 0, 0, 0, 0, 0], [6, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]) # 54
# ([0, 0, 0, 0, 0, 5, 4, 3, 2, 1, 0], [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 6]) # 54
#
# s([0, 1, 2, 3, 4, 5, 0, 0, 0, 0, 0, 0], [6, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]) # 63
#

def solution(a, b)
  s(a, b).to_s # Codility requires the result to be a string
end
