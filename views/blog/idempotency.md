<!-- {"created_at": "2014-09-07"} -->

## Idempotency

If you have a BE (back-end) code flow that is complicated and important enough, you'll want it to be *idempotent*. 

An **Idempotent operation** is one that has the same effects whether executed once or any n > 1 times.  An example would be a `Set.add(x)` or `Set.remove(x)'`- obviously these can be called multiple times safely, without having wrongful side effects. An example of non-idempotent operations would be increasing an argument by one, or adding an item to an array. 

**Idempotent operations are important because they allow complex systems to remain fault-tolerant, in that they facilitate easy recovery from corrupted flows.**

Let's examine this with a real-world example we had at [Fiverr](http://www.fiverr.com). At Fiverr I work on the team in charge of the order flow. Roughly, after a user pays for an order (let's assume, ordering a 5$ Gig), we perform the following:
  
  1. *Notate the user has paid.*
  2. *Initiate the order, creating the necessary internal objects.*
  3. *Pass the money from the buyer to the seller (Partially/sometimes this involves external systems or payment vendors, such as Paypal.)*
  4. *Pass the relevant commissiona from the transactions to Fiverr (and Paypal).*
  5. *Update all relevant parties (buyer, seller, internal statistics).*

Naturally, once the successful payment has begun processing, it should finish. Unfortunately, in the wild, things go to shit. Connections time out, databases crash, runtime exceptions fail and halt the process. Suppose a bug we just deployed has caused a bunch of payments to fail in mid-processing - how can we recover?

Even after creating a 're-run' capability for each payment (which is not obvious, but is the correct first step), we're still in a jam. First, make sure internal validations don't give you false negatives to block re-running (e.g. "don't process payments marked as 'begun processing' "). Second, this is where idempotency matters. Suppose we naively re-run the above steps on our failed payment. Every step, depending on the implementation, could introduce corrupt data. For example:

1. *Notate the user has paid* - If the implementation is of the type `user.paid_amount+=5`, then re-running this flow will obviously corrupt the data. 
2. *Initiate the order* - any internal objects will be created twice.
3. *Pass money from buyer to seller*  - doing this twice will obviously have horrendous results, effectively charging the user twice.
4. *Pass commission from transactions to Fiverr/Paypal* - once again, we will be passing the commission twice, incorrectly.

Clearly, this will be terrible. Multiply this by ten thousand (when it rains, it pours) and clearly it is unacceptable. Now, different payments may fail in different steps - sometimes step 1 crashes, sometimes step 3. Sometimes the failure is a 'loud failure' (including a run-time error), sometimes it's a 'soft error', only detectable later. We need a generic method to be able to 'fix' any type of broken, semi-processed payments.

The correct way to handle the above would be to ensure the entire flow is *idempotent*, separately at every level. That is, every level that can fail by itself, should be idempotent, thus ensuring it can be rerun safely. An example implentation would be:

*Notate the user has paid* - `user.paid_for_order(order_id) ? return : user.paid_amount+=5`. Now, we can run this step safely multiple times - safely.

Similar logic would be applied at other steps. Basically, each step would be in charge of checking it has been executed on this particular payment/order, and allow a graceful, no-op continuation if so. So if a payment has failed on step 2 - we just re-run it, and step 1 gracefully no-ops. If a payment has failed on step 4, we re-run it, and steps 1-3 gracefully no-op. The genericity earned allows for an extremely simple method of detecting and handling failures -- any payment that is not successfully marked as having passed all steps, can be 're-run'. (In fact, even successful payments may be re-run, just to be on the safe side, and we are assured no harmful redundant side-effects will occur.) 

**Now that the flow is idempotent, failures at any point are not a problem - we can just rerun the entire flow, knowing it will no-op the steps already taken, and will perform anything not previous executed.** As in the example above, the implementation is straight-forward. 

It's worth pointing out that idempotency is agnostic to whether each step is performed via a function, a class, or a separate service. It also worth mentioning that SQL transactions are not strong enough to guarantee idempotency flow - while SQL is able to guarantee 'all-or-nothing', complex business logic and scale often necessitate spreading a single flow over multiple DBs (some of which might be NoSQL) or altogether external processes, each of which might fail internally. **App-level idempotency, however, insures us from any and every failure - fix whatever failed and just run it again.**

As a side note, this even makes debugging (any flow thus implemented) since you can re-execute the same action over and over, even in production.

For further reading,  see the obligatory and up-to-par [StackOverflow](http://stackoverflow.com/questions/1077412/what-is-an-idempotent-operation) and [Wikipedia](http://en.wikipedia.org/wiki/Idempotence) references. A quick glance is also recommended at the [Wiktionary page](http://en.wiktionary.org/wiki/idempotent), where you can see the etymology - *idem* ("the same") and *potent* (power). Ah, everything makes sense. 

So - idempotency is awesome. Make your important flows re-runnable.  Thanks for reading, comments and questions can be added to the [discussion on reddit](http://www.reddit.com/r/programming/comments/2msn2i/idempotent_flows_and_why_they_matter/) or sent to **sella.rafaeli@gmail.com**. *(Nov 2014)*