<!-- {"created_at": "2024-05-29"} -->
## Glue on Pizza: The Gap Between Demo and Product

Two weeks ago Google rolled out AI Overviews to everyone in the US: AI-generated answers at the top of search results. This week, the Internet is having a field day. Asked how to keep cheese from sliding off pizza, it suggested adding some non-toxic glue to the sauce - apparently sourced from a joke Reddit comment from years ago. Asked how many rocks to eat per day, it cheerfully recommended at least one, sourced from a satirical news site.

It's funny. It's also the single best illustration I've seen of the most important problem in AI products right now.

### Google is not bad at AI

Let's be fair. Google has some of the best AI researchers on the planet. Their models are excellent. This isn't a failure of intelligence, it's a failure of *product engineering*: taking a powerful but unpredictable technology and putting it in front of hundreds of millions of people, on every possible query, including the weird ones.

That's the gap between a demo and a product.

### The demo/product gap

**A demo has to work once.** You choose the input. You rehearse. You show the best result. If it fails, you try again before you hit record.

**A product has to work every time, for everyone.** Strangers type things you never imagined. Some of them are trying to break it. Some of the content it reads is satire, or spam, or a ten-year-old joke. And every failure is public, screenshotted, and shared.

With normal software, the gap is mostly about edge cases and scale, and we have decades of practice closing it: tests, QA, staged rollouts. With AI, the gap is much wider, because the system's behavior is probabilistic. It doesn't fail on specific, reproducible inputs that you can write a test for. It fails *sometimes*, in creative ways, on inputs you'd never think to check.

In April we saw a hardware version of the same story, when the long-awaited AI pin finally shipped and the reviews were brutal. Amazing in the launch video; frustrating on your shirt.

### How to actually ship AI features

I'm building with these models every week now, and I'm more excited about them than ever. But shipping them well requires a different discipline. Here's what I've learned:

**1. Build an evaluation set before you build the feature.** A list of real inputs (including nasty ones) and what a good output looks like. Run every prompt change and model change against it. This is the AI equivalent of a test suite, and almost nobody has one.

**2. Constrain the problem.** The narrower the task, the more reliable the model. "Summarize this support ticket in one line" works far better than "answer any question about anything".

**3. Control the sources.** A lot of AI failures are really *retrieval* failures: the model faithfully summarized garbage. Curate what it reads.

**4. Keep a human in the loop where it matters.** Drafts that a person approves are a completely different risk level from answers shown directly to millions of strangers.

**5. Make it easy to say "I don't know."** Design the product so that "no answer" is an acceptable outcome. A model forced to always answer will make things up.

**6. Roll out slowly.** Small percentage, watch the failures, expand. The same thing we do with any risky change - just more so.

### Why this is good news for good engineers

Every AI demo looks incredible. The difference between an incredible demo and a product people trust is unglamorous engineering: evaluation, constraints, monitoring, judgment about where AI belongs and where it doesn't. That's senior engineering work, and it doesn't get automated by the thing it's trying to make reliable.

I keep saying that AI makes experienced developers [more valuable, not less](/blog/the_k_shaped_developer_market). This is a perfect example. Anyone can call an API and get a great answer once. Making it great a million times in a row is a craft.

**Anyone can demo AI. Shipping it is the hard part.**
