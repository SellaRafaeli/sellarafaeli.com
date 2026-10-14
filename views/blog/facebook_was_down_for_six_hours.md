<!-- {"created_at": "2021-10-06"} -->
## Facebook Was Down for Six Hours

On Monday, Facebook, Instagram and WhatsApp disappeared from the Internet for about six hours. Not slow, not buggy - gone. According to Facebook's own write-up, a routine maintenance command accidentally took down the connections between their data centers, and their systems responded by withdrawing the routes that tell the rest of the Internet how to find them. Reportedly, engineers had trouble even getting into the buildings to fix it, because the badge systems depended on the network that was down.

There's a technical lesson in there, and a human one. Let's do both.

### The technical lesson: don't depend on yourself to fix yourself

The striking detail isn't that a big system failed - big systems fail. It's that the tools needed to *recover* from the failure depended on the thing that failed. Internal tools, communication, access to the buildings: all running on the same network that just vanished.

We do smaller versions of this all the time:

- The status page hosted on the same servers as the app.
- The runbook that lives in the wiki that's behind the SSO that's down.
- The only admin login being "sign in with" the service that's having an outage.
- The alerting that sends notifications through the email provider that's also your app's email provider.

**Your recovery path should not share a failure mode with the thing it recovers.** It's worth five minutes, once, to ask: if our main thing is down, can we still reach the servers, talk to each other, and tell our users? If the answer involves the main thing, write down an alternative.

### The human lesson: what happened when it was gone

Here's what I find more interesting. For six hours, a few billion people couldn't scroll. And... the world continued. People texted instead. Called. Went on with their afternoon. Some apparently discovered Telegram and Signal (both reported huge signup spikes). There were jokes on Twitter about touching grass.

A few years ago I wrote that [Facebook is addictive by design](/blog/remember_facebook_is_addictive): a product carefully engineered to capture as much of your attention as possible, by some of the smartest engineers in the world, with every incentive to keep you scrolling. Monday was an accidental, global, six-hour experiment in what happens when that product is taken away. Did you miss it? Or did you just keep reaching for your phone out of habit, find nothing, and then do something else?

I'll admit: I opened Instagram several times before remembering it was down. That reflex is the product working as designed.

### WhatsApp is not optional, though

The serious part: in much of the world, WhatsApp isn't a social network. It's *the* phone system. In Israel it's how families coordinate, how businesses take orders, how doctors' offices send appointment reminders. Six hours of WhatsApp being down is not a fun detox for a lot of people; it's a real outage of critical infrastructure. Which is exactly what it has become, without anyone quite deciding that it should.

That's a lot of the world's communication sitting on one company's network, managed by one company's maintenance scripts.

### What I'm taking from it

- **For builders:** list what your recovery depends on, and make sure at least one path doesn't run through the thing you're recovering. Practice it once.
- **For businesses:** if your entire customer relationship lives inside someone else's platform - your followers, your group chats, your shop page - you don't have customers, you have a tenancy. Get an email list. Have your own website. [Own your first-party relationship](/blog/first_party_data_is_the_only_data).
- **For everyone:** maybe check how often you reach for the app when it's not there. That number is interesting.

Six hours is not long. But it's long enough to notice what you missed - and what you didn't.

**Build systems that can recover without themselves. Build habits that can survive without the feed.**
