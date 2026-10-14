<!-- {"created_at": "2021-06-10"} -->
## The Day the Internet Went Down

On Tuesday morning (well, Tuesday morning in Europe) a big chunk of the Internet just... stopped. Reddit, Amazon, the New York Times, the Guardian, Twitch, gov.uk, Stack Overflow - all returning errors at the same time. The cause, as Fastly later explained, was a single customer pushing a perfectly valid configuration change that triggered a dormant bug in their CDN. One config change, one company, and a good part of the web was down for about an hour.

The memes were excellent. The lesson is more interesting.

### The cloud is other people's computers

We have built a web where most traffic flows through a handful of companies: a few CDNs, a few cloud providers, a few DNS providers. That's mostly a good thing - they're very good at what they do, and they're far more reliable than the server in the office closet that we used to run. But it means that when one of them sneezes, the whole Internet catches a cold.

**Centralization makes the average day better and the worst day worse.**

There's no free lunch here. You can't have the economies of scale of a giant shared infrastructure without the shared failure modes of a giant shared infrastructure.

### Should you go multi-CDN? Multi-cloud?

The predictable reaction this week is a wave of blog posts and vendor pitches telling every company to go multi-CDN, multi-cloud, multi-region, multi-everything.

For Amazon, sure. Amazon loses an unimaginable amount of money every minute it's down.

For your startup? **Probably not.** Every layer of redundancy is another system to configure, monitor, test and pay for, and redundancy systems are famously the parts that fail in surprising ways (because they're only exercised during disasters). You will very likely cause more downtime with a half-understood failover setup than you'd ever suffer from a once-a-year provider outage. I wrote about this kind of cost-benefit last year in [Runway Engineering](/blog/runway_engineering): complexity is a loan, and you pay interest on it every sprint.

Here's the thing: when Fastly goes down and takes Amazon and Reddit with it, **nobody is angry at you.** Your users understand the Internet is having a moment. Your outage is lost in the noise of everybody's outage. That is a weirdly comforting property of using the same providers as everyone else.

### What's actually worth doing

Instead of multi-everything, a few cheap things that give you most of the value:

- **Know your dependencies.** Make a list of every external service your app needs to function. CDN, DNS, hosting, database, email, payments, auth. You'd be surprised how long it is, and how many of them you forgot about.
- **Fail soft where you can.** If your analytics script or your chat widget can't load, the page should still work. If the payment provider is down, show a nice message instead of a stack trace. Most outages are partial; your app shouldn't turn a partial outage into a total one.
- **Have a status page that isn't hosted on your own infrastructure.** Otherwise it goes down exactly when people need it.
- **Practice the 'what if' once.** Pick your most critical external service and ask: if this is down for a day, what do we do? Write the answer down. That's your plan.
- **Keep it simple enough to understand under pressure.** At 3am during an incident, nobody wants to discover how the service mesh works.

### Kudos to Fastly

For what it's worth, Fastly handled this well. They found it fast, fixed it within the hour, and published a clear, honest explanation the same day, without blaming the customer. That's how incidents should be handled, and it's the standard I try to hold myself to with [my own postmortems](/blog/whitehat_postmortem_example).

Things break. Big things break too. The question was never whether your app will go down; it's whether it goes down gracefully, whether you understand why, and whether you tell people the truth about it.

**Build for the normal day. Plan, simply, for the bad one.**
