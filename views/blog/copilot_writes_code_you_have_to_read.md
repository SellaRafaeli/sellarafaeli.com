<!-- {"created_at": "2021-07-08"} -->
## Copilot Writes Code You Have to Read

GitHub announced Copilot at the end of June: an "AI pair programmer", built on OpenAI's Codex, that sits in your editor and suggests whole lines and whole functions as you type. You write a comment like `// parse the date and return the day of the week`, and it writes the function. The demos are genuinely impressive. My Twitter feed is split between "programmers are finished" and "this is a toy".

It's neither. But I think most people are focusing on the wrong question.

### Writing code was never the bottleneck

If you've been doing this for a while, you know that typing is the least of it. Most of a developer's time goes into **reading** code - understanding what's there, figuring out why it was written that way, working out what will break if you change it. Writing the new lines is the fun 10% at the end.

Copilot makes the 10% faster. It does nothing (yet) for the 90%. Worse: it potentially makes the 90% bigger, because now there's more code, written faster, by an author who can't explain why it did what it did.

**Code you didn't write is code you have to read.** That's true of code from Stack Overflow, from a colleague, from a library - and now from a language model.

### It's a dependency you can't see

I've been grumpy about [third-party dependencies](/blog/dependency_madness) for a long time: every package you install is some dude's code running inside your app, with your privileges, and you probably never read it.

Copilot is the same thing, minus the package boundary. Instead of importing some dude's code, it pastes a statistical average of thousands of dudes' code directly into your file, where it looks exactly like your code. No version number, no changelog, no author to ask. It might be subtly wrong. It might be the kind of wrong that was common in its training data (SQL built with string concatenation, anybody?). It will be *confidently* wrong, which is the worst kind.

The responsibility doesn't move. If it ships under your name, it's your code.

### Where I think it'll genuinely help

I'm not a hater - I'm going to use it. Some obvious wins:

- **Boilerplate.** The test setup, the config file, the tenth near-identical route handler. Stuff you know exactly how to write and just don't want to type.
- **Unfamiliar APIs.** "How do I do X in this library I use twice a year" - it'll often get you 80% of the way faster than the docs.
- **Translation.** This regex, but in Ruby. This loop, but in SQL. Rewriting the same idea in another syntax is exactly what pattern-matching is good at.
- **Rubber-ducking.** Writing a clear comment of what you want, and seeing what it suggests, is a surprisingly decent way to check whether you know what you want.

### Where it'll hurt

- **Junior developers who can't tell good suggestions from bad ones.** The experienced developer reads the suggestion and says "nope, that's an N+1 query". The junior accepts it because it compiles. Copilot amplifies the skill you already have, in both directions.
- **More code, less design.** If generating code is free, the temptation is to generate more of it instead of stepping back and asking whether this code should exist at all. The best code is still no code.
- **Licensing questions** that nobody has good answers to yet. If it reproduces a chunk of GPL code verbatim, whose problem is that? (Spoiler: probably yours.)

### My prediction

This is the beginning of something big, not the end of programming. Tools like this will get much better, quickly, and in a few years writing code without one will feel like writing code without autocomplete.

But the job was never "type characters into a file". The job is understanding a problem well enough to describe a solution precisely - and then owning that solution when it breaks in production. That part isn't getting automated any time soon, and it's the part that makes senior developers worth what they're paid.

**Let the robot type. You still have to think.**
