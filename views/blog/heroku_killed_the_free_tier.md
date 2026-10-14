<!-- {"created_at": "2022-08-30"} -->
## Heroku Killed the Free Tier

Last week Heroku announced that, starting in November, there will be no more free dynos, no more free Postgres and no more free Redis. Their stated reason is fraud and abuse - people running crypto miners and spam bots on free accounts - and I'm sure that's real.

The developer Internet reacted like someone died. In a way, someone did.

### What Heroku gave us

It's hard to explain to people who started coding recently how magical Heroku was when it appeared. Before it, putting a web app on the Internet meant renting a server, SSHing into it, installing a web server, a language runtime, a database, configuring all of them, setting up deploys, and then praying.

With Heroku, it was:

~~~ bash
git push heroku master
~~~

And your app was live. On the Internet. With a URL. For free.

For a whole generation of developers, that was the moment programming became real: not a tutorial running on localhost, but a thing your friends could open on their phones. Countless side projects, hackathon demos, student assignments, first startups, and portfolio sites lived on free dynos. This site has lived on Heroku for years.

**Heroku's free tier taught a generation that deploying should be boring.** That's an incredible legacy.

### It's been a slow decline

Honestly, this isn't a surprise. Heroku has felt like it was on autopilot for years. The product barely changed. Then this spring there was the security incident with their GitHub integration, which was disabled for over a month - for a platform whose entire identity is "connect your repo and deploy", that was a bad look. Ending the free tier feels like the next step of a company that's being managed for revenue rather than built for developers.

That's a business decision, and they're allowed to make it. But it's a reminder of something I keep repeating: **if you build on someone else's platform, you're a tenant.** The terms can change. Sometimes overnight.

### Where to go

The good news is that Heroku's idea won. "Push to deploy" is now the norm, and there are plenty of good options, many with generous free or cheap tiers: Render, Fly.io, Railway, and the big clouds' own simplified platforms, plus Vercel and Netlify for frontends and static sites. A cheap VPS with a simple deploy script is also a completely valid choice and has never been easier.

My advice for picking one:

- **Keep your app portable.** A standard web app that reads its configuration from [environment variables](https://medium.com/@sellarafaeli/introduction-to-env-files-2fe1cc06d502), listens on `$PORT`, and keeps its state in a database can move between any of these platforms in an afternoon. That's the actual lesson from Heroku's "twelve-factor app" philosophy, and it's worth more than any single platform.
- **Avoid proprietary glue where you can.** Every platform-specific add-on is a little more lock-in. Sometimes it's worth it. Know when you're making that trade.
- **Pay for things you depend on.** If your business runs on it, a few dollars a month is the cheapest insurance you'll ever buy. Free tiers are for learning and experimenting, and they can disappear - see above.
- **Don't over-correct.** The answer to "my free hosting went away" is not a Kubernetes cluster. Find the simplest paid thing that works and move on with your life.

### What I'll miss most

Not the free hosting, really. What I'll miss is the zero-friction path for beginners. A teenager with a laptop could build something and show the world, without a credit card and without understanding servers. That on-ramp mattered. I hope one of the newer platforms takes that responsibility seriously, because the next generation of developers deserves the same moment of magic we had.

Thanks, Heroku. You made deploying boring. That's the highest compliment I can give.

**Push to deploy won. Make sure you can push somewhere else.**
