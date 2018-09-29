<!-- {"created_at": "2014-12-25"} -->

## White-Hat Mini-Hacking

### TL;DR 

I accidentally 'hacked' into a website (a small social network) the other day, using a trivial security exploit. This paper is an explanation of the hack, for educational (read: professional) benefit of others as well, so that they fix their security holes. 

The security breach had two parts, which combined allowed an attacker to trivially capture any user's session on the site, as well as his email and password (to the site). Thus the attacker could try the password against the actual email, and with a bit of luck - capture the user's email (or FB, etc.). Once in control of a user's email, it is trivial to capture his accounts on Paypal, Visa, eBay, etc. 

### Responsible Disclosure 

After discovering the hack I notified the site owners of the problem, and heavily pressured them into fixing it. It took then ten days to fix the issue (and they have, eventually), during which the site remained live.

The 'mini-hack' is really so trivial as to almost not qualify as a 'hack'; however, most web security breaches are such trivial manipulations of well-meaning functionalities. (Again, this one is even more trivial than most.) Considering the danger posed to innocent users by this exploit, its triviality is even more relevant. Pursuant to the site owner's request, I will currently abstain from naming the site itself and will refer to it as `example.com`. The attached pictures may disclose its identity, however. If you have used this site, you should consider the password you used there to be compromised. 

### Nitty-Gritty and Pics

The site is a minor social network to find potential co-founders for your startup. A worthy cause. On the home page we see some example users we can meet via the site - example, Naama Katan. 

![](http://i.imgur.com/d1ZXO5k.png)

We click 'read more' and see her full profile page: description, what she is looking for, participates in the Israeli Woman Entrepreneurship Program... bla bla. We notice the URL is now 

`http://www.example.com/Profile.aspx?id=927&name=Naama`

Is that the user ID exposed there in the URL? That's already a bad sign, though not a security vulnerability quite yet. Naama is presumably user number 927 (give or take) to join this site. 

Let's see if we can work with that... hmmm, looks like we can; here's one example. After signing up for the site, you confirm via email and reach a link that looks like this 

`http://www.example.com/AfterPageLogin.aspx?msgId=4&loc=1&id=1998`

(Hello again, user ID. So now we know `example.com` has about 2,000 users. Not a breach yet, but awkward to have that revealed.) Clicking on that link takes you to a 'welcome, your-name' page. But wait, this looks like a pretty naive link - how did it know who we are? Surely not just by the user ID? What would happen if we change the id that was assigned to us with a different id...? Say, let's try it with Naama's id: 

`http://www.example.com/AfterPageLogin.aspx?msgId=4&loc=1&id=927` (notice the 927 at the end)

![](http://i.imgur.com/tHWcw05.png)

Looks like we're in. From here, effectively we **are** Naama, so we can do whatever we want: read her inbox, send messages in her name, change her details... of course, I would never do that, but you know, theoretically. 

![](http://i.imgur.com/P67MKLC.png)

![](http://i.imgur.com/EXdVrzt.png)

Of course, the one thing we can't do is change her password. Or can we? Let's head over to the 'Edit your profile' page. Ah, the password input is all obfuscated as dots instead of letters. That's good. But let's check the DOM element itself (as appears in Chrome Dev Tools, on the right of this pic):

![](http://i.imgur.com/9Vy9iPq.png)

Hey now, is that the actual password? In clear-text?? Whoa. We can now not only change the password (and shut the original user out of their own account!) but also use this password and test it in other sites - email (which we have, since it's part of the profile), FB, Paypal.... Naama has now not only been compromised on *this* site, but her entire online presence is in jeopardy. Let's hope she does not share passwords between sites, 'cuz if this is her Gmail password, then, well - we own her. 

### Conclusions

1. If you own a site that contains sensitive data of users (foremost, passwords), you have a responsibility towards your users. Your site can suck and that's your problem, but if you are not careful you could actually compromise and hurt your users in a real way. Their money and identity could be stolen and they could get seriously hurt. It is your responsibility to make sure this doesn't happen. (See more on the subject of [responsible software](/blog/responsible_software))

2. The Internet is a scary, broken place. Evil is everywhere. Watch your passwords and be careful. 

Thanks for reading! Comments of any kind are welcome at **sella.rafaeli@gmail.com**.