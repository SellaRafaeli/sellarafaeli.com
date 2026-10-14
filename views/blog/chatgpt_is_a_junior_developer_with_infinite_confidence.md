<!-- {"created_at": "2022-12-08"} -->
## ChatGPT Is a Junior Developer With Infinite Confidence

Last week OpenAI released ChatGPT, and the Internet lost its mind. A million users in five days. Everyone's feed is full of screenshots: it writes poems, explains quantum physics, drafts cover letters, and - the part that matters to me - writes code.

I've spent a few evenings with it. Here's my take, as someone who [wrote about Copilot](/blog/copilot_writes_code_you_have_to_read) last year.

### It's genuinely impressive

Let me get this out of the way: this is a big deal. I asked it to write a Sinatra route that takes a CSV upload, parses it, and inserts the rows into MongoDB. It did it in seconds, with reasonable code and an explanation. I asked it to explain a gnarly regex. It did, clearly. I asked it to convert a chunk of JavaScript to Ruby. Mostly right.

Copilot felt like smart autocomplete. This feels like talking to someone. You can describe what you want in plain English, ask follow-up questions, tell it what it got wrong, and it adjusts. That conversational loop changes everything about how useful it is.

### And it's confidently wrong

Then I asked it about a library function that doesn't exist. It explained, in detail and with an example, how to use the nonexistent function. I asked it to fix a bug, and it rewrote the code in a way that looked great and introduced a different bug. When I pointed that out, it apologized politely and introduced a third one.

It never says "I don't know". It doesn't seem to *know* that it doesn't know.

**It's the most productive junior developer I've ever worked with, and it has infinite confidence and no judgment.**

That's actually a pretty precise description of how to use it. You wouldn't let a brand-new junior push to production without review. You also wouldn't refuse to work with one. You'd give them well-defined tasks, check their work carefully, and learn what they're good at.

### What it's great at

- **First drafts.** Boilerplate, scaffolding, the first version of a script you'll then fix. Faster than starting from a blank file.
- **Explaining things.** Paste in some code you don't understand, or an error message, and ask what it means. It's often excellent at this, and it never gets tired of follow-up questions.
- **Translation.** Between languages, between formats, between "what I mean" and "the SQL that does it".
- **Rubber duck debugging.** Explaining your problem to it clearly is half of solving it, even when its answer is wrong.
- **Writing things developers hate writing.** Docs, commit messages, the email to the client explaining the delay.

### Where it'll hurt

- **When you can't evaluate the answer.** If you don't already know enough to spot the mistake, you'll ship the mistake. This is the big one.
- **Security and correctness.** It produces plausible code, and plausible is not the same as correct. Plausible-but-wrong is the most dangerous kind of wrong.
- **Atrophy.** If you never struggle through a problem yourself, you never build the intuition that lets you judge the answers. Juniors especially should be careful here.

### So, are developers finished?

No. But the job is going to shift, the way it has with every major tool.

The value of *typing code* just went down a lot. The value of *knowing what good code looks like* just went up. The value of understanding the problem, the users, the tradeoffs, the system as a whole - and taking responsibility when it breaks - didn't change at all. If anything, it's now the main thing.

I think in a few years every developer will work with something like this all day, and it'll feel as normal as Google and Stack Overflow do now. The developers who do best will be the ones with the judgment to use it well. That judgment comes from experience, which, conveniently, is the one thing it can't give you.

**Use the robot. Review the robot. You're still the senior developer.**
