---
title: Verilog and Website Improvements
author: strikeskids
---

This week, my website needed a way to access all of the posts that I had written in an easy-to-use format. To do this, I created the simple [progress]({{ site.url }}/blog) page. With my already created `.post-date` class and liquid templating, that was a snap. I just added a horizontal rule in between 
each post with 

{% raw %}
    {% unless forloop.last %}
        <hr />
    {% endunless %}
{% endraw %}

Then, I added a neat new script that syncs my local copy of the website to the remote copy (pre-compliation) and then compiles it on the server. That way, I not only have an extra backup of my project in case something fails, but also it's quick an easy to update the site. I just used python `subprocess` to easily hook into `ssh` and `rsync` to the server.

I ran into a funny error when I was trying to write the sync script. For some reason, all of my posts were getting doubled up. I realized that rsync was copying the whole `web` folder over the the server instead of the contents of the folder. The fix was rather simple: append a `/` to the end of the source url.

After figuring out what was wrong with the decoding method earlier, I got around to fixing my verilog code for the simulator. Starting all the way back at the regular FFT, I checked with various test cases, comparing to Mathematica. This process got rather annoying because the answers were spit out in binary reversed order

{% raw %}
    BaseForm[Permute[ans * verilogmax / ans[[1]], Cycles[{{1,4},{3,6}}]], 16]
{% endraw %}

served as a quick fix to the problem. The `BaseForm` puts everything into hexadecimal, matching the ISim representation. Then, I normalize the values to be equal to the verilog maximum, because I'm using fixed point numbers. Finally, the permute swaps 8 terms around to match binary reversed order. This puts the mathematica "correct" output in the same representation as the verilog output, easing the verification time tremedeously.

I checked the standard FFT, then the autocorrelation, and finally made sure that all of the pieces of the decode function were fitting together correctly. Now, the only thing left is to make some new data with echos in better places (according to my [large test]({% post_url 2015-03-21-decoding-test %})) so that I can test how well the decoding works. Then, I can synthesize to the FPGA and build hardware to actually run the whole echo steganography chain.
