<!-- {"created_at": "2022-12-28"} -->
## LastPass Got Breached. Passwords Are the Problem.

Right before Christmas, LastPass admitted what many had feared since their incident in August: an attacker stole a backup of customer vault data. The passwords inside are encrypted with each user's master password - but the attacker now has those encrypted vaults and can try to crack them offline, at their leisure, forever. And some fields, like the URLs of the sites you have accounts on, weren't encrypted at all.

If you use LastPass, you've probably spent the holidays changing passwords. I'm sorry. That's a terrible way to spend a vacation.

But I want to step back from the specific incident, because I think it points at something bigger.

### We built a tower of patches

Here is the history of the password, roughly:

1. Every site asks you to make a password.
2. People reuse the same weak password everywhere.
3. Sites get breached, and the reused password unlocks everything.
4. So we tell people to use a unique strong password for every site.
5. Nobody can remember hundreds of random strings.
6. So we build password managers to remember them for us.
7. Which means we put all our passwords in one place.
8. Which is now the single most valuable target on the Internet.
9. Which just got breached.

Every step was a reasonable fix for the previous step. The result is a tower of patches on top of a broken foundation. **The foundation is that every website wants its own secret.**

### I've been saying this since 2016

Back in 2016 I wrote that [your app should not require a password](https://medium.com/@sellarafaeli/no-more-username-passwords-just-use-a-3rd-party-for-authentication-59b12db092a4). Use something the user already has - an email inbox, a phone number, an existing account - and send them a [sign-in link](/blog/simple_secure_sign_in_links) or a code. Then [keep them logged in](/blog/keep_users_logged_in_forever), so they rarely need to sign in again.

Six years later, I'm more convinced than ever. Every password you store is a liability: you have to hash it correctly, protect it, handle resets, rate-limit guessing, and worry about it leaking from every *other* site your users reused it on. Every password your users have to create is friction, and a security risk they'll handle badly.

The simplest password system is no password system.

### Passkeys are the real fix (soon)

The good news: the industry is finally moving. Apple, Google and Microsoft are all rolling out **passkeys** this year - a standard way to sign in using a key stored on your device, unlocked with your face, fingerprint, or screen lock. Nothing to remember, nothing to type, nothing a site can leak that's useful to an attacker, and phishing doesn't work because the key is tied to the real website.

It's early. Support is uneven, the cross-device story is still rough, and most sites don't support them yet. But this is the first time in decades that there's a realistic path to a web without passwords, backed by the companies that make the devices.

### What to do now

**If you're a user:**

- If you used LastPass, change your most important passwords (email first - it's the key to resetting everything else), and turn on two-factor everywhere it's offered.
- Use a password manager anyway. Yes, really. Even after this, it's far better than reusing passwords. Just pick one with a good security track record, and use a long, unique master password.
- Turn on passkeys wherever you see the option.

**If you're building an app:**

- **Don't add passwords to a new app.** Email links or codes are simpler to build and safer to run. Add "sign in with Google/Apple" if your users want it.
- **If you already have passwords,** add passkey support, and consider offering email-link sign-in as an alternative so users can stop using the password.
- **Store as few secrets as possible.** Whatever you don't store can't be stolen.

LastPass did a lot of things wrong, and they deserve the criticism they're getting. But the deeper lesson isn't "pick a better password manager". It's that we need to stop making people manage hundreds of secrets in the first place.

**The best password is the one that doesn't exist.**
