<!-- {"created_at": "2023-09-19"} -->
## Unity and the Platform Tax

Last week Unity, the game engine that powers a huge share of the world's mobile and indie games, announced a new "Runtime Fee": starting January, developers would pay Unity a fee *per install* of their game, once it passed certain revenue and install thresholds. Including, initially, games that were already released.

The reaction was immediate and furious. Studios announced they were pausing work, or switching engines. Developers did the math and found scenarios where the fee would exceed their revenue. Unity has since apologized and promised changes, but the damage is done. A lot of developers just learned, in one week, that the foundation under their business could move.

I don't make games. But every developer should be paying attention, because this is a story about platforms, and we all build on platforms.

### The platform tax

When you build on someone else's platform - a game engine, an app store, a social network's API, a cloud provider, a SaaS - you're making a trade. You get a huge head start: tools, distribution, infrastructure you'd never build yourself. In return, you accept that the platform owner sets the terms.

That's a fine trade, most of the time. The problem is that **the terms are set at the moment the platform needs you, and changed at the moment you need the platform.**

Early on, the platform is generous: free tiers, great APIs, cheap pricing. It needs adoption. Once you've built your business on it - years of code, tools, skills, your team's expertise - switching becomes very expensive. That's when the terms change. Not because anyone is evil; because that's when the platform has the leverage.

We've seen it this year alone with Twitter's API pricing and Reddit's API changes. Last year, [Heroku's free tier](/blog/heroku_killed_the_free_tier). Now Unity.

### "Retroactive" is the real crime

Price changes are normal. Companies are allowed to charge more for their products. What made Unity's announcement so explosive was applying new fees to games that were *already shipped*, under terms that developers reasonably believed were settled. That breaks something more important than a budget. It breaks trust that the deal you made will still be the deal tomorrow.

Once a platform shows it's willing to do that, every developer on it has to price in the risk that it'll do it again. That's a cost Unity will pay for years, even if they walk back every detail.

### How to build on platforms without being owned by them

You can't avoid platforms entirely. You shouldn't try - building your own game engine or cloud is almost never the right call. But you can be thoughtful:

- **Keep the core of your business portable.** Your data, your customer relationships, your core logic. The parts that would be hard to rebuild should depend on the platform as little as possible.
- **Wrap the platform.** Put a thin layer between your code and a platform's API, so a migration means rewriting the wrapper, not the whole app. It's not free, but it's cheap insurance for critical dependencies.
- **Own your audience.** If your only relationship with customers goes through an app store or a social network, you don't really have a relationship. Get an email list. Have [your own first-party data](/blog/first_party_data_is_the_only_data).
- **Prefer open standards and boring tools** where you can. Plain web apps, standard databases, open formats. Nobody can change the license on HTML.
- **Have a rough plan B.** Not a full migration - just an honest answer to "if this platform doubled its price tomorrow, what would we do?"

### The broader lesson

Every platform, eventually, needs to make money from the people who depend on it. That's not a betrayal. It's the business model. The question is just how much leverage you hand them before it happens.

**Build on platforms. Just don't build *inside* one.**
