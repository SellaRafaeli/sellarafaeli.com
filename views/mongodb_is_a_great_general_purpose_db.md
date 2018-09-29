# MongoDB is a great general-purpose DB

MongoDB is a great general-purpose DB. If you're starting some app and you don't have any specific reason not too, I would strongly suggest considering Mongo as your main DB. There are technical benefits to MongoDB (such as scaling) but these are not as important as the ease of development MongoDB enables.

## 1. No Schema ##

Mongo collections have no schema. This means you can choose whatever properties to assign an object (a document) during runtime. As you iteratively develop a feature, you decide in the code what properties the objects should have - and by virtue of being assigned in the code, the DB is just created. 

This lets you develop faster and more flexibly  - as you can just add a field in the code and it will immediately apply to the DB level. It's as if you had something inferring the schema of the document from the code you wrote. No dealing with schema files, no migrations.

This also allows you to assign individual documents with fields other documents do not have. E.g., perhaps only some `user` objects have an `admin` property, and some `order` objects have a `shipping_cost` property. This maps most cleanly onto the way we think of items in human terms - items do not have a subset of fields. Each item may have unique fields. 

Notably, you **can** enforce a schema using an ODM/ORM but I would advise not to. Having no schema is great. While many fear the looseness this enables, we have seen this looseness 'win' may battles: we used to decry JS as an inferior language, while today it is perhaps the most popular language in the world. JS objects famously have no 'schema', and can have any property at any time. We also used to ship XML (structured content) as a communication protocol, while today the most common format is JSON - objects with no defined schema. MongoDB is simply the same successful method of thinking - at the DB level. Which brings us to the next point.

## 2. JSON format ##

JSON is widely accepted as the lingua franca data exchange format. Web app clients model objects as JSON; HTTP (and other) communication is generally done with JSON; web servers also often model their data as plain JSON hashes. It only makes sense to have the DB match this modeling, and thus you get a single representation of data. For example the following is the data of one user:

~~~js
  {
    _id: 123,
    name: 'Sella Rafaeli',
    age: 31
  }
~~~

This is what the user would like in the client, in the server, over the wire (HTTP), and in the DB. And that's fantastic. Since MongoDB documents are natively (binary) JSON, the interface is smoother. 

<hr/>

## Don't use denormalized (nested) documents ## 

It's important to note I do not advocate using denormalized documents - those are hard to get right. Denormalized documents are effectively a form of caching, which everyone knows is one of the two hard things in CS. You should use a simple normalized representation of your data, same way you would in SQL land. This means a users collection, a posts collection, an orders collection, and so on. You do whatever joins you need in your own code; Mongo's reads are fast enough that that won't be the bottleneck, and when you reach the point that is is - it's time to implement caching mechanisms anyway. 

## The harder parts ## 

The above points stress that fast, flexible development which is easy to reason about and modify. DB choice has many facets and consideration, but IMO the above points out-shine anything else. Writing 'joins' in your own code - usually the largest issue - is something particularly complex to maintain. And if you can manage that, then you get the best of all worlds. 

## Bottom line ##

If you're not sure what DB to use, MongoDB will give you a fast, flexible, JSON-oriented DB that will let you move as fast as you are able to without slowing you down in DB-maintenance.  