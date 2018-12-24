# https://app.codility.com/programmers/lessons/90-tasks_from_indeed_prime_2015_challenge/longest_password/
#

def solution(s)
  candiates = s.split(" ")
  longest = -1
  candiates.each do |c|
    next if c.size <= longest
    next if c.gsub(/[^a-zA-Z0-9]/,'').size != c.size
    next if c.gsub(/[^a-zA-Z]/,'').size.odd?
    next if c.gsub(/[^0-9]/,'').size.even?
    longest = c.size
  end
  longest
end

#  solution("test 5 a0A pass007 ?xy1") # should be 7
#  solution("") # should be -1