---
title: Project Update
---

The past two weeks started out with some disappointing news. After finally finishing the new version of my FFT (the pipelined one), the new decoding would not give correct results. After a lot of experimentation to figure out what was wrong with the FFT, I eventually decided that it was working fine. Instead, I should check out the decoding idea itself on a platform with a previously known-to-be-correct FFT.

With [Mathematica](http://www.wolfram.com/mathematica/), I worked through the decoding process to find that the issue was not the FFT, but the decoding itself. For some reason, decoding was broken. This is contrary to my previous idea that it worked perfectly. The old version of the verilog FFT had output perfect results for the input that I gave it. I have yet to figure out why it works. It currently is black magic.

Now that I knew that decoding was broken, I decided to figure out how broken it really was. I wrote up a python version of the encoding and decoding, which made my project seem slightly sad. The entire encoding and decoding boils down into

    def autocorr(arr):
        freq = fft(arr, 2*len(arr))
        powerspec = numpy.power(numpy.absolute(freq), 2)
        corr = ifft(powerspec)[:len(arr)]
        return numpy.real_if_close(corr, 1e6)

    def maxind(arr):
        index = 0
        best = arr[0]
        for i, value in enumerate(arr):
            if value > best:
                best = value
                index = i
        return index

    def encode(it, separation, magnitude, skip=128):
        d = deque(maxlen=separation)
        for i in range(skip):
            d.append(next(it))
        for i, v in enumerate(it):
            p = d.popleft()
            d.append(v)
            yield v + p*magnitude

    def decode(block, e1, e2):
        corr = autocorr(block)
        return maxind([corr[x] for x in (e1, e2)])

However, this representation cheats a little bit because the vast majority of the work I've been doing centers around the `fft` function, which is provided by [numpy](http://www.numpy.org/).

After a lot of tinkering, this version ran fine but was pretty slow (thanks python). I managed to glean from it the information that the best bit error rate was included with the echo the same size as the original signal---makes logical sense.

I rewrote this program again into C, so as to create a faster implementation. This implementation was having some issues with computing FFTs of size > 16, but I managed to narrow the problem down to the binary reverse function (after several hours of work). One issue was I had gotten the reversed binary values from a google search rather than typing them out myself. The other issue was logical error in the binary reverse transformation. I was running over the entire list, meaning that all of the items were getting transformed and then transformed back when their partner got transformed.

I ran the program on 84000 blocks in order to determine the best (sample) positions for the echos.

Compiling the resulting data into a nice contour plot:

![contour plot graphic]({{ site.url }}/resources/biterrorcontour.png)

The left graphic is the scaled autocorrelation and the right plot is the unscaled autocorrelation. White is good (low) bit error rate and blue is bad (high). For this particular plot, I used inverse bit error rate to show more detail in the lower values rather than the higher values.

Interesting things to note:

1. The line at approximately `y = 2x` on the left plot
2. The lack of such a line on the right plot
3. Strange drops in the bit error rate in areas of relatively good error rates
