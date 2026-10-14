<!-- {"created_at": "2023-04-19"} -->
## AutoGPT and the Myth of the Autonomous Developer

The newest thing in AI is "agents". The most famous one, AutoGPT, is currently one of the fastest-growing projects in GitHub history. The idea: instead of chatting with GPT-4 one message at a time, you give it a goal - "build me a website that sells socks" - and it breaks the goal into tasks, writes code, runs commands, searches the web, checks its own work, and loops until it's done.

The demos are wild. My feed is full of "I gave it a goal and went to lunch" posts and confident predictions that software engineering as a profession has about eighteen months left.

I've been playing with it. Here's my report.

### What actually happens

You give it a goal. It produces an impressive-looking plan. It starts executing. It writes some files. It runs into an error. It tries to fix the error. It creates a new error. It searches the web for the error. It gets distracted by something it found. It decides the original plan needs revising. It writes a new plan. It loops.

Sometimes, on small, well-defined tasks, it gets there. More often it burns through a pile of API credits and leaves you with a half-finished project and a very confident summary of what it accomplished.

That's not a criticism of the people building these tools - it's early, and some of it is genuinely clever. But there's a big gap between the demo and the daily reality.

### Why autonomy is the hard part

Remember: last year I called ChatGPT [a junior developer with infinite confidence](/blog/chatgpt_is_a_junior_developer_with_infinite_confidence). A good junior developer needs review, but they also *learn*, *notice when they're stuck*, and *ask for help*. An agent loop takes that junior, removes the reviewer, and lets them keep going.

Small error rates compound. If each step is right 90% of the time - which would be excellent - a 20-step task has about a 12% chance of every step being right. Software is long chains of steps where every link needs to hold.

Building software was never mostly about writing code. It's about:

- understanding what someone actually wants (which is usually not what they said)
- making tradeoffs with incomplete information
- noticing when the plan is wrong and changing it
- knowing when to stop
- being accountable for the result

Those are judgment problems, not typing problems. They're exactly what agents are worst at right now.

### What's actually useful today

Where I've found GPT-4 genuinely powerful is in a tight loop *with a human in it*:

- I describe a small, well-defined task.
- It drafts.
- I review, correct, and decide.
- Repeat.

That's maybe a 2x speedup on some kinds of work, which is huge - but it's a speedup for a developer who knows what they're doing, not a replacement for one. The human is the part that makes the loop converge.

### Where I think this goes

I don't want to be the guy who said the Internet was a fad. Agents will improve, probably a lot. Narrow agents for well-defined jobs - write tests for this function, upgrade this dependency, triage these support tickets - will become normal and useful, likely soon.

But "autonomous developer that builds and maintains your product" requires solving judgment, context, and accountability, not just generating more code faster. That's a much harder problem, and anyone who tells you it's eighteen months away is probably selling something (possibly a course on prompt engineering).

### The skills that matter

If you're a developer worried about all this, my advice: get really good at the things agents are bad at. Understanding the business. Talking to users. Designing simple systems. Reviewing code critically. Knowing which of five plausible answers is actually right.

Those skills were already what separated senior developers from everyone else. AI just made the gap more visible.

**An agent can loop forever. Only you know when you're done.**
