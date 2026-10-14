<!-- {"created_at": "2024-08-28"} -->
## Cursor and the End of Typing

Two things happened in the same week this month that tell you where software development is going.

First, Andy Jassy, Amazon's CEO, posted that their internal AI assistant had helped upgrade a huge number of their Java applications to a newer version, saving - by their estimate - about 4,500 developer-years of work. Four and a half thousand developer-years. On the kind of task every engineer dreads: big, tedious, risky migrations.

Second, my entire developer feed seems to have switched editors at the same time. Cursor, an AI-first fork of VS Code, went from "thing a few people use" to "thing everyone's talking about", with some very well-known engineers publicly saying they're now writing most of their code by describing changes in English and reviewing what it produces.

I've been using it too. I think we're watching the end of typing as the core activity of programming.

### What it feels like

Cursor (and tools like it) does something subtle but important: it puts the AI *inside* the codebase instead of in a separate chat window. It knows your files. You select a chunk of code and say "make this handle the empty case", or describe a change across several files, and it proposes a diff. You review it, accept or tweak it, and move on.

The rhythm of the work changes. Less typing, more **describing, reading and deciding**. I find myself thinking more about *what* the code should do and less about the syntax of doing it. On a good day it feels less like writing code and more like directing it.

### This is a big deal

I've been through a few shifts in how developers work: from text editors to IDEs, from no version control to Git, from servers to cloud, from searching docs to searching Stack Overflow. This one feels bigger than any of them.

Amazon's migration number is the important signal. That's not a demo, and it's not a toy project. That's a giant company applying AI to the most boring, most expensive, most avoided category of engineering work - and claiming a result measured in thousands of years of human effort. Even if you discount the number heavily, it's enormous.

**Every company is sitting on a pile of upgrades, migrations, refactors and cleanup that they've avoided for years because it was too expensive. That pile just got a lot cheaper.**

### But somebody has to read the diff

Here's the part I want every developer and every manager to internalize: the work didn't disappear. It moved.

When the AI writes the code, the bottleneck becomes *reviewing* the code. Is this change correct? Does it fit the architecture? Does it introduce a subtle bug in a path the AI didn't think about? Is it the change we actually want? Those questions take experience to answer, and they take attention - which is a real cost, because AI can produce diffs faster than humans can carefully read them.

Amazon's migration didn't run itself. Engineers set it up, reviewed the changes, tested them, and owned the results. The AI did the typing; people did the judgment.

**The new 10x skill isn't typing fast. It's reading fast and reading well.**

### What I'm telling developers

- **Switch to an AI-native workflow now.** Cursor, or whatever comes next. Not as an experiment - as your default way of working. The gap between people who've adapted and people who haven't is already huge.
- **Get great at code review.** Review AI output the way you'd review a talented but unfamiliar contractor's pull request: trust the style, verify the logic.
- **Keep diffs small.** Ask for small changes, review each one. A 2,000-line AI diff is a 2,000-line diff nobody really reviewed.
- **Keep your system simple.** AI works far better in a clean, consistent codebase. All those years of advocating for [boring, simple systems](/blog/boring_techs_best_year)? They just got a new justification.
- **Attack your backlog of boring work.** The migration you've postponed for three years might be a two-week project now.

### What I'm telling companies

The most valuable person on your engineering team is now the one who can direct AI effectively and review its output critically. That's mostly a description of a senior developer. Give those people the best tools money can buy, and let them loose on the work you've been avoiding.

**Programming is becoming less about writing code and more about knowing what good code is. That's always been the senior part.**
