<!-- {"created_at": "2023-08-23"} -->
## Open Source Is Not a Business Model

Two weeks ago HashiCorp announced that future versions of Terraform (and their other products) will no longer be released under an open-source license. They're switching to the Business Source License, which lets you see and use the code but forbids building a competing commercial product with it. Within days, a group of companies that depend on Terraform published a manifesto asking HashiCorp to reverse course, and threatening to fork it if they don't.

This keeps happening. MongoDB did it in 2018. Elastic did it in 2021. Now HashiCorp. And every time, the Internet splits into two camps: "they betrayed the community" and "they have to make money somehow".

Both camps are right. That's the problem.

### The bargain that doesn't add up

Here's the pattern:

1. A company builds a great tool and releases it as open source.
2. Developers love it, adopt it everywhere, contribute to it, write tutorials for it, build careers on it. Adoption is fast precisely *because* it's open source - free to try, no lawyers, no lock-in.
3. The company raises venture money on that adoption.
4. A big cloud provider (or a well-funded competitor) starts offering the tool as a managed service, capturing much of the revenue, without paying the company that builds it.
5. The investors want returns. The company changes the license.
6. The community feels betrayed.

**Open source was the distribution strategy. It was never the business model.** And when distribution and business pull in different directions, the business wins.

### What the users should learn

I've been banging the drum on [dependency risk](/blog/the_year_dependencies_bit_back) for years, mostly about security. This is the other side of it: **license risk**. Every dependency you rely on comes with terms, and the terms can change for future versions.

Some practical thoughts:

- **Know who controls your critical tools.** A project governed by a foundation with many contributing companies (Linux, Kubernetes, Postgres) is very different from a project controlled by a single venture-backed company. Both can be great. They carry different risks.
- **Read the license on things you build a business on.** Not every package - but the database, the infrastructure tool, the framework. Five minutes now beats a surprise later.
- **Old versions stay open.** A license change usually affects future releases. You're not suddenly in violation; you're just at a fork in the road for upgrades.
- **Forks are real, but slow.** A community fork can absolutely succeed. It also takes time, splits the ecosystem, and usually lags behind for a while. Don't count on it being painless.

### What the companies should learn

If you're building a company around an open-source project, be honest with yourself early about how you'll make money. Hosting it as a service? Enterprise features? Support? Whatever it is, the decision about what's open and what isn't belongs at the *start*, before thousands of people have built on your promise.

Changing the license after the community has invested years of contributions and trust is legal. It's also expensive, in a currency that's hard to earn back.

### What I'd like to see

I think the healthiest model is the boring one: **use open source, and pay for it.** If your company depends heavily on an open-source tool, sponsor the maintainers, buy the commercial support, pay for the managed version from the people who build it. It's usually a rounding error compared to your cloud bill, and it keeps the projects you rely on alive.

The open-source ecosystem is one of the most remarkable things humans have ever built: millions of people writing software and giving it away. But "free to use" doesn't mean "free to make". Someone always pays. If it isn't the users, eventually it's the license.

**Free software isn't free to build. Act accordingly.**
