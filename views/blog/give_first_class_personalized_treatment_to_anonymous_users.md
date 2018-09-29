## Give First-Class, Personalized Treatment to Anonymous Users

Websites should should give users a personalized treatment whether or not they 'signed up' and authenticated themselves (using email, FB, etc). You can and should remember a user and their behaviour from the moment they access your site. A good store clerk will remember the same customer returning the next day - 'ah, hello, you were looking for a backpack for about 50 dollars, right?'

This is best achieved by treating every human user as a 'user' rather than only those that authenticated themselves. For example, assign each session some unique (unguessable) GUID. (Many frameworks will do this for you.) This GUID is now the primary identifier we have for this user, and we can use it to store and reference the user's behavior. We can now give a personalized treatment, collect personal info (name, preferences), store 'favorites', allow purchases, and so on, without the friction of 'creating an account'. You should persist this session (with a cookie or other client-side storage, including on an app).

The implementation might be (conceptually) to check if this is a known user, and not, create one (pseudo-code): 

~~~ruby
before do
  session[:guid] ||= SecureRandom.uuid 
  @current_user    = Users.find_one(guid: session[:guid]) || Users.new(guid: session[:guid])
end
~~~ 

If the user ever chooses to authenticate (using email, FB, etc.), that should not create a new user, but just add information to what we already know about *this* user (their behaviour until now). This echos the offline world better - I frequent many stores which know me personally despite never having 'signed up' explicitly. Whenever I do 'sign up', the store picks up from what they already know about me, not from scratch. 

The implementation may vary, but one could advocate a Users table (or collection) with every single user that ever used the site. Effectively this would create a 'user' row for every session - which is closer to describing the real world than a 'user' for every user that gave their email (or phone, or FB). 

Handling such a huge Users table might be hard (Although a single MySQL table or MongoDB collection should suffice for first 10M users.); one mitigation might be only (for example) only creating the row once the user has actually signed on (and managing their history client-side until then). This moves the burden from the DB to the code. Another problem is since you will be tracking every single action (since you are not ignoring anonymous actions), it is harder to use caching. Other problems might surface as well - this indeed might be non-trivial to implement at scale, but as our tools grow stronger, so does the level of service we can and should give. Personalized treatment without sign-up should be that. 

Most users predominantly use a single device, or two devices at most. There is a very good chance a user will be using your website from a single device, and will be the only user from that device. This means a persistent session on a device is a very good approximation for a user, and can be used as such, up until the user authenticates themselves (using email, FB, etc., if ever). 

It is noteworthy to point out this eschews Rails' (et al.'s) ubiquitous `if current_user` blocks, which is good since this code is semantically wrong: 

There is always a user, and we can always treat them personally, even if we do not know their email.