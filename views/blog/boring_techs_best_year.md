<!-- {"created_at": "2023-12-27"} -->
## 2023: Boring Tech's Best Year

It's the end of the year, and while everyone else writes their AI roundup, I want to celebrate something less flashy. I think 2023 was quietly the best year in a long time for boring technology.

For the past decade, the industry's default was "more": more services, more frameworks, more build steps, more infrastructure, more layers. This year, for the first time I can remember, a lot of very credible people started publicly walking that back. Here's what I noticed.

### The monolith came back

In May, Amazon's own Prime Video team wrote about [moving a system from microservices back to a monolith](/blog/even_amazon_went_back_to_the_monolith) and cutting its costs by over 90%. It went viral because it said out loud what many engineers had been thinking: distributed systems are expensive, and most systems don't need to be distributed.

Throughout the year, I heard more and more teams talk about "consolidating services" - which is a polite way of saying "we built too many and we're merging them back".

### HTML came back

htmx, which I [wrote about in 2021](/blog/html_over_the_wire), went from a niche library to something people are actually excited about. Rails 7 is all-in on sending HTML over the wire. The idea that you can build a good, interactive web app with server-rendered HTML and a little bit of JavaScript stopped sounding old-fashioned and started sounding refreshing.

There's even a growing "no build" movement: skip the bundler, ship plain JavaScript modules that modern browsers understand natively. Some well-known projects dropped TypeScript this year in favor of plain JavaScript, which started a very loud argument. I don't think there's one right answer there - but the fact that "maybe we don't need this layer" is a respectable position again is a big shift.

### The database got boring again

Postgres continued its slow takeover of everything, and a lot of teams discovered that one well-tuned database can replace a surprising number of specialized systems: queues, caches, search, even vector search for AI features. SQLite went from "toy database" to "serious option for production apps" in many conversations. Meanwhile, my old friend MongoDB is still [a great general-purpose database](/blog/mongodb_is_a_great_general_purpose_db). I remain not religious about it. One good database beats five interesting ones.

### Money made everyone practical

The end of free money, which I [wrote about last year](/blog/the_end_of_free_money), really hit in 2023. Companies looked at their cloud bills and their SaaS subscriptions and their headcount, and asked hard questions. When every dollar matters, the boring stack wins, because it's cheaper to run and cheaper to maintain.

Even the AI wave, the least boring thing of the year, rewarded boring engineering. The teams I saw do well with AI weren't the ones with the fanciest architecture. They were the ones with clean data, simple systems, and a clear idea of what problem they were solving.

### Why this matters

Boring technology isn't about being old-fashioned. It's about spending your limited energy on the things that make your product better for users, instead of on infrastructure for its own sake. A small team with a simple stack can move incredibly fast. A small team with a complicated stack spends its time maintaining the stack.

I've been arguing this for a long time - since before it was fashionable, and through the years when it was very unfashionable. It's nice to have company.

### For 2024

My wish list for next year:

- More teams asking "do we need this?" before adding a service, a framework, or a vendor.
- More developers learning the fundamentals - HTTP, SQL, HTML, the browser - which outlast every framework.
- More senior developers sharing what they've learned, publicly, in writing.
- And for everyone reading this: a calmer, safer, healthier year than the one we just had.

**Boring is not the opposite of good. Often, it's the shortest path to it.**
