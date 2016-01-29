---
title: Real Small Caps on the Web
---

I've read before about the difference between fake and real small caps. Recently, I've discovered that I've been doing the bad thing all along. For a little bit of background, you can read the [<del>rants</del> discussion](http://practicaltypography.com/small-caps.html) [about small-caps](http://ilovetypography.com/2008/02/20/small-caps/). Essentially, fake small-caps are just a smaller font size of the capital letters. These are bad because they have a much lighter weight than the regular letters, which looks funny.

I was previously under the impression that the correct way to use small-caps on the web was to do

~~~ css3
font-variant: small-caps;
~~~

Looking at one of my previous pages, I discovered that an offending tag was using the fake small-caps. Reading up more on the issue did not give any enlightening solutions. I needed to enable "smcp" on the font, but no method of doing this was described.

Luckily, [Wikipedia](https://en.wikipedia.org/wiki/Small_caps) had the solution. To correctly enable small caps, you should use

~~~ css3
font-variant-caps: small-caps;
~~~

or, if you actually want your site to work on non-Firefox browsers

~~~ css3
font-feature-settings: 'smcp';
~~~

I find it interesting that none of the sites extolling the benefits of true small caps ever gave a solution for the web.

A related note: there is a semantic difference between `<strike>`, `<del>`, and `<s>`. It bears looking up.
