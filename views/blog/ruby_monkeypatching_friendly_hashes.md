<!-- {"created_at": "2014-11-24"} -->

## Friendly Ruby Hashes

Let's hack Ruby and **make all hashes 'with indifferent access'**. To the monkeypatching-mobile! 

In Ruby, sometimes you access a hash with a symbol key when you should have used the same key as a string. This is annoying. Clearly the best practice is never to have the same key as both a hash and a string anyway (that would muy confusing), so why can't you just access the hash with 'indifferent' access?

You could use active_support's [HashWithIndifferentAccess](http://api.rubyonrails.org/classes/ActiveSupport/HashWithIndifferentAccess.html) or [Hashie](https://github.com/intridea/hashie) or similar libs. These are cool, but cumbersome: you need to install the appropriate gems, and make sure that every time you're dealing with a hash, you're actually dealing with a hash that has been wrapped by the gem, since your native hashes will fail. This means verbose `HashWithIndifferentAccess` declarations all over the place, instead of Ruby's usual sweet minimalism. (Internally using only strings, they also both have issues such as `wrapped_hash[:name]="Joe"; hash.keys.include?(:name) # false. Wut?`) 

But the core issue is the minimalism. The ideal behavior (IMHO) would be ruby handling **any** hash natively "with indifferent access" (at least for the most common get/set operations). No more "Did we set that property as a string or as a symbol?" and no more "Is this a regular hash or one with indifferent access?" **Hashes should all be with indifferent access**. 

Thankfully, Ruby is awesome enough to allow you to go nuts bashing up its internal native methods. This is of course extremely dangerous which is naturally why you should definitely do it (as a learning experience, at the very least). It is also a fun exercise (how do you redefine 'get' without using 'get'?).

Well, here is one solution:  

~~~ ruby
class Hash
  def [](key)
    value = (fetch key, nil) || (fetch key.to_s, nil) || (fetch key.to_sym, nil)     
  end

  def []=(key,val)
    if (key.is_a? String) || (key.is_a? Symbol) #clear if setting str/sym
        self.delete key.to_sym
        self.delete key.to_s        
    end
    merge!({key => val})
  end
end
~~~

What have we done here (from an API point of view)? Run this code anywhere/time in your app, and now **all hashes are natively with indifferent access**. Specifically, getting with [] will return the value for both string or symbol, and setting with []= will *replace* the value for both string and symbol, leaving the last set key as the exact key. So:

```ruby
user = {name: 'Joe', 'age' => 20} #literal hash with both symbols and strings as keys
user[:name] == 'Joe'  # duh
user['name'] == 'Joe' # cool!
user['age'] == 20     # duh
user[:age] == 20      # cool!

user['name'] = 'Bob'  # replace symbol with string
user[:name] == 'Bob'  # cool!
user[:age] = '25'     # replace string with symbol
user['age'] == '25'   # cool!
user # => {"name"=>"Bob", :age =>"25"} 
```

That's the gist of it. A couple of extra points:

Since we replace the key with the last type set, this means external libraries will not be surprised:

```ruby
user = {'name' => 'Joe'}
user[:name] = 'Bill'
user.keys.include?(:name) # true. Better than Hashie and ActiveSupport. However, we still grant native access using 'fetch' (actually, this is exactly the opposite of Hashie, which does support "fetch" but does not support .keys. )
```

We can also still use keys that are neither strings nor symbols (say, modules):

```ruby
module Foo
end

user = {Foo => 123}
user[Foo]            # 123 
user[:Foo]           # nil
```

Most importantly, however, **we no longer have to worry about wrapping our hashes**. Every hash is now a friendly hash. 

Thanks for reading! Please address any comments to **sella.rafaeli@gmail.com**. *(Nov 2014)*