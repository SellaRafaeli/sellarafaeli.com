<!-- {"created_at": "2021-12-14"} -->
## 2021: The Year Dependencies Bit Back

Last Thursday, the security world caught fire. A vulnerability in Log4j - a logging library for Java, used in roughly everything - turned out to let attackers run their own code on a server just by getting it to *log a specific string*. Type it into a chat box, put it in a username, send it in an HTTP header: if it gets logged, you're potentially owned. They're calling it Log4Shell, it scores a perfect 10 on the severity scale, and every security team on Earth is having a very bad December.

A few years ago I wrote a post called [Dependency Madness](/blog/dependency_madness). The argument was simple: your app is mostly code you didn't write and never read, and that is a security problem whether or not anything has gone wrong *yet*.

2021 is the year it went wrong. Repeatedly.

### February: dependency confusion

A researcher named Alex Birsan noticed that many companies use internal packages with private names, and that package managers would happily prefer a *public* package with the same name and a higher version number. So he published public packages with names matching internal packages at Apple, Microsoft, PayPal and dozens of others - and their build systems downloaded and ran his code. (He did this responsibly, for bug bounties. The next person won't.)

Nobody hacked anything. The tools just did what they were configured to do.

### October: ua-parser-js

ua-parser-js is a small npm library that parses browser user-agent strings. It gets downloaded millions of times a week. In October, the maintainer's npm account was hijacked and malicious versions were published, installing a cryptominer and a password stealer on any machine that ran `npm install` in that window.

A library that reads a string and tells you "this is Chrome on a Mac". That's the thing that compromised machines.

### December: Log4Shell

And now this. Log4j isn't some obscure package; it's a respected, mature, widely trusted Apache project. The vulnerable feature (looking up values inside log messages, including from remote servers) is something almost nobody using the library knew existed, let alone needed. It's been sitting there for years. Inside cloud services, enterprise software, games, appliances. Many teams are discovering this week that they use Log4j only because some dependency of a dependency of a dependency uses it.

That last sentence is the whole problem in miniature.

### The pattern

Three very different incidents, one lesson: **every dependency is a door, and you don't know who holds the keys.**

- Sometimes the attacker walks in through a name collision (dependency confusion).
- Sometimes they steal the maintainer's keys (ua-parser-js).
- Sometimes the door was just built wrong, years ago, and nobody noticed (Log4Shell).

You can't audit your way out of this completely. But you can make the attack surface smaller, and smaller is better.

### What to actually do

**This week:** find out whether you're affected. Search your dependency trees (all of them, including transitive ones) for log4j, patch, and check your logs for the exploit string. Then read the guidance from people who know Java far better than I do.

**This year:**

- **Count your dependencies.** Literally. `npm ls --all | wc -l` is a sobering exercise. You can't secure what you can't list.
- **Prefer fewer, bigger, boring dependencies** over many tiny ones. A well-funded framework with a security team is a different risk from four hundred one-function packages maintained by four hundred strangers.
- **Pin versions and use lockfiles**, so a new malicious release doesn't silently flow into your build. Update deliberately, not automatically.
- **Use scoped or namespaced private packages** so a public package can never masquerade as an internal one.
- **Turn on automated vulnerability alerts.** GitHub and others will tell you when a known CVE hits something you use. It's free. It's not enough, but it's the floor.
- **Before adding a package, ask whether you need it.** If it's twenty lines, write the twenty lines. If it's a feature you don't use, it's attack surface you don't need.

### Some dude's code

I keep coming back to the phrase from that old post: a third-party dependency is *some dude's code*, running in your app with your app's privileges. Usually it's a talented, generous dude doing unpaid work that the whole industry relies on, and we should be deeply grateful for open source. But gratitude isn't a security model.

2022 resolution: know what's running in your app. All of it.

**Your attack surface is everything you import.**
