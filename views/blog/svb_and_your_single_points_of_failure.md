<!-- {"created_at": "2023-03-15"} -->
## SVB and Your Single Points of Failure

What a week. On Thursday, Silicon Valley Bank's customers - mostly startups and VC funds - started pulling their money out, coordinated in group chats and on Twitter at a speed no bank run in history has ever had. On Friday, regulators shut the bank down. All weekend, thousands of founders didn't know if they'd be able to pay salaries on Monday. On Sunday night, the government announced that all depositors would be made whole.

Here in Israel, it was felt sharply. A lot of Israeli startups banked with SVB - it was *the* startup bank, the one your investors recommended, the one that "understood tech". Founders I know spent the weekend on the phone trying to move money anywhere that would take it.

Everyone's fine now (mostly). But it's worth thinking about what happened, because it's a lesson software people should recognize immediately.

### The bank was a single point of failure

In system design, a single point of failure is a component whose failure takes down the whole system. Every engineer is trained to spot them: the one database with no replica, the one server, the one engineer who knows how deploys work.

For thousands of startups, SVB was a single point of failure for *the entire company*. All the money, in one account, at one bank. Payroll, vendors, runway - everything depended on that one institution being fine.

And why wouldn't it be? It was a big, respected bank. That's exactly the thinking that creates single points of failure in software, too: "this will never go down". Until it does.

### The herd made it worse

The other thing that made SVB unusual was how correlated its customers were. Same industry, same investors, same group chats. When a few prominent VCs told their companies to pull money, everyone heard it at the same moment, and everyone ran at once.

In software terms: **a bunch of clients with the same retry logic all hammering the same server.** We call it a thundering herd. It turns a wobble into a collapse.

### What founders should do (now that we can breathe)

I'm not a financial advisor, and you should talk to someone who is. But from an engineering mindset:

- **Have more than one bank.** At minimum, enough in a second account to cover a couple of months of payroll. It's boring, it's a bit annoying, and it's the cheapest insurance you'll ever buy.
- **Know where your money actually is.** Many founders discovered they didn't really understand what accounts and products they had. Write it down.
- **Make sure you could switch.** Can you change where payroll is paid from, quickly? Who has access? What do you need to sign? Find out on a calm Tuesday, not in a panic on a Saturday.
- **Don't do what everyone else does just because everyone else does it.** Herd decisions feel safe. They concentrate risk.

### And look at your stack while you're at it

The same week is a good excuse to look at the single points of failure in your product. I've written about this after [the Fastly outage](/blog/the_day_the_internet_went_down) and after [Facebook disappeared for six hours](/blog/facebook_was_down_for_six_hours). Make a list:

- What's the one service that, if it disappeared, would take you down?
- Is there one person who holds knowledge nobody else has?
- Where are your backups, and could you actually restore them?
- Who has the keys to your domain, your cloud account, your code?

You don't need to eliminate every single point of failure; that's expensive and usually counterproductive. You need to **know where they are**, and have a simple plan for the ones that matter.

### Trust, but have a plan B

SVB's customers weren't naive; the bank made its own mistakes, mostly in how it managed interest-rate risk. But that's always the case. Banks fail; services go down; vendors change their terms. The lesson isn't paranoia. It's that resilience comes from not betting everything on one thing - especially the thing everyone else is also betting on.

**Everything is a single point of failure until you have a second one.**
