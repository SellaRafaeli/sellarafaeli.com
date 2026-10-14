<!-- {"created_at": "2023-02-16"} -->
## Who Tests the Code Now?

In this round of layoffs, there's a pattern I keep seeing: QA goes first. Manual testers, QA engineers, sometimes entire quality teams. The reasoning sounds sensible in a spreadsheet: developers can write automated tests, and testing is "overhead".

Sometimes that's right. Often, it's a cost cut that gets paid back later, with interest, in production.

### What QA actually did

A good QA person doesn't just "click around". They do something developers are structurally bad at: **they use the product like someone who didn't build it.**

When I build a feature, I know how it's supposed to work. I test the happy path, maybe a couple of edge cases I thought of while writing the code. I literally cannot see the paths I didn't imagine - that's why I didn't handle them.

A good tester will:

- paste an emoji into the name field
- hit the back button in the middle of checkout
- open the app on a five-year-old Android phone
- use it in Hebrew, with right-to-left text
- double-click the "pay" button
- try it as a brand-new user with no data at all

None of that is in my unit tests, because I didn't think of it. Which is the whole point.

### Automated tests are not the same thing

I'm a big fan of automated tests, in moderation. But they mostly answer the question "does the code still do what I *intended*?" They're excellent at catching regressions. They're poor at catching wrong intentions, confusing UX, or the scenario nobody thought of.

You also have to be honest about what automated testing costs. A big end-to-end test suite is a codebase of its own - slow, flaky, and constantly needing maintenance. I've seen teams where more engineering time went into fixing broken tests than into finding actual bugs. That's not quality; that's a hobby.

### What I'd do instead

If your company just cut its QA team, quality didn't stop being someone's job. It became everyone's job, which in practice means it's no one's job unless you're deliberate about it.

**1. Developers own their features end to end.** Including clicking through it, on a phone, before merging. Not as a formality - actually trying to break it.

**2. Test the risky paths automatically, not everything.** Payments, sign-up, sign-in, permissions, anything that loses money or data if it breaks. A few dozen solid tests on those beat a thousand tests on getters and setters.

**3. Do a weekly "break it" session.** Thirty minutes, whole team, using the product as if they hated it. Product managers, designers, the CEO. You will find things. Every time.

**4. Ship small and observe.** Small deploys, good error tracking, a quick way to roll back. Accept that some bugs will reach production, and make sure you find out within minutes, not when a user tweets about it.

**5. Watch real users.** Session recordings (with appropriate privacy), support tickets, and the occasional live user call are the best QA there is. Users find bugs you can't imagine.

**6. Keep the system simple.** Fewer moving parts means fewer places for bugs to hide and fewer combinations to test. Every bit of complexity you avoid is testing you don't need to do. (You knew I'd say that.)

### Or keep one great tester

For a lot of companies, the right answer is: keep one excellent QA person who sits with the developers, owns the test plan for risky changes, and teaches everyone else to think like a tester. One great tester embedded in the team can be worth more than a separate department that receives builds over a wall.

### The bill always comes

Quality is never free. You pay for it either before release (testing) or after (bugs, support, churn, reputation). Cutting QA doesn't remove the cost. It just moves it from a line on the budget to an angry email from your biggest customer.

**Somebody always tests your code. Make sure it's not your users.**
