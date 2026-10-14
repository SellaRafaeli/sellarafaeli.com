<!-- {"created_at": "2021-04-29"} -->
## First-Party Data Is the Only Data Now

This week Apple shipped iOS 14.5, and with it App Tracking Transparency: every app that wants to track you across other companies' apps and websites now has to ask. In a popup. With an "Ask App Not to Track" button right there.

Guess which button most people are going to press.

Facebook ran full-page newspaper ads back in December about how this will hurt small businesses. Ad-tech Twitter is in mourning. And a lot of startup founders I talk to are quietly realizing that their entire growth model was built on data they never actually owned.

### Renting your users from someone else

For a decade, a common startup playbook went like this: buy ads on Facebook, let the pixel and the SDK figure out who converted, feed that back into the ad algorithm, repeat. You didn't need to know your users very well. Facebook knew them for you.

That's renting. And the landlord just changed the terms.

**Third-party data was always a liability masquerading as an asset.** It could be taken away by a browser update, a phone update, a regulation, or a business decision in Cupertino or Menlo Park. Safari has been blocking third-party cookies for a while; Firefox too; Chrome has announced it will follow. iOS 14.5 is just the loudest step in a direction that's been obvious for years.

### What you own: everything that happens on your own site

First-party data is what users do *in your product*, with you. What they searched for, what they looked at, what they put in the cart and then didn't buy, what they came back for. Nobody can popup-block that, because it's not tracking - it's just your app remembering what happened in your app.

The irony is that most apps throw this data away. They only start "knowing" a user after the user signs up. Everything before that - the first five visits, the browsing, the hesitation - is anonymous and forgotten.

I've been arguing for years that you should [give first-class treatment to anonymous users](/blog/give_first_class_personalized_treatment_to_anonymous_users): give every visitor a user record from their first request, keyed by a session id, and keep everything they do. When they finally sign up, you don't create a new user; you just attach an email to the one you already know.

In 2021 that's not just good UX. **It's your data strategy.**

### A minimal version

~~~ ruby
before do
  session[:uid] ||= SecureRandom.uuid
end

def track(event, data = {})
  $events.insert_one(uid: session[:uid], event: event, data: data, at: Time.now)
end

get '/products/:id' do
  track(:viewed_product, id: params[:id])
  # ...
end
~~~

That's it. One collection, one helper. Now you can answer real questions from your own DB: which products do people look at three times before buying? Which landing page brings users who actually stick around? What did this user look at before they emailed support? No SDK, no pixel, no permission popup - because you're not following anyone around the Internet. You're paying attention in your own store.

### The rules of the road

A few principles, to stay on the right side of both the law and your users:

- **Only collect what you'll use.** Data you don't use is just risk with a storage bill.
- **Keep it in your own house.** Don't ship it to fifteen analytics vendors "just in case". Every vendor is a potential leak and a GDPR question.
- **Be useful with it.** Personalization the user can feel ("you were looking at this yesterday") builds trust. Creepy cross-site retargeting destroys it. That's literally what this popup is about.
- **Let users see and delete it.** If you'd be embarrassed to show a user their own data, you shouldn't have it.

### Build a relationship, not a profile

The ad-tech world is panicking because it built an industry on watching people who didn't know they were being watched. That era is ending, and honestly, good riddance.

The businesses that will do fine are the ones that already had a relationship with their users: an email list people actually open, an app people actually come back to, a product that gets better the more you use it. That was always the real asset.

**Stop renting your users. Get to know them.**
