# https://app.codility.com/programmers/lessons/92-tasks_from_indeed_prime_2016_college_coders_challenge/array_recovery/
#
# Complexity O(n)
#
# Although the backtracking may make it look like this algorithm could be worst case O(n**2),
# in fact, every time we backtrack we discard any inputs we pass, so the maximum number of comparisons
# while backtracking is less than 2*n. Yes, we are using array shift/unshift, which is typically O(n), but
# Ruby's implementation is amortized O(1). https://cs.stackexchange.com/q/9380/

# Actually, since Ruby has infinite length integers, we do not need to be doing modulo calculus.
# In practice, though, the Bignums get too big and slow, and Codility times out if we compute the full values.
# We save even more time by avoiding doing any modulo division until the final output.
# Until then, we just keep multiplying the divisors into one ultimate denominator.
MODULUS = 1_000_000_007

def solution(a, global_max)
  a.push(-1) # Mark the end of the input and perform the final calculations
  backtrack = [-1] # Keep a sentinel at the end to avoid bounds checking
  repeat_length = 1
  out_val = a.shift
  # Keep track of the combinations as a fraction num(erator)/denom(inator) until the very end
  combos_num = combos_denom = 1
  max = global_max

  a.each do |curr|
    if curr == out_val
      repeat_length += 1
      next
    end
    # end of a repeat, calculate the repeat's possibilities and update history

    # The input cannot be bigger than the most recent larger number (or global_max if there is not one),
    # because if it were, then the output would have been that larger number.
    max = global_max
    while backtrack[0] > out_val
      max = backtrack.shift
    end
    # Save this value in the history
    backtrack.unshift(out_val) if backtrack[0] != out_val

    if curr > out_val
      # The only way curr > out_val is if the previous input (the last input of the out_val sequence) was curr,
      # so the last element of the sequence is not a choice, it is curr.
      repeat_length -= 1
      # It also means that curr is the minimum for this sequence, because if any input had been
      # less than curr, it would have been output when curr was input.
      min = curr
    else
      min = out_val + 1
    end
    combos_num, combos_denom = selection(1 + max - min, repeat_length, combos_num, combos_denom)

    # Set up for the next subsequence
    repeat_length = 1
    out_val = curr
  end
  (combos_num * mod_inverse(combos_denom)) % MODULUS
end

# The binomial formula is n!/r!(n-k)!. We actually need selections, not combinations,
# so we plug n+k-1 into the binomial formula in place of n.
# Also, k is allowed to be bigger than n, in which case Pascal's triangle says we can use n-1 instead of k.
def selection(n, k, mult_num = 1, mult_denom = 1)
  return [mult_num, mult_denom] if k < 1
  nr = n + k - 1
  k = n - 1 if k > n
  # Compute n!/(n-k)! the easy way. This is key to keeping the algorithm O(n), because it means at most 1 numerator
  # multiplication for each input, because k is the number of elements consumed by the main loop in this operation.
  num = ((1 + nr - k)..nr).reduce(1) { |p, i| (p * i)  % MODULUS }
  denom = (2..k).reduce(1) { |p, i| (p * i) % MODULUS }
  [(num * mult_num) % MODULUS, (denom * mult_denom) % MODULUS]
end

# Extended Euclidean algorithm to calculate 1/x mod n such that x * 1/x = 1 mod n
# From https://en.wikipedia.org/wiki/Extended_Euclidean_algorithm#Simple_algebraic_field_extensions
def mod_inverse(x,  n = MODULUS)
  t = 0
  newt = 1
  r = n
  newr = x.to_i
  while newr != 0
    q = r / newr
    t, newt = newt, t - q * newt
    r, newr = newr, r - q * newr
  end
  raise ZeroDivisionError if r > 1
  t += n if t < 0
  t
end


# solution([0, 0, 3], 5) # should be 6
# solution[0,0], 100000) # should be 49965

