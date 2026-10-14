<!-- {"created_at": "2021-08-26"} -->
## A Marketplace Is Five Collections

I've been building a marketplace again this summer. Sellers list things, buyers find things, money changes hands, everybody leaves reviews. I've built some version of this many times - I even once [wrote about turning it into a product](/blog/snm_as_a_service_product) - and every time I'm struck by the same thing: the core of a marketplace is tiny. It's everything you're tempted to add around the core that gets big.

Here's the whole data model of a marketplace MVP. Five collections.

### 1. Users

~~~ js
{ _id, email, name, created_at }
~~~

Everyone is a user: buyers, sellers, admins. **Don't create separate "buyer" and "seller" tables.** The same person will be both, sooner than you think. A seller is just a user who has a shop.

### 2. Shops

~~~ js
{ _id, user_id, name, slug, description, location, active }
~~~

The seller side. One user, one shop (for now - make it `user_id`, not an embedded field, so that "one user, many shops" is a later migration rather than a rewrite).

### 3. Listings

~~~ js
{ _id, shop_id, title, description, price_cents, images: [], tags: [], stock, active }
~~~

The things for sale. Store money as integer cents. Always. Floats and money don't mix, and you will not enjoy debugging why a total is `$19.999999998`.

### 4. Orders

~~~ js
{ _id, user_id, shop_id, items: [{listing_id, title, price_cents, qty}], total_cents, status, created_at }
~~~

Note that the order **copies** the title and price of each item at the time of purchase. Prices change; what the buyer paid shouldn't. This is one of the few places where denormalizing is not just OK but required.

`status` is a plain string that moves through a small state machine: `pending → paid → fulfilled`, or `→ cancelled` / `→ refunded`. You don't need a library for that; you need a list of allowed transitions and one function that checks it.

### 5. Reviews

~~~ js
{ _id, user_id, shop_id, order_id, rating, text, created_at }
~~~

Tie each review to an order, and only allow one review per order. That's 90% of your anti-spam strategy right there: you can only review a shop you actually bought from.

### That's it

Five collections, each holding its own data and a foreign key, [joined app-side when you need them](https://medium.com/@sellarafaeli/mongo-joins-across-collections-with-ruby-504e3351d278). A shop page is `shops + listings + reviews`. A user's history is `orders + reviews`. MongoDB is fast and humans are slow; for the first many thousands of users, a few small queries per page are nothing.

### What I deliberately leave out

Every marketplace project arrives with a wishlist. Here's what I push to "later", and why:

- **Payments in-house.** Use Stripe (Connect, for paying out to sellers). Do not touch card numbers. Ever.
- **Messaging between buyers and sellers.** Start with an email link. If people use it a lot, that's a signal to build chat. If they don't, you saved a month.
- **Search infrastructure.** A regex on title and tags, with an index, gets you surprisingly far. When it doesn't, you'll know exactly what you need from a search engine.
- **Recommendation engine.** "More from this shop" and "popular this week" are two queries. They are your recommendation engine until you have enough data for anything smarter to matter.
- **Admin panel.** Your admin panel is the database console and, honestly, a spreadsheet export. Build admin UI for the operations you find yourself doing every day, not the ones you imagine.
- **Microservices.** I don't think I need to say this again. [I'll say it again.](/blog/runway_engineering)

### The hard part isn't the code

A marketplace has a famous chicken-and-egg problem: buyers won't come without sellers, and sellers won't come without buyers. That's the real work - going out and getting the first fifty sellers to list, one phone call at a time, and making their experience so smooth they tell their friends.

None of that is helped by a more sophisticated architecture. All of it is helped by being able to change the product quickly, on the same day a seller tells you what's annoying them. Which is exactly what a small, boring, five-collection app lets you do.

**Build the core in a week. Spend the rest of the year on the people.**
