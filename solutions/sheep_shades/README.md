These are various solutions to the Codility Rubidium 2018 challenge, a.k.a. SheepShades

Interestingly, the [first solution](sheep_shades_radial.rb)
I submitted won a Golden Award, 
despite being demonstrably flawed. Codility's testing did not catch
the error in the code, which is yet another example of code testing
being inadequate to assure program correctness, which is why I
don't like Test Driven Design.

I wrote the [second solution](sheep_shades_simple.rb)
I submitted, the simplest, 
because I could demonstrate that it was correct, and I
suspected my first solution was not. I
wanted to have something to compare my first solution to,
and this did, in fact, verify that the first solution was 
flawed. It only won a silver
award because it is O(n**2). But at least it is correct. 
Oh, the irony!

The third solution I submitted was a combination of the first two,
and was categorized as O(n**2),
but I oversimplified the distance test and it timed out when
all the points were in a row. 

The fourth solution I submitted satisfied me that it was actually
correct and still was categorized by Codility as O(n**2), so it
was the first Golden Award that I was happy with.

It still bugged me that the algorithm was doing a lot of math.
It was using the Pythagorean theorem to compute distances on
every comparison of 2 sheep. If `md` is the `2D` of the problem
statement, meaning the length of the side of the largest 
sunshades allowed, than the farthest away 2 sheep could be
and still have their shades touch is `sqrt(2*md**2)`, which
would be the case if the 
corners of their shades touched. I wasn't taking square
roots anywhere since all I cared about was comparison and
`(a <=> b) === (sqrt(a) <=> sqrt(b))` for positive real numbers,
but still, it was a lot of math.


This was because I was doing all
the geometry in my head and wanted to be conservative. Finally
I did some geometry on paper an derived that if `ds` is
twice the square of the distance of a specific sheep
from the origin, and `md` is as stated in the previous paragraph, 
then the maximum square of the distance from the origin another
sheep could be and still touch shades is
`ds + 4md + 2*md**2`.

This means I could memoize `ds` to calculate it `n` times
instead of `n*log(n)` times and only calculcate `4md + 2*md**2`
when it changed (probably about `log(n)` times)
instead of calculating `dx**2 + dy**2`
somewhere between `n` and `n**2` times. It doesn't change
the order of the algorithm, but it does still speed it up.
Plus I think it is cleaner. It is still `O(n*log(n))` but
in the performance tests, it took about half the time of
the previous version. 

Except, well, that is wrong, too. I made a mistake with my 
algebra when expanding `(ds + md)**2`. On paper I was 
using `d`, not `ds`, and the middle term should be `2*d*md`, but
instead of writing `2dmd`, I just wrote `2md` and did not
notice because the d was still there. The correct 
answer is a drag, though, because it means I cannot memoize 
`max_origin_delta` because it increases with the absolute 
distance from the origin. I either have to go ahead
and take square roots up front and get every sheep's distance
in linear (not square) units or calculate `max_origin_delta`
fresh for every sheep in the outer loop. It is `O(n)` either way,
and certainly `n` square roots is going to take longer than
`n` more multiplications, but if we go ahead and calculate
`ds` correctly using `sqrt(x**2 + y**2)`, then `max_origin_delta` is
always exactly equal to `sqrt(md**2 + md**2) == sqrt(2)*md` and 
people looking at the code
are faced with much simpler geometry (and algebra) when trying
to understand it, so I am inclined pick that one.

So finally I got to an O(n*log(n)) [solution](sheep_shades.rb)
that is also correct.
