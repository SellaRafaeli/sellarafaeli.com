# Let vs Const vs Var - Misleading && Harmful

'New' versions of JS support let and const (vs var) which leads to endless discussions about when to use which. Sadly in the real world, it doesn't really matter. 

**`const` only enforces constantness on a superficial level, at the base variable assignment.**

```
const x = {};
x = 'foo' //boom
```

It famously does not prevent modifying internal fields of an object or array.

```
const x = {msg: 'hi'}
x.msg = 'bye' //works. uh-oh
```

`const` simply doesn't guarantee complete `const`-ness. To clarify: *a variable declared as `const` can still change its value.* This is clearly misleading; the whole point of a `const` statement is to signify the value will not change. The net result is even worse than not using `const` to begin with - you have now indicated a misleading aspect about the data, which the interpreter/transpiler will not enforce. 

So `const` is not "really" const. This leads to separate styles of choosing when to use `let` vs `const` - should `const` values only be used for 'deep' constant-ness (non-mutating state, including properties, as logically expected) or 'shallow' constant-ness (as defined by the interpreter)? I strongly prefer the first one -- don't use `const` for values that change -- but the very fact that there are two separate valid interpretations means that when you're reading code, you can't fully make any assumptions about whether the value changes or not, and thus the whole declaration is almost meaningless. (A caveat is that const ensures the variable won't be assigned a completely new value, so const is still useful for primitives.)

Basically at this point, a `const` for a non-primitive means a value will either change... or it won't. Since the syntax itself cannot reliably indicate whether the value is really constant, you as a writer cannot signal to a future reader whether the value is truly constant or not -- and a reader cannot assume anything from a variable being declared as const. 

To make things even worse, the mere fact that there are separate conflicting ways in which you can 'use' const (as described above) means that you will have to guess which way the original author 'meant'. All of this takes significant cognitive overhead when just reading a variable, and creates an ensuing muddy bikeshedding discussion about what to use when, which costs more cognitive effort than it saves. 

As a concrete alternative, real consts could be in UPPERCASE, which is well-known convention for constness. These just don't get protection by the interpreter, but the meaning to the reader is clear and obvious. 

```
FOO    = 'bar'
SERVER = {url: 'google.com'}
```

Everything else can be `let` or `var`. `let` is the new 'cool' way to declare local variables, but is only functionally better if you have recurring variable names within different blocks in the same function, which is... better rectified by not reusing the same variable name in the function.)

Use whatever you want for const/let/var, it matters little. Focus on architecture and semantics more than syntax. 