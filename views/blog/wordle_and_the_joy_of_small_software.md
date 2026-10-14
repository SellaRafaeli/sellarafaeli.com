<!-- {"created_at": "2022-02-03"} -->
## Wordle and the Joy of Small Software

The New York Times just bought Wordle for a price "in the low seven figures". Wordle, if you've somehow missed it, is a five-letter word game you can play once a day. A few months ago it was something one developer made for his partner. Now millions of people post little grids of green and yellow squares every morning.

I've been playing it every day, like everyone else. But what fascinates me isn't the game. It's the software.

### What Wordle is (technically)

Open the page, view source. Wordle is a single web page. The list of answers is right there in the JavaScript, in order - you could read tomorrow's word if you wanted to ruin it for yourself. Your progress and streak are saved in your browser's local storage. There's no backend to speak of.

There's no:

- account
- login
- email capture
- app to download
- push notification
- ads
- tracking popup
- infinite feed
- in-app purchase
- "you've played 3 games, upgrade to premium"

**It does one thing, once a day, and then it lets you go.**

### Constraint is the feature

One puzzle a day sounds like a limitation. It's actually the whole design. Because everyone gets the same word on the same day, everyone has something to talk about. Because you can't binge it, you never burn out on it. Because it takes three minutes, it fits in your coffee. The scarcity is what makes it social, and the simplicity is what makes it spread.

Compare that to how most products are designed today: maximize "engagement", time-in-app, daily active minutes. I've written before about how [Facebook is addictive by design](/blog/remember_facebook_is_addictive). Wordle is the opposite - it's *respectful* by design. It assumes you have a life, and it would like to be a small, nice part of it.

And people love it for exactly that.

### The share grid is genius

The one "growth feature" Wordle has is the share button: it copies a grid of emoji squares showing how your guesses went, without revealing the word. It works on any platform - Twitter, WhatsApp, a text to your mom - because it's just text. No link preview, no deep link, no SDK, no attribution tracking.

It's probably the most effective viral loop of the year, and it's a string.

### What this means for the rest of us

I'm not saying every app should be one HTML file (though more could be than you'd think). But there are lessons in here for anyone building products:

- **Small software can be complete.** A product doesn't need to grow features forever to be finished. Some things are done.
- **Every feature has a cost to the user**, not just to the developer. An account system is friction. A notification is an interruption. Ask whether the user is better off with it.
- **You can do a lot without a backend.** Local storage, a static file, a CDN. That's a product that costs almost nothing to run and basically can't go down.
- **Delight beats engagement.** The metric that made Wordle spread was "people liked it enough to tell their friends", which no dashboard measures well.
- **One person can still build something millions use.** The web is still the most accessible distribution platform in history. You don't need a team, a round, or a growth hacker. You need a good idea and a weekend.

### Will the Times ruin it?

Maybe. Big companies have a way of adding accounts and paywalls and "engagement features" to things they buy. I hope they keep it simple - the whole point is that it's simple. Either way, the creator built something small and lovely, millions of people enjoyed it, and he got paid. That's a pretty good outcome for a side project.

Now if you'll excuse me, I have a streak to protect.

**Build small things. Finish them.**
