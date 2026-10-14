<!-- {"created_at": "2021-01-18"} -->
## Keep Users Logged In Forever

Here's a small UX crime that almost every web app commits: logging users out.

You open an app you use every week. "Your session has expired. Please log in again." Why? What happened? Nothing happened. You went to sleep. The app decided that sleeping is suspicious behaviour, and now you have to go find your password (or your phone, or your email) to prove you're still you.

**Unless you are a bank, your users should stay logged in until they ask to leave.**

### Why do apps log people out?

Mostly, because somebody once read that short sessions are 'more secure' and nobody ever revisited it. The default session lifetime in your framework was set by someone who didn't know your product, and it stuck.

The argument goes: if somebody steals a session token, a short expiry limits the damage. True. But think about who is actually stealing session tokens from your recipe-sharing app. In practice, the realistic threat is a shared computer, and the realistic mitigation is a "log out" button - which the person on the shared computer can press.

Meanwhile, the cost of short sessions is paid by *every user, every time*. Each forced login is friction, and friction is churn. Some percentage of users who get bounced to a login screen simply don't come back. You're trading a theoretical security gain for a very real retention loss.

### What 'forever' looks like

The implementation is boring, which is the point. In Sinatra:

~~~ ruby
ONE_YEAR = 60 * 60 * 24 * 365

use Rack::Session::Cookie, key: 'session', expire_after: ONE_YEAR,
                           secret: ENV['SESSION_SECRET'], same_site: :lax, secure: true
~~~

And then make it actually forever by sliding the expiry: every request re-issues the cookie, so as long as the user shows up at least once a year, they never see a login screen again.

Three things make this safe enough for most apps:

**1. Revocable sessions.** Store a `session_version` (or a list of active session ids) on the user. If the value in the cookie doesn't match the DB, the session is dead. Now you can offer a "log out of all devices" button, and you can kill every session server-side when a user changes their email or reports something fishy.

~~~ ruby
before do
  @cu = $users.find(_id: session[:user_id]).first if session[:user_id]
  @cu = nil if @cu && @cu['session_version'] != session[:session_version]
end
~~~

**2. Re-authenticate for scary actions, not for everything.** Changing the account email, deleting the account, withdrawing money - ask for a fresh login link then. Reading your own dashboard? Just show it.

**3. Use proper cookies.** `HttpOnly`, `Secure`, `SameSite`. This is free and it removes most of the ways tokens get stolen in the first place.

### What about JWTs?

I [wrote about JWT sessions](/blog/simple_sessions) a while ago and I still like them for simple setups. But a pure JWT can't be revoked without a server-side check, which is exactly why people give them short expiries and then build a 'refresh token' dance on top. If you're going to keep a server-side check anyway (and for forever-sessions you should), a plain signed cookie with a version number is simpler. Fewer moving parts, same result.

### And while we're at it: no passwords

Forever-sessions pair beautifully with [passwordless sign-in links](/blog/simple_secure_sign_in_links). The user logs in once from their email, and then you leave them alone. They never have to remember anything, and you never have to store a password hash. The rare time they get a new device, they click a link in their inbox.

### The store clerk test

A good shop remembers you. It doesn't ask for your ID every time you walk in, it doesn't forget you because you went home for the night, and it definitely doesn't make you re-introduce yourself because it's been "inactive for 30 minutes". I've argued before that you should [treat even anonymous users like regulars](/blog/give_first_class_personalized_treatment_to_anonymous_users). The least you can do is not forget the ones who already told you who they are.

**Let people stay. They'll press "log out" when they want to leave.**
