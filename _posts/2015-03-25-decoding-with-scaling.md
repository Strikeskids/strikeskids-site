---
title: Decoding with scaling
post_scripts:
    - '//cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS_HTML'
---

This week did not have as many cool diagrams as last week.

With the information gained from last week's experiment, scaled autocorrelation seemed to be much superior over unscaled autocorrelation. This is a result of the way the autocorrelation works.

$$
A_k = \sum_{i=0}^{n-k-1} a_i*a_{i+k}
$$

If you notice, each term in the autocorrelation has one less summed term than the previous term. ($$A_0$$ is the sum of $$n-1$$ terms, $$A_1$$ is the sum of $$n-2$$ terms, etc.) In order to fix this problem, each term in the autocorrelation should be scaled.

$$
A'_k = \frac{n}{n-k} \sum_{i=0}^{n-k-1} a_i*a_{i+k}
$$

I implemented this in verilog by adding an extension onto the autocorrelation output. As the samples stream out of the autocorrelation, each is scaled by the factor corresponding to its index. 

However, I just realized that I multiplied by the factor instead of dividing. This will produce incorrect results for the scaled autocorrelation. Because division is such an expensive operation, I will need to figure out an alternate solution. I'm not really sure what the best way to go about this scaling factor would be. A lookup table with 128 entries would be rather expensive for such a simple operation. Maybe there is an algorithm that can provide this rather easily?
