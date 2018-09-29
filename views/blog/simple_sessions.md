<!-- {"created_at": "2015-02-05"} -->

## JWT (JSON Web Token) Sessions - Simple and Power

JWT (JSON Web Tokens) is a [wonderful, powerful, and underutilized concept](http://jwt.io/). We'll introduce the concept and see how to use it for incredibly simple, lightweight, I/O-less sessions and authentication with client-side persistence.

## TLDR

1. Encrypt the session and user_id on the server. `JWT.encode({user_id: 123},'secret')`
2. Send encrypted token to the client. `"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9...`
3. Expect it from the client on every call, decrypt it use it for user verification and session data.

Hey presto! Super simple sessions. See full code examples below. 

## Background 

The concept behind JWT is:
1. taking a JSON object (`{user_id: 123}`) and encrypting it into a simple string (`"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjN9.i5QID8gFRia5TpyseGhYAb0rusHUiV_0pW19hRL6LtM"`). 
2. The server gives this token to the client and the client sends it along in subsequent requests. 
3. Henceforth, in any request, the JWT token is supplied. The server decrypts it (back into `{user_id: 123}`) and since the encryption ensures the trust-worthiness of the data, the server can now treat this as authenticated data - this action has been performed by user with id 123. 

The above scheme can be further employed to set any arbitrary data in the encrypted JSON, thus enabling robust stateful sessions (in addition to authentication of the calling user).

This concept is the basis of many client-side session persistence schemes. As a prime example Sinatra's (Rack-based) `session`s [work similarly](http://www.sinatrarb.com/intro.html#Using%20Sessions), but implicitly use cookies. Cookies are awesome but are falling out of fashion as an implicit default in today's multi-client world - your service is often expected to work gracefully with mobile devices, other HTTP-speaking services, and IOT is around the corner. No less importantly, magic sessions which are not understood by the developer leave much to be desired when the underlying implementation is so simple. 

Naturally the decryption is done versus your own server's secret. Naturally, you shouldn't roll your own decryption and [standard JWT libraries exist for standard languages](http://jwt.io/#libraries). Here's an example usage: 

~~~
~$ gem install jwt
Successfully installed jwt-1.2.1
Parsing documentation for jwt-1.2.1
Done installing documentation for jwt after 0 seconds
1 gem installed
~$ irb
2.2.0 :001 > require 'jwt'
 => true
2.2.0 :002 > JWT.encode({user_id: 123},'secret')
 => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjN9.i5QID8gFRia5TpyseGhYAb0rusHUiV_0pW19hRL6LtM"
2.2.0 :003 > JWT.decode("eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjN9.i5QID8gFRia5TpyseGhYAb0rusHUiV_0pW19hRL6LtM",'secret')
 => [{"user_id"=>123}, {"typ"=>"JWT", "alg"=>"HS256"}]
~~~

To recap, the modus operandi of using JSON web tokens for authentication and sessions is:
1. Wrap whatever data you want the client to 'remember', encrypt it, and send it to the client. 
2. Decrypt any JSON token coming from the client and treat its data as representing the authentication and session of the client. 

This scheme is quite simple. It removes the need from the server to manage any user sessions (commonly implemented in an SQL UserSession table or in a Redis server), both in I/O performance and (more importantly) in simplicity. 

## POC 

Let's observe a concrete example of a Ruby web app utilizing JWT for authnetication. The following is a complete web app (assuming you have `gem install`ed `sinatra` and `jwt` gems) - plop the contents in a `hi.rb` file and run `$ ruby hi.rb`.

~~~ruby
require 'sinatra'
require 'jwt'

SECRET = 'my_secret' 

get '/login' do
  params['pass'] == 'foo' ? JWT.encode({user_id: 123}, SECRET) : 'Forbidden'
end

get '/me' do
  JWT.decode(params['token'], SECRET).to_s rescue 'Invalid token' 
end
~~~

This is a complete 10-line web app (man, Sinatra is sweet) supporting authentication of our single user which has an id of 123 and a password of 'foo'. The two routes we support are as follows:

~~~
$ curl "localhost:4567/login?pass=foo" #returns the encoded JSON web token, => "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjN9.OryE6GbM47yM2rZUmhrxlk-dpkYcQI8rrvbQmmPoOpQ". 
$ curl "localhost:4567/me?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoxMjN9.OryE6GbM47yM2rZUmhrxlk-dpkYcQI8rrvbQmmPoOpQ" # [{"user_id"=>123}, {"typ"=>"JWT", "alg"=>"HS256"}]
~~~

As we can see, the first route receives a password, and if correct it returns an encoded state of the user's session, including his authenticated ID. The second route is an example of a route requiring authentication - said authentication is verified from the decryption of the web token, which contains all the data we need. (In this case, we simply return the decypted token's value to the client, so we can see what it looks like on the server).

My, wasn't that easy? 

## Complete Example 

For completeness's sake let's observe a "full" app utilizing said JWT for authentication. To run this you must also `$ gem install mongo`, then throw the following into a 'full.rb' file and hit `$ ruby full.rb`. 

~~~ruby
require 'sinatra'
require 'jwt'
require 'mongo'

$users = Mongo::MongoClient.new.db('sellarafaeli-jwt-tut').collection('users')
SECRET = 'my_secret' 

get '/current_user' do
  JWT.decode(params['token'], SECRET)[0].to_s rescue 'Invalid token' 
end

get '/enter' do
  user = params['user']
  pass = params['pass']
  if (existing = $users.find_one({username: user}))
    if existing['password'] == pass
      JWT.encode({user_id: existing['_id'].to_s}, SECRET)
    else 
      halt 401, "Wrong password"
    end
  else     
    user_id = $users.insert({username: user, password: pass}).to_s
    JWT.encode({user_id: user_id}, SECRET)
  end
end
~~~

We now support a login/signup route (both served by the `/enter`) endpoint. For example we can signup using the following:

~~~
$ curl "localhost:4567/enter?user=foo&pass=222" # eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTRkMzcxM2MwN2NiOWFlODZhMDAwMDAyIn0.40i4R1K3gHqIRB9as-nJ3qatygpeBxZLHEX_Lr787js
~~~

Note this call is idempotent - the first call **created** the user and retrieved his token, but any further identical calls will just retrieve his token. The token is, of course, an encoding of a JSON/Ruby hash containing his user_id. Let's first verify this by hitting the same route again:

~~~
$ curl "localhost:4567/enter?user=foo&pass=222" # eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTRkMzcxM2MwN2NiOWFlODZhMDAwMDAyIn0.40i4R1K3gHqIRB9as-nJ3qatygpeBxZLHEX_Lr787js
~~~

So now we have some giant token - `eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTRkMzcxM2MwN2NiOWFlODZhMDAwMDAyIn0.40i4R1K3gHqIRB9as-nJ3qatygpeBxZLHEX_Lr787js` - which we know the server can use to verify the client. We can verify this ability using the '/current_user' route:

~~~
$ curl "localhost:4567/current_user?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoiNTRkMzcxM2MwN2NiOWFlODZhMDAwMDAyIn0.40i4R1K3gHqIRB9as-nJ3qatygpeBxZLHEX_Lr787js" # {"user_id"=>"54d3713c07cb9ae86a000002"}
~~~

(You probably wouldn't want to externalize this data, but we can see how we can retrieve the user_id.)

As a side note we see that by going over the above code we see that attempting to `/enter` with a wrong user/pass combination will fail, but supplying a new user will signup that user/pass combination. 

### If not cookies, then what? 

Both when receiving JWTs from clients and when delivering the original token to the client - the same token the server expects the client to resend later - we can use multiple channels of delivery.

All of the above *could* be implemented with cookies - that is, you could send and receive your JWT (JSON web token) within a cookie rather than request/response parameters. Indeed, JWT's can be reasonably transported over cookies, HTTP headers, or simply within request params (querystring or post body). In fact, they can also be accepted within all three (["be liberal in what you accept from others"](http://en.wikipedia.org/wiki/Robustness_principle)). They should be administered to whatever the client would be expecting: often cookies when client is a browser, alternatively an explicit parameter in a response to sign-in HTTP request. Some servers may choose to respond in multiple venues (request parameters, cookies, and HTTP headers) and allow the client to choose which one he is most comfortable working with, as it will be the client's responsiblity to persist, secure, and redeliver the token upon future requests. 

## Summary

JWTs are awesome. It is mostly a concept (encrypted JSONs representing client authentication and state, persisted on client), supplemneted by concrete implementations for the en/decryption.

Essentially it is a complete, working, robust authentication scheme with client-side persistence and zero I/O on server, which plays nice with any of which every single line should be comprehensible to the developer. And most importantly - it is dead simple. 

  Thanks for reading! Comments? Fruit baskets? **sella.rafaeli@gmail.com**