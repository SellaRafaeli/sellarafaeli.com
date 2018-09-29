<!-- {"created_at": "2014-11-29"} -->

## Monads - An Easy Explanation 

So you've heard about Monads and read (a lot) and still can't understand what the hell anyone is talking about. Let's try to fix that with a totally informal explanation that will at least get you to understand the important parts of what a monad is, if not the formal definition or implementation. 

**Monads are a way to abstract flow control** in your code, supplying both logical abstraction and syntactic sugar. 

That's it. **Abstraction of flow control between functions is useful** when you've got many different moving pieces (actions, functions) that interact with each other, and each has a lot of internal 'plumbing' in order to take care of exceptions. 

If you have dealt with higher-order functions, that's exactly what we're talking about - using a 'Monad' means using an external construct to define the relationships between actions, to abstract away the implementation of how these actions relate to each other. 

This is best demonstrated in JavaScript, which is both a very accessible language and one which supports heavy functional programming relatively easily. 

### Example in JavaScript - Your First Monad

Let's try a simple(-ish) concrete example with JS (or, skip down to see the end result, which stands for itself).

Imagine we have an object: 

```js
joe = {money: 6}
```

Now let's define a bunch of functions that deal with that object. Suppose we are a bank, running a series of operations on that user's money: mutiply it by 2, check if higher than 10. 

```
function mult2(x) { return x * 2 }
function isExtreme(x) { return x > 10 }
```

Now we can use these functions, separately or together:

```js
mult2(joe.money) // 10
isExtreme(joe.money) // true
isExtreme(mult2(joe.money)) //false
````

Of course, in real life, we'll need some error-checking. 

```js
function mult2(x) { 
  if (x>0) return x * 2 
  else return "Illegal"
}


function isExtreme(x) { 
  if (x>0) return x > 10
  else return "Illegal"
}

isExtreme(joe.money) //false
isExtreme("bla") // "Illegal". Good. 
```

We might also want to propogate the errors more intelligently rather than just throwing 'Illegal'. Like, maybe the following:

```js
function mult2(x) { 
  if (x>0) return x * 2 
  else return "Illegal input for mult2 -> "+x
}


function isExtreme(x) { 
  if (x>0) return x > 10
  else return "Illegal input for isExtreme -> "+x
}

isExtreme(mult2("foo")) //"Illegal input for isExtreme -> Illegal input for mult2 -> foo"
```

Hmmm, this is already something showing signs of repetition. As we add more functions - mult3, add4, etc - we'll see ourselves repeating our 'plumbing' and error-handling. We also see that concatenating the function calls is becoming slightly unwieldly. 4 function calls might look like:

```js
result = isExtreme(divide4(add1(mult2(x))));
```

**Not super fun to maintain.** We'd also have to handle the 'plumbing' for each one, wouldn't we. That's a bit nasty and repetitive. Let's abstract that away by using a (pseudo) Monad, a mini-library to abstract the relations between functions. Concretely, we will aim to allow the application writer to define a list of functions to run on the input, as so:

```js
monadRun([mult2, add1, divide4, isExtreme], 100);
```

This is important because the main benefit from Monads is supposed to be code that's more readable and maintainable. 

We will also define that if any function fails, we will want to carry over the failing message (and not crash), without having to define this error-handling plumbing in each function. The following code block is the monad's *implementation* which is **not** necessary to understand in order to use it (and in order to understand what the heck a monad is). 

```js
function funcName(fun) { //helper func to define the function's name. 
  var ret = fun.toString();
  ret = ret.substr('function '.length);
  ret = ret.substr(0, ret.indexOf('('));
  return ret;
}

function safeNumberFunc(func) { //wrap the error-handling
    return function(x){
        if (x>0) return func(x);
        else return "Illegal Input for "+funcName(func)+" -> "+x;
    }
}

function monadRunHelper(funcsList, input, i) { //recursively iterate over each function
    var safeFunc = safeNumberFunc(funcsList[i]);
    if (i==funcsList.length-1) return safeFunc(input);
    else return monadRunHelper(funcsList, safeFunc(input), i+1);
}

function monadRun(funcsList, input) { //actual api of monad
    return monadRunHelper(funcsList, input, 0);
}
```

**That was the Monad** (exposed as a function rather than an object). Now, the point of this Monad is to allow whoever is writing the functions an easy way to define functions and run them together: 

```js
function mult2(x) { return x*2 }
function add1(x) { return x+1 }
function divide4(x) { return x/4 }
function isExtreme(x) { return x > 10}

