<!-- {"created_at": "2022-11-24"} -->
## Twitter Is Still Up

A month ago Elon Musk took over Twitter. Within a week, about half the company was laid off. Then came an ultimatum to commit to being "extremely hardcore" or leave, and a lot more people left. By most estimates, Twitter now has a fraction of the engineers it had in October.

Every engineer I know predicted it would fall over. Systems would fail, nobody would know how to fix them, the site would go dark during the World Cup.

So far, Twitter is still up.

Here's my attempt at an honest take, because the discussion so far has been mostly people cheering or mourning, depending on how they feel about the man.

### Lesson one: big companies are often overstaffed

It's an uncomfortable thing to say during layoffs, but it's true and every engineer who has worked at a big tech company knows it. Over the last decade of cheap money, companies hired ahead of need, built teams to manage teams, and accumulated layers of process that existed mostly to coordinate the people the process required.

A large share of engineering effort at a big company isn't building the product. It's meetings, alignment, migrations between internal tools, and work that makes sense only because the organization is big enough to need it. Remove half the people and some of that work just... disappears, because it existed to serve the size of the org itself.

I've been saying for years that [a few senior people can outrun a large team](/blog/the_end_of_free_money). Twitter is an extreme, uncontrolled experiment in that claim.

### Lesson two: well-built systems keep running

The fact that Twitter didn't immediately collapse is a testament to the engineers who built it and then were let go. Good infrastructure is built to run without heroics: automated deploys, failover, monitoring, self-healing services. That's what a decade of serious engineering buys you. The system keeps working even when the people who understand it are gone.

But that's exactly the danger.

### Lesson three: you don't see the decay at first

Systems don't fail the day knowledge leaves. They fail later, slowly, and then suddenly. The certificate that nobody remembers how to renew. The dependency that needs upgrading. The rare edge case that only one person knew how to debug. The capacity planning that nobody's doing. **Institutional knowledge is invisible until the day you need it.**

Running a system is cheap. *Changing* a system safely, when you don't understand it, is very expensive. The real test for Twitter isn't whether it stays up this month. It's whether the remaining team can ship meaningful changes over the next year without breaking things they didn't know existed.

### Lesson four: how you do it matters

Even if you believe Twitter was overstaffed - and I think it probably was - the way you reduce a team matters enormously. Firing people by email at midnight, locking them out of systems before they can hand anything over, and then asking some of them to come back because you cut the wrong people: that's not lean management, it's just chaos. It damages the systems and the people, and everyone else in the industry is watching and remembering.

You can believe in small teams and still believe in treating people decently. Those aren't in conflict.

### What I'd take from all this

- **Most teams could be smaller and more senior.** Fewer people, each owning more, with less coordination overhead.
- **Invest in boring operational excellence**: automation, monitoring, documentation. It's what keeps you alive on your worst day.
- **Write things down.** If one person leaving can break your system, that's a bug in your organization.
- **Shrink deliberately, not dramatically.** Know what each person does before you decide you don't need it.

Twitter might be fine. It might slowly degrade. It might fall over spectacularly next month. I genuinely don't know, and neither does anyone else. But it's the most interesting systems experiment of the year, and every engineering leader should be paying attention.

**Systems can run without people for a while. They can't improve without them.**
