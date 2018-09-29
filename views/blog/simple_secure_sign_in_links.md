# Simple, Secure Sign-In Links

We previously explored why [you should use only a 3rd-party authentication](https://medium.com/@sellarafaeli/no-more-username-passwords-just-use-a-3rd-party-for-authentication-59b12db092a4#.4hapiv7p7). 

Let's see how dead-simple and robust this would be by constructing an email sign-in link.

Remember, our use case is:

1. User wants to login.
2. We email user a link.
3. User clicks the link.
4. We verify this link was recently created by us for this email. 

Of course it must be secure and simple. 

~~~ ruby
require 'json'; require 'digest'; require 'date';
# APP_SECRET = 'my_secret'

def generate_link(email) 
  time  = Time.now.strftime("%Y-%m-%d")
  token = Digest::SHA256.base64digest(email + time + APP_SECRET)
  link  = "http://app.com/token_login?email=#{email}&time=#{time}&token=#{token}"
  # send link to email. 
end

def check_token(data)
  email, time, token   = data['email'], data['time'], data['token']  
  real_token           = Digest::SHA256.base64digest(email + time + APP_SECRET)
  within_7_days        = Date.parse(time) > Date.today - 7 
  (token == real_token) && within_7_days && email
end

# http://app.com/token_login?email=foo@bar.com&time=2016-05-09&token=2/7/FKubqJKOzzfECwkEESQ00VwngcrB3GGpJrnGcGI=
get '/token_login' do
  email = check_token(params) # email is now an authenticated user, or 'false'.
end
~~~   

The implementation is:

1. We generate a link for the email. The result should be a link including both the parameters and the hash: 
```http://app.com/token_login?email=foo@bar.com&time=2016-05-09&token=2/7/FKubqJKOzzfECwkEESQ00VwngcrB3GGpJrnGcGI=```. 
Note the email and time are exposed in the URL, but that's OK. 

2. When user clicks on the link, we check the the token is indeed a hash of the email and time and our app secret. Since only we have the app secret, it can't be forged. A user could forge the time/email, but then then token would not be a correct hash. This method also allows us to expire the token after a set amount of time. 

3. If the token is indeed a hash of the email, time, and our secret - we know this is a valid link for this email. 

Notes: 

a. We can add additional parameters to the token hash, if we need to. 

b. The above does not ensure tokens are used only once. If that is desired, a persistence mechanism must be added, e.g. saving tokens via Redis to make sure they are not used more than once.)

So as we can see - it's dead-simple. You can easily craft a secure sign-in link, and by mailing it, the recipient can prove they own that email. 