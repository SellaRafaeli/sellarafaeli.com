<!-- {"created_at": "2023-05-09"} -->
## Even Amazon Went Back to the Monolith

A blog post from Amazon's Prime Video team is going around this week, and I have been forwarding it to everyone I know with a single smiley face.

The short version: Prime Video had a system that monitors the quality of video streams. They built it the modern way - a distributed architecture of serverless functions and orchestrated microservices, each component doing one small job and passing data to the next. It hit scaling limits, and it was expensive, because shipping all that data between components costs money at every hop.

So they moved it into a single process. A monolith. **Their infrastructure cost dropped by over 90%.** And it scaled better.

That's not a startup with three developers. That's *Amazon* - the company that sells the serverless functions - telling you that their own team got a better result by putting everything in one box.

### This was always the tradeoff

Microservices aren't bad. They're a tool with a specific purpose, and that purpose is mostly organizational: letting many independent teams deploy independently without stepping on each other. If you have hundreds of engineers, that's a real problem worth solving.

But the cost of splitting a system is real and it's paid every day:

- **Every network call is slower** than a function call, and can fail in ways a function call can't.
- **Every hop costs money** in compute and data transfer.
- **Every service boundary is an API** you have to version, document and keep compatible.
- **Every distributed workflow is harder to debug**, because the bug is now spread across five logs in five places.
- **Every service needs its own deploy, monitoring, alerting and on-call.**

For a big org with clear team boundaries, those costs buy you independence. For most companies, they buy you nothing except a bigger cloud bill and slower development.

### How did we get here?

Somewhere in the 2010s, "microservices" stopped being an architecture for specific circumstances and became a signal of seriousness. Real engineering teams have microservices. Monoliths are legacy. Netflix does it this way, and we want to be like Netflix.

So teams of five built systems of twenty services. I've seen it many times. The result is almost always the same: a lot of energy spent on infrastructure, glue, and coordination, and much less on the product. I wrote about it in [Runway Engineering](/blog/runway_engineering), and before that, and I'll probably keep writing about it until I retire.

### The nuance

To be fair, the Prime Video post is about one specific system, not all of Prime Video. They were clear that this was the right choice *for this workload*, and that they still use microservices and serverless elsewhere. That's exactly the right attitude: choose the architecture for the problem, not for the résumé.

Some other honest nuance:

- **Serverless is great for spiky, independent tasks** - a webhook handler, an image resize, a scheduled job. Not for a pipeline that shuffles lots of data between steps.
- **A monolith can be well-structured.** Modules, clear boundaries, separate folders - you can have good separation of concerns without a network in between.
- **You can always split later.** Extracting a service from a well-organized monolith when you actually need it is a normal, manageable project. Merging twenty services back into one is a nightmare. Start simple.

### The rule of thumb

Start with a monolith. Split a piece out when you have a *specific, measured* reason: a part of the system with very different scaling needs, a team that genuinely needs to deploy independently, a component that needs to be isolated for security.

"It's best practice" is not a specific reason. "Netflix does it" is not a specific reason. "It's more modern" is definitely not a specific reason.

As of this week, the strongest argument for this approach comes from the company that sells you the alternative.

**Distribute your system when you must. Not when it's fashionable.**
