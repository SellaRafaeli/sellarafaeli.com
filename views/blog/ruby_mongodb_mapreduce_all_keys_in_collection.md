
We all know Ruby is simply awesome and so is MongoDB. Both are of the Cowboy-Matrix variety, where loose dynamic typing is the norm, and one must learn to inspect his own data structures at all time. 

I like to use Ruby's native MongoDB driver (rather than an ORM/ODM), because I like the lightweight flexibility it gives me. 

In light of both, **here is how to use the Ruby MongoDB native driver to run a MapReduce operation and retrieve all the keys that are present over all documents in a collection.** This can be used to schema analyzing, detecting outliers, and metaprogramming (such as dynamically displaying or querying data by the data's attributes).

~~~ ruby
def mongodb_all_collection_keys(mongo_session, collection_name)
  opts = {
    mapreduce: collection_name.to_s, 
    map: "function() { for (var key in this) { emit(key, null); }}",    
    reduce: "function(key, stuff) { return null; }", 
    out: {inline: 1}
  }
  mongo_results = mongo_session.command(opts)
  keys          = mongo_results.to_a[0]['results'].map { |doc| doc['_id'] }
end
~~~  

Usage:

~~~ ruby
mongodb_all_collection_keys(MONGO_CONN, :users) 
# ["_id", "username", "name", "age", "sex", "country", "date_joined", ...]
~~~

Use it for fun and profit.