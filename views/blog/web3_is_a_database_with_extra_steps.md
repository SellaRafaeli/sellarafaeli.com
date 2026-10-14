<!-- {"created_at": "2022-01-19"} -->
## Web3 Is a Database With Extra Steps

Every week someone pitches me a web3 startup. Usually it's a perfectly normal app - a marketplace, a social network, a game - with "on the blockchain" added at the end. When I ask what the blockchain does for the user that a database wouldn't, the answer tends to be some mix of "decentralization", "ownership", and a chart of a token price.

Earlier this month Moxie Marlinspike (the creator of Signal, not exactly a crypto skeptic by temperament) published his first impressions of web3, and I recommend reading it. The short version: he built a couple of dapps and found that almost none of them actually talk to a blockchain. They talk to a handful of centralized API companies, which talk to the blockchain for them. He made an NFT that displayed a different image depending on which marketplace you viewed it on, and the biggest marketplace quietly removed it - and it disappeared from his wallet, too.

So: decentralized, except for the parts that matter.

### What a blockchain actually is

Strip away the marketing and a blockchain is a database with three unusual properties:

1. **Append-only.** You can add rows, never change or delete them.
2. **Replicated by strangers.** Thousands of nodes who don't trust each other each keep a copy.
3. **Consensus is expensive on purpose.** Agreeing on the next row costs real resources, which is what stops anyone from cheating.

That's a genuinely clever design, and it's genuinely useful for one specific problem: *maintaining a shared ledger among parties who don't trust each other, without anyone in charge.* Bitcoin is exactly that problem.

**For almost every other app, those three properties are bugs.**

- Append-only means you can't fix a typo, honor a deletion request, or remove illegal content.
- Replicated by strangers means every write is public and slow.
- Expensive consensus means every write costs money (and sometimes a lot of money).

Compare with the database your app already uses, where a write takes a millisecond and costs approximately nothing:

~~~ ruby
$listings.insert_one(title: 'A nice chair', owner_id: user_id, price_cents: 5000)
~~~

### "But ownership!"

The most common argument is that on web3, users *own* their stuff. Their NFT, their tokens, their identity.

What the user owns is a row in a ledger saying that a certain wallet is associated with a certain token ID. The image, the game item, the account - those live on regular servers, run by regular companies, who can change them, remove them, or go out of business. Moxie's disappearing NFT is the perfect demonstration. You own the receipt; someone else owns the thing.

And when users lose their keys (and normal humans *will* lose their keys), there's no "forgot my password" link. The money is just gone. That's not empowerment, it's a usability disaster that we've rebranded as a philosophy.

### Then why is everyone building it?

Mostly because that's where the money is right now. There is a huge amount of capital chasing anything with a token, and tokens let startups raise money from users directly. Some of the smartest engineers I know are working in this space, and some of them are building interesting things.

But "investors will fund it" is a different statement from "users need it." We've seen this movie before - the dot-com bubble funded plenty of excellent infrastructure, and an awful lot of pets.com.

### My test

Before putting your app on a blockchain, I'd ask three questions:

1. **Is there no one who can be trusted to run the database?** (If there is - you, a bank, a foundation - just use a database.)
2. **Do the users actually want every action public and permanent?**
3. **Would the product still be interesting if there were no token to speculate on?**

If you honestly answer yes to all three, you might have a real web3 product. Congratulations, you're one of very few.

Otherwise, use [MongoDB](/blog/mongodb_is_a_great_general_purpose_db). Or Postgres. I'm not religious. It's faster, cheaper, private by default, and you can delete things.

**A blockchain is a solution. Make sure you have its problem.**
