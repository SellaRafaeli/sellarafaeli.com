<!-- {"created_at": "2023-11-23"} -->
## Don't Build Your Company on One Model

Last Friday afternoon, OpenAI's board fired Sam Altman. By Monday, Microsoft had announced he was joining them, and almost the entire company signed a letter threatening to follow him. By Wednesday, he was back as CEO and most of the board was gone.

Five days. The most important AI company in the world nearly disappeared over a weekend, and nobody outside a handful of people knew why.

I've seen plenty of takes about governance and boardrooms and AI safety. I want to talk about something more practical: **thousands of startups watched their core supplier almost evaporate, and many of them had no plan B.**

### The new single point of failure

Over the last year, a whole generation of products has been built on top of OpenAI's API. Some are thin wrappers - a nice UI over a prompt. Some are serious products with OpenAI deep inside their core logic. Either way, for many of them, one company's API is the beating heart of the business.

I wrote earlier this year about [SVB as a single point of failure](/blog/svb_and_your_single_points_of_failure). This is the same lesson in a new costume. If your product stops working when one vendor has a bad week, that vendor is a single point of failure for your whole company.

And this vendor just showed it can have a *very* bad week, for reasons that have nothing to do with you.

### The economics were already shaky

Even before the drama, a lot of AI products I see have a quiet problem: the unit economics. Every user action calls an expensive model. If the user pays a flat monthly fee and uses the product a lot, the model costs can eat the whole margin. Prices change, models change, rate limits change - all decided by someone else.

That's not a reason not to build with AI. It's a reason to design for it the same way you'd design for any expensive, external, changeable dependency.

### How I'd build an AI product today

**1. Put a thin layer between your code and the model.** Don't sprinkle API calls through your codebase. Have one place that says "summarize this" or "classify that", and let that one place decide which model and provider to call.

~~~ ruby
def ai_complete(prompt, opts = {})
  provider = opts[:provider] || ENV['AI_PROVIDER'] || 'openai'
  AI_PROVIDERS.fetch(provider).complete(prompt, opts)
rescue => e
  log_e(e)
  return ai_complete(prompt, opts.merge(provider: 'fallback')) unless opts[:provider] == 'fallback'
  nil
end
~~~

Now switching providers - or failing over when one is down - is a config change, not a rewrite.

**2. Test your prompts against more than one model.** There are now several capable models from different companies, plus open models you can run yourself. You don't need to use them all. You do need to know whether your product would still work on one of them.

**3. Keep your value outside the model.** Your data, your workflow, your understanding of the customer's problem, your UI. If the only thing your product does is call a model with a clever prompt, then your product is the model's product, and the model owner can ship it themselves next month.

**4. Know your cost per user.** Measure how much each user costs you in model calls. Cache what you can. Use smaller, cheaper models where they're good enough - they often are.

**5. Degrade gracefully.** If the AI is unavailable, can the rest of your app still work? A product that's 80% useful during an outage beats one that shows an error page.

### Exciting times, boring principles

I'm genuinely excited about what's possible with these models. It's the most interesting shift in software I've seen in a long time. But the principles for building on them aren't new. They're the same ones I've been writing about for years: know your dependencies, avoid lock-in where it's cheap to do so, keep your system simple enough to change, and own the parts of your business that matter.

The models will keep changing. The companies behind them will keep surprising us. Your product should be able to survive both.

**Use the best model. Don't marry it.**
