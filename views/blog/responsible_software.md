<!-- {"created_at": "2014-12-14"} -->

## Responsible Software: Primum Non Nocere

The Internet [still] operates under a 'wild west' rule; more can be exploited than controlled, and the remote nature of e-communication lends itself easily to arbitrary maliciousness of attacks. Most 'users' (aka "people") have at best a rudimentary understanding of how the web operates, yet entrust it with everything and the kitchen sink - their identity, their private documents and photos, their social interaction and positioning, their online bank account. As the web becomes ever more ubiquituous over time, this problem grows: the web is everywhere, and all-encompassing. **Effectively, you have no choice but to use 'the web' for your sensitive data**.

As a user, you can (and should) take reasonable precautions so that you do not use software that leaves you vulnerable. The corollary is that **as a web developer, you should not write software that leaves your users vulnerable**. Your users' security is your responsibility, and compromising them on your site might compromise them everywhere. 

["Primum non nocere"](http://en.wikipedia.org/wiki/Primum_non_nocere) - first, do no harm. This phrase is commonly attributed as a basic precept of the practice of medicine: before anything else, **make sure you do not *harm* the patient**. It might be better to do nothing than something, if that something ends up hurting the user. Er, the patient. 

Standard examples might be credential or identity theft, which enable an attacker to use a user's credentials (obtained from one website with shitty security) on another, more secure website. If a user uses the same (or similar) credentials for his email and website Foo.com, if Foo.com is compromised then so is the user's email. Once your email is compromised, it's quick work to reach your paypal and bank. And that's real money that can be compromised - lives could be hurt. To stress this point, Foo.com has now actively and substantially hurt a user. **It would have been *better* for the user if Foo.com never existed**. 

Web developers should take this into account: **It is your moral responsibility not to hurt the user, above and before any help or services you might be able to provide them**. If your site has a weakness that might hurt users elsewhere, it is your moral obligation to first and foremost protect the user from being hurt outside of your site. Leaving a site with a weakness that enables recovering a user's original password, for example, is, not acceptable: by this simple act, you are risking severe harm to the user, as explained above. You *must* fix the weakness immediately, and consider shutting down your service until you do. You cannot value your brand over a user's life savings. 

TL;DR:
**You wouldn't leave an unsafe bridge, car or elevator for fear of hurting the user - and you shouldn't do the same with a website. You are a professional, and this is YOUR moral responsiblity: Primum non nocere.**
