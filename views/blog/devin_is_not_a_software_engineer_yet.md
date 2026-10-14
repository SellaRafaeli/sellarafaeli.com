<!-- {"created_at": "2024-03-19"} -->
## Devin Is Not a Software Engineer. Yet.

Last week a startup called Cognition introduced Devin, which they call "the first AI software engineer". The demo video shows Devin taking a task, planning it, writing code, running it, hitting errors, debugging them, and finishing - in its own editor, terminal and browser. They report it resolved about 14% of the real GitHub issues in a well-known benchmark on its own, which is a big jump over previous systems.

The reaction has followed the usual script. Half my feed: "software engineering is over". The other half: "it's a cherry-picked demo". And a lot of very anxious junior developers asking me whether they should switch careers.

Here's my attempt at a calm take.

### Let's be impressed first

Fourteen percent of real-world issues, end to end, unassisted, is genuinely impressive. A year ago, when everyone was excited about AutoGPT, [I wrote](/blog/autogpt_and_the_myth_of_the_autonomous_developer) that agents mostly went around in circles. Devin, at least in the demos, doesn't. It plans, it executes, it recovers from errors. That's real progress, and it came fast.

If you'd told me two years ago that an AI would close one in seven real GitHub issues on its own by early 2024, I wouldn't have believed you.

### Now let's read the number again

Fourteen percent also means it *didn't* resolve 86% of them. And those are issues that come with a clear description, an existing codebase, and tests to check the result. That's the easy shape of software work - the problem is already defined.

Most of the actual job doesn't look like that. Real tasks arrive as "the client says the dashboard feels slow" or "we need to support enterprise customers" or "something's wrong with billing, a customer complained". Turning that into a well-defined issue *is* the job. Talking to people, finding the real problem, choosing what not to build, deciding on tradeoffs - Devin doesn't do any of that. Neither does anything else, yet.

### "Software engineer" is a big word

A software engineer is not someone who closes tickets. A software engineer is accountable for a system: designing it so it can change, keeping it running, understanding why it broke at 3am, and explaining the tradeoffs to people who don't write code. An agent that can resolve a well-specified issue is an incredibly useful *tool* for that person. It's not that person.

Calling it "an AI software engineer" is marketing. Very effective marketing - it got everyone talking - but marketing.

### What I actually think will happen

I think agents like Devin will get much better, quickly. Within a couple of years, I expect a big share of well-defined, well-tested tasks - small bug fixes, dependency upgrades, adding a field everywhere it needs to go, writing the tests nobody wanted to write - to be done by agents, with a human reviewing.

That's a big deal. It's also exactly the kind of work that used to be given to junior developers. Which is why I keep talking about [the K-shaped developer market](/blog/the_k_shaped_developer_market): the work at the bottom gets automated, and the people who can define, review and own the work at the top become more valuable.

### What to do about it

**If you're a junior developer:** don't panic, and don't switch careers. But don't plan on a career of only closing well-specified tickets. Learn to understand problems, not just implement solutions. Get good at using these tools - they make you faster too. Learn to read code critically, because reviewing AI output is going to be a big part of everyone's job.

**If you're a senior developer:** get these tools into your workflow now. Agents that can take the boring 30% of your work are a gift. Your judgment just became more leveraged.

**If you run a company:** don't fire your engineers because of a demo video. Do give your best engineers the best tools, and watch what happens.

**Devin isn't a software engineer. But software engineers with tools like Devin are going to be something new.**
