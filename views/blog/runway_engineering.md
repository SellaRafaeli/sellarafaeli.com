<!-- {"created_at": "2020-06-10"} -->
## Runway Engineering: Build Like the Money Is Running Out

It's June 2020. I'm writing this from our apartment in San Francisco, where we have been sheltering in place since March. Every founder I know got some version of the same memo this spring - Sequoia literally titled theirs "Coronavirus: The Black Swan of 2020" - and the message was always the same: cut costs, extend your runway, and assume the next round is not coming.

Most of the advice has been about headcount and office leases. Fair enough. But almost nobody is talking about the other burn rate: **your architecture.**

### Your stack is a subscription to complexity

Every piece of a modern stack costs you twice. Once on the invoice, and once (much more) in developer hours to understand it, configure it, upgrade it, debug it at 2am, and onboard the next person onto it.

Count them. The hosted database. The second database for 'analytics'. The queue. The cache. The search cluster. The container orchestration. The three SaaS dashboards for logs, errors and metrics. The auth vendor. The feature-flag vendor. The CI pipeline that takes 25 minutes. The 'serverless' functions nobody remembers deploying.

I have personally seen pre-product-market-fit startups with a dozen services, three queues, a Kubernetes cluster and a "platform team". For an app with forty users. It's insane. In the good times nobody asks, because there is always another round coming. In a crisis, it's the first thing a CTO should ask.

**Complexity is a loan. You pay interest on it in every single sprint.**

### The Runway Stack

Here's what I'd do if I knew I had 18 months of money and no promise of more. (Spoiler: it's also what I'd do if I had 10 years of money.)

**1. One repo, one app, one database.** A monolith. Microservices solve an organizational problem - many teams stepping on each other's toes - and you don't have many teams. You have Dave. Let Dave ship.

**2. Boring tech, blocking IO.** Pick a mainstream language and framework where `user = Users.find(id)` returns a user, not a promise of a user. I've written about [why I think Node is a poor default for startups](https://medium.com/@sellarafaeli/are-you-sure-you-need-node-ec298dd62e30); the short version is that code you can read quickly is code you can change quickly, and changing quickly is the only advantage a small startup has.

**3. Fewer dependencies.** Every package is [some dude's code](/blog/dependency_madness) running with full privileges in your app, and every one of them will need upgrading, usually on the worst possible day. Before `npm install`-ing a library, ask whether you need it or just want it.

**4. Do it in-process before you buy a service.** Most startups don't need a job queue. They need a loop that runs every hour. In Ruby, that's one gem:

~~~ ruby
# Gemfile: sinatra, mongo, rufus-scheduler. That's the stack.
scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
  $users.find(trial_ends_at: {'$lt' => Time.now}, trial_email_sent: nil).each do |user|
    send_email(user['email'], 'Your trial has ended', erb(:trial_ended))
    $users.update_one({_id: user['_id']}, {'$set' => {trial_email_sent: true}})
  end
end
~~~

No queue service. No worker fleet. No extra bill. It runs inside your web process, it's in the same repo, and anyone on the team can read it in ten seconds. (Caveat: if you run more than one server, make sure only one of them runs the scheduler, or you'll send every email twice. That's a one-line environment flag, not a reason to adopt a distributed job system.)

**5. Write the 20 lines.** "Don't reinvent the wheel" is good advice for wheels. It's terrible advice for 20-line problems. You probably don't need an auth vendor charging you per monthly active user - you need a random token, an email, and an expiry time. [That's the whole thing.](/blog/simple_secure_sign_in_links) Same goes for sessions, admin panels (a spreadsheet works great), and most 'integrations'.

**6. Fewer developers, more senior.** One experienced developer who has built this exact kind of app five times before will outrun a team of five juniors with daily standups, a Jira board and a Slack channel per feature. Senior developers are expensive per hour and cheap per feature. In a downturn, you should be buying features, not hours.

**7. Delete things.** Look at your analytics. The feature that 2% of users touched last month is not a feature, it's a maintenance cost. The best code is no code; the second-best code is deleted code.

### "But will it scale?"

To ten million users? Probably not without changes. But your company won't scale to ten million users either if it runs out of money at forty thousand. A single well-indexed MongoDB (or Postgres, I'm not religious) on a decent server will happily carry you much further than most startups ever get. Computers are fast; humans are slow - optimize for the humans.

And if you do hit real scaling problems, congratulations: that is what the industry calls "a good problem to have". You'll be solving it with revenue, with a clear understanding of exactly where the bottleneck is, instead of solving it speculatively on day one with investors' money.

### Crisis is a filter

The 2008 crash gave us a generation of companies that were born lean because they had no choice. I suspect 2020 will do the same. The startups that come out of this year alive won't necessarily be the ones with the best tech. They'll be the ones that were still around when things got better.

So simplify. Merge the services. Drop the dependencies. Delete the dead features. Make the whole system small enough that one person can hold it in their head.

**Build like the money is running out. It always is.**
