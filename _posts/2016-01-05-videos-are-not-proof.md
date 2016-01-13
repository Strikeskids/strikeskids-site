---
title: Videos are not Proof
---

There used to be a time when people considered pictures to be valid evidence of an occurrence. Someone would have doubts, and upon revealing a photo of the described situation, those doubts would be erased. Photoshop has completely eliminated that form of proof. Watching [pizza be turned into a model](https://www.youtube.com/watch?v=9j656_RiO0k) serves as further evidence that photos cannot be trusted.

What ways are there to demonstrate that something occurred online? Screenshots and screencaptures are the ways that proof can be sent from one person to another. Screenshots are easily edited with Photoshop, just like real-life photos, but videos are still trusted online. Although VFX should decrease trust in that medium, the time required to produce accurate-looking video modifications is far too large. Thus, if video proof is produced on-demand in a reasonable time-frame, it is accepted as true.

In order to break this assumption, that video is acceptable as proof, we need a way to quickly create a video that looks real but contains false content.

The [video](https://cdn.streamable.com/video/mp4/j3p1.mp4) the sparked this idea came from a website where a user was trying to prove that he was falsely reprimanded. I'm just going to modify another part of that same website as a demonstration.

Instead of tackling the problem from the side of video editing, I'm going to work from the other side. It turns out that making a website behave differently is far easier than making a video of a website behaving differently. I'm going to make a quick chrome extension to modify the site as it loads.

A chrome extension is just a folder that contains a `manifest.json`:

~~~ json
{
    "manifest_version": 2,
    "name": "Website Modifier",
    "description": "This extension modifies websites on the fly to create fake proof",
    "version": "0.1",
    "permissions": ["tabs"]
}
~~~

From what I could tell, the easiest way to change the content on the page is to inject some Javascript that will change it for me. This method of injection from a chrome extension is known as a content script. We can add the following lines to our `manifest.json` to load our own content script.

~~~ js
{
    ...
    "content_scripts": [
        {
            /* When do we want to inject? */
            "matches": ["http://www.powerbot.org/*"],
            /* What files we want to inject? */
            "js": ["powerbot.js"],
            /* Run the injection when the document finishes processing */
            "run_at": "document_idle"
        }
    ]
    ...
}
~~~

Now, `powerbot.js` from the root folder of the extension will be injected directly into the page like it was loaded in a `<script>` tag.

I've chosen to inject into the notifications widget.

{: .image-figure}
![notifications widget screenshot]({{ site.baseurl }}/resources/Screen Shot 2016-01-05 at 3.40.55 PM.png)

From DevTools, we can copy and modify the notification row. Now, that just needs to be appended into the parent container.

~~~ html
<li class=" ipsType_small clearfix">
    <img src="//powerbot-dequeue.netdna-ssl.com/community/uploads/profile/photo-thumb-259372.png?_r=0" 
        alt="Strikeskids's Photo"
        class="ipsUserPhoto ipsUserPhoto_mini left">
    <div class="list_content">
        My new fantastic notification<br />
        <span class="ipsType_smaller desc lighter">Tomorrow</span>
    </div>
</li>
~~~

A first try is to find our container `#user_notifications_link_menucontent > ul` and then append this content.

~~~ js
var container =
    document.querySelector('#user_notifications_link_menucontent > ul')
container.innerHTML += modifiedRow
~~~

We can add this script into Chrome by opening up `chrome://extensions`. Click `Load Unpacked Extension` and select the extension folder. This will load the extension and enable it immediately.

Unfortunately, this script does nothing. In DevTools, content script errors are helpfully displayed. This tells us that the container isn't created until the notifications button is clicked. As an extra challenge, its content is loaded dynamically. We need to listen for the click on the notifications button, and THEN wait for children to be added to the wrapping container.

~~~ js
var button = document.querySelector('#notify_link')

button.addEventListener('click', function evt() {
    button.removeEventListener('click', evt)
    var container =
        document.querySelector('#user_notifications_link_menucontent')
    var observer = new MutationObserver(observe)

    // Wait for children to be added
    observer.observe(container, {childList: true})

    function observe() {
        var ul = container.querySelector('.ipsList_withminiphoto')
        if (!ul) return
        ul.innerHTML += modifiedRow
        observer.disconnect()
    }
})
~~~

We remove the listener and observer once they fire to avoid having our extra notification added multiple times.

Back in `chrome://extensions`, clicking Refresh on our extension will reload our new changes. Not only does this extension produce the desired effect, it works exactly as expected.

<video width="auto" height="auto" controls>
    <source src="//cdn.streamable.com/video/mp4/5zbv.mp4" type="video/mp4" />
    <a href="https://cdn.streamable.com/video/mp4/5zbv.mp4" target="_blank">Open the video</a>
</video>

In all, that could take about 20 minutes from start to finish. That is a reasonable time-frame for producing legitimate video proof&mdash;find the recorder, take the video, upload the video. Thus, we can produce a fake website in a similar time-frame to producing a real video. Now that the extension is set up, the time required to produce a false result would be even less.

Note: This could be done easily with something like [Tampermonkey](https://chrome.google.com/webstore/detail/tampermonkey/dhdgffkkebhmkfjojejmpbldmpobfkfo), but that takes away the whole learning process.
