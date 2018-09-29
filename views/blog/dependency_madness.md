<!-- {"created_at": "2018-07-27"} -->
<span class='date'> 27/7/18 </span>
## Dependency Madness

The amount of reliance many web developers have on 3rd-party dependencies is downright frightening. This is especially true in npm ecosystems.

A zeitgeist of using the latest fashionable frameworks and magical libraries, overwariness of 'reinventing the wheel' and 'not invented here' syndrom and general lack of fundamentals leads practically every project to have dozens to hundreds of direct dependencies. Each of these dependencies has its own dependencies, and thus **a medium-sized app can easily and quickly find itself with 1000+ third-party packages imported.** It's insane. 

While often adding a third-party package is the path of least resistance - the accrued weight on the project adds up. Each package (and its own dependencies) add additional lines of code and memory now required by the app. Beyond being merely shoddy craftsmanship (which has been amply discussed, c.f. the left-pad debacle) this pattern is downright irresponsible. **Heavy reliance on 3rd-party code makes both the resource consumption and the security integrity of the app unmanageable, since you are literally now using code which you have no practical way of checking at all.**

In the common case, you are just grabbing something some dude on the Internet wrote and boom! Now it's part of your app. With all of its dependencies -- written by further dudes and dudettes all over the world. So what do all these hundreds of packages now running in your app actually _do_? Nobody knows. Obviously most organizations will not conduct a review of a 3rd-party lib - even orgs with a strict review process on code checkins on their _own_ code. For some reasons, most orgs assume that if somebody else wrote it - it must be perfect. And uncompromised. As well as all of its dependencies. **But what if just one of these packages has a single line of malicious code?**

So now your app has literally thousands of packages running in it. Written by hundreds of developers who you know nothing about. Doing... God knows what. Running in your FE or BE. Executing other people's code. People and code who you now implicitly trust with your data. 

**What is the impact of one of these packages was compromised?** It's generally **game over** for us - we are now running an attacker's code in our app, with full privileges. This is an attacker's paradise. For all the efforts we made to block XSS or CSRF or tab-nabbing or click-jacking, what was the point? We just handed the keys to the attacker and allowed them to run whatever they want. They can `rm -rf` your server. Destroy your database. Copy and send home all sensitive user data. Tokens. Passwords. Everything. 

**What is the likelihood one of these packages was compromised?** If I'm an attacker, injecting a compromised 3rd-party library is a massively cost-efficient attack vector. If I manage to take over a single package - or a single package author - I can now access any project who uses this package, and so on through the dependency tree. An extremely lucrative prize, with a very low bar. To make things _even easier_ for the attacker, they don't even have to 'hack' anything, it would be enough to slip in a malicious line as part of a genuine contribution. Consider that all that would need to be injected is a single obfuscated AJAX call to ship your secrets to the attacker. 

Remember the left-pad debacle, when half the Internet broke because some dude unpublished his library? **Consider what would have happened if the left-pad owner had decided to turn left-pad into malware.** Thanks to left-pad, we have the empirical answer: he would have pwned hundreds of companies. We have seen first-hand that so many organizations are running code that can break - benignly or maliciously - at any time. 

So just consider: how many open-source packages are you running? How many lines of code? How many them are you _sure_ do not contain malware that totally and completely compromises your data?

Some awareness to this issue has prompted custom solutions; services which warn you about **known** vulnerabilities in your dependencies. Github is one prominent tool which does this; Snyk is another example. However, while these are steps in the right direction, they highlight the issue: "3rd-party dependencies" are essentially "some dude's code", running equally with your own code. 

Next time, maybe reconsider importing random code from random people, and reflect if the benefits truly outweigh the risks. 