monadRun([mult2, add1, divide4, isExtreme], 100) //true
monadRun([mult2, add1, divide4], 100) //50.25
monadRun([mult2, add1, divide4], "foo") //Illegal Input for divide4 -> Illegal Input for add1 -> Illegal Input for mult2 -> foo
```

### Monad - An Absraction of Flow Control 

The important takeaway from this is that we now have an easy abstraction for the following flow control: 

1. Run this list of functions, one after the other, in a pipe sequence (each function gets its predecessor's results)
2. If any function failed, fail nicely and don't crash. 

Some languages (and libraries) expose a Monad chaining syntax which is even more readable, such as (to fit our example): `mult2 >>= add1 >>= divide4 >>= isExtreme` or `mult2.add1.divide4.isExtreme`. With your newfound understanding of monads you can understand this is a chaining of the functions. (Concretely, this is the time to come clean and say that the technical definition of a monad is a bit different, and alludes to objects that accept a 'bind' operator such as >>=. If you are reading this text, understanding the idea behind a monad is more important that the technical definition.) 

Using this and other powerful syntax, we can write completely functional code which looks imperative. For example something like the following Haskell code:

```hs
main = do
  putStrLn "What is your name?"
  name <- getLine
  putStrLn ("Nice to meet you, " ++ name ++ "!")
```

which appears imperative, is actually equivalent to

```haskell
main =
  putStrLn "What is your name?" >> 
  getLine >>= \name ->
  putStrLn ("Nice to meet you, " ++ name ++ "!")
```

which is actually equivalent to:

```haskell
main =
  putStrLn "What is your name?" >> getLine >>= \name -> putStrLn ("Nice to meet you, " ++ name ++ "!")
```

where each binding (>>) is 'running the next function on the output of the previous function', in a chain of functions, as we explored above. (Read more at [Wikipedia](http://en.wikipedia.org/wiki/Monad_%28functional_programming%29#The_I.2FO_monad).) 

We get can now use this flow control abstraction thanks to the monad - without having to maintain all the plumbing ourselves. **The relations of behavior between the different parts (such as items #1 and #2, which we just defined) are defined within the Monad**. 

### Recap

Since we've just written our first Monad, let's recap the theoretical concept - a monad is a way to abstract flow control. We use a monad as a definition of "how to bind together a bunch of actions and the relations between them". Examples of such bindings might be running the actions in sequence, or in parallel, handling their errors, and so on. 

Each monad defines its own behavior, which might include special execution details of some actions - blocking, deferring, executing on a separate thread, and so on. This allows the monad to abstract away from the developer the 'correct' way to execute an action. For example, a monad for web communication or disk I/O might run an action on a separate thread, thus allowing the developer not to worry about it. Imagine the following (fantasy) monadified JS code:

```js
httpMonad.get = function() {
  x = get('/remote.json');
  doSomethingWith(x);
}
```

### Makes Life Easier for The Developer

As the developer, I don't need to work with callbacks and all that crap. I just tell the Monad the list of things I want it to do and it can take care of organizing the actions - which are sequential, which should be executed as a callback, etc. This is obviously impossible (or at least extremely difficult) in JavaScript, but this is actually exactly what the [`async` Monad in Haskell](http://hackage.haskell.org/package/async) does. You give it a list of (sequential) lines to execute, and it figures out how to do it correctly. 

As you hopefully understand, a Monad is sort of a design pattern of design patterns -- using a Monad simply means recognizing that your actions share a certain pattern of inter-relations, and that this pattern can be abstracted away externally such that each action does not need to worry about its relation to other actions. More importantly, the developer does not need to worry about implementing the relations between all the actions (the 'plumbing' and error-handling), and can focus on just the business logic. This also leaves the resultant code much more readable since it is pure business, and all the messy interdependence is left within the Monad).

And yes - this means that you may have already been using Monads (or monad-like constructs) without knowing it.

For example, a famous pattern in JavaScript is using promises, which can viewed as one specific implementation of a monad - chaining together asynchronous calls with 'then/catch' is exactly an abstraction of flow control which enhances readability and maintainability. You don't need to understand how 'then' and 'catch' are implemented, you just know what they do, allowing for very clean business-logic code. 

Hopefully, you are catching that drift -- Monads can be used to defined any abstraction of logic-flow between functions. So, monads are quite powerful in simplifying the business logic part of code.

Understandably, throwing around functions and composing higher-order functions (via Monads) is more useful and necessary the more 'functional' a language is. So in Java - not so much. In Ruby/Python - usable. In JavaScript - practically natural. In Haskell - as obvious as air. 

Use them for fun and profit. (And if you've read all the way down here and this has helped you - let me know! **sella.rafaeli@gmail.com**, Nov 2014)

### Further Reading

* [dustingetz](http://www.dustingetz.com/2012/04/07/dustins-awesome-monad-tutorial-for-humans-in-python.html)
* [This answer at StackOverFlow](http://stackoverflow.com/questions/44965/what-is-a-monad) 