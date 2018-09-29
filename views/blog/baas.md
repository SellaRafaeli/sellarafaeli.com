I am interested in the concept of building a **BaaS (backend-as-a-service) platform**, where one could easily create, configure and manage a backend for their mobile/web apps, without having to write code or manage any platform. A "Wix for Backends", if you will.

### Abstraction is Good 

AWS abstracts away hardware (IaaS); Heroku abstracts away infra (PaaS); logically we can abstract away the platform (BaaS). 

In every abstraction we lose granularity and gain simplicity or ease of use. Some people need to fine-tune their own hardware / platform / code; for those people, AWS / Heroku / BaaS is not a good fit. For most applications, they all are - most infrastructures and platforms are identical; everyone runs x86 and needs a load balancer. Similarly, most BEs are either identical (users/posts CRUD) or have a BL (business logic) that can be *generalized* and abstracted. 

### DRY

Entrepreneurs that want to create a marketplace for dogs and dog-walkers or a track-my-beer app or "smart fridge" to monitor your milk consumption - anything from the trivial to the enterprise - have BEs they need to set up. I posit the 'correct' approach today is to use IaaS for the infra (goes without saying), PaaS for the platform (not yet consensus, but should be), and, I posit - a configurable BaaS for the logic. 

You'll have some CRUD endpoints, one or more DBs, AuthN-&-AuthZ, emails, push notifs, resource hosting, maybe a CDN, async background workers, cron jobs, a bit of logic. That's 80% of what every BE entails. One can build a generic, configurable SaaS to allow non-BE devs (or lazy/efficient BE devs) to skip the boilerplate BE code and configure it instead of coding it. As RoR's convention-over-config mantra encourages: most apps' BL is, in all honesty, cookie-cutter stuff.

### The Others 

If the reader has been convinced of the merit of BaaS, we can move on to Parse. Parse.com is the biggest name that already proved the product-market fit/demand of the all of the above. It wasn't perfect, but it was clearly a much-needed tool for indie app devs (and others), and a sign of things to come. FB acquired Parse and recently decided to shut it down; while chump change for FB, this is a world of hurt for Parse's users. Future users might be wary of lock-in, but the need is still there. 

Other big names in the same space are Firebase and Kinvey. Both are large and well-funded but are not very dominant. The Israeli reader might be familiar with BackAnd.

* Parse   (founded 2011, acquired by FB in 2013)
* Firebase(founded 2011, acquired by Google in 2014)
* Kinvey  (founded 2010, raised ~10M$)
* BackAnd (founded 2014, raised ~3M$) 

Obviously, these are just the success stories. However, briefly checking out these companies, I believe it is possible to out-execute them. 

### Business Model & Differentiation 

The market is big enough for multiple BaaS offerers (similarly to the Iaas/PaaS space), but variations in the market/product could help set aside a competing product and offer a unique market value. 

#### Main Baas Pain Points

1. **Complex**: It's still a bitch to set it up. 
2. **Unextendable**: If it's successful and you grow, it's hard to customize it; specifically it's quite hard to add customizable BL.
3. **Dangerous**: You're locked-in; if the BaaS shut down - you're fucked. 

#### Ideal Solution from a Customer's Perspective 

1. **Easy**: I (the customer) want to either speak with a human or use a GUI interface to configure my BE. 
2. **Fully Accessible**: I want be able to get direct access to my BE (code and data), and to be able to modify it as I see fit. 
3. **Risk-Free**: I want to be able to leave the BaaS provider and take my BE with me, using my own dev-power to maintain it. 

#1 is a compromise between a SaaS and a services company, and in fact can be two separate sells using the same technology (i.e., sell your services but use this stack to cut costs by an order of magnitude). If you use the correct abstractions, the tech support of today are the generic developers of tomorrow - we seen this trend happen with Wordpress/Wix "website" freelancers.

#2&3 present a slight variance on the traditional BaaS solution; it is halfway between BaaS and "backend-as-a-product". 

#### Proposed Implementation 

1. Use non-devs for the 'human' aspect of #1. Contact a human tech support will build your app for you. 
2. **Run each BE independently on some existing PaaS (e.g. Heroku)**, 
3. By running a user's BE on Heroku, we can allow the user to inject arbitrary code, as their code will be contained within their own process). This is more than just an injected callback; we can give the user partial or complete access to their BE process's code and let them go nuts with it if they really want to.
4. Now that the user's BE is on Heroku, we can also give a complete hand-off and transfer control of the app to the user at any time, giving them completely responsibility and ownership. No danger of lock-in, you can always take your business and data and keep going yourself. 

Notes:

1. Handing off the code to a running BE is not a big step away from having that code exist as a (licensed) open source code. So that's good.
2. PaaS's are expensive. A production-ready app on Heroku should cost no less than about 100 USD(!) a month just to run it (web process, background worker, cron job, DB). Perhaps users should be presented with the option running in a 'shared' context, with an option to migrate their BE out later. (This is reminiscent of 'migrating from Heroku to AWS' stories). 

#### Differentiation Summary

1. **Basic**: same BaaS as other companies (but better, of course!) (free, paid at scale)
2. **Humans** will build/modify it for you. (paid)
3. Optionally run it as a **separate process (still managed by us)**, granting you the ability to inject arbitrary custom code. `rm -rf *` or `while(true)` it if you feel like it. (paid)
4. Optionally, get **complete ownership of your BE**, giving you full and complete control of your new BE. Bid the BaaS farewell and grow your empire. (paid)

### Me

If you are reading this, you probably know me - Sella Rafaeli. If you have constructive feedback or think you would be interested in such a project, hit me up.
