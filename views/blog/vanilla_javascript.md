<!-- {"created_at": "2014-11-10", "draft": "yes"} -->

Points to make: 
- Vanilla tastes best (libraries, not frameworks)

This post is mostly a random collection of ode rants to JavaScript. 

An Ode To Vanilla JavaScript 

1. I was born in the darkness, molded by it

My first professional programming experience was with JavaScript^1. Not [even] browser-based JavaScript, but rather a JS engine that Photoshop (of all things) exposed. The engine (along with a basic Photoshop API) was meant to expose a way to automate tasks such as adding watermarks to your photos and other routine designer tasks. We were using the narrow window it offered to cram a full-fledged enterprise application for making media magazines for the iPad on top of Photoshop. 

This meant DOM-less, jQuery-less JavaScript. Lots of "The Good Parts" and "The Definitive Guide" and <code> undefined</code>. Not a too much online docs or community support, since it was a pretty niche technology. Basically, we were forced to make do with 'vanilla' JavaScript from the ground up. Being a young professional, I remember feeling at the time that it was bit of a waste, to acquire proficiency in such an esoteric skillset rather than gaining experience in something that I 'could take to the next job'. Turns out, I was dead-wrong. Swimming in native JavaScript puts hair on your chest. Makes you appreciate how to handle the language at the native level. 

3. App Run-time REPL: So much awesomeness

It is often similarly said that learning C makes you appreciate what your code 'is actually doing' on the CPU level. Manual pointer arithmetic is the equivalent of learning to drive a stick shift - you're not really going to need it in your day to day driving, but it sort of helps you understand what the hell is going on. JavaScript, despite being hated for all the wrong reasons, is yet much more important to know well, since native JavaScript can and be is used at the application level (modify run-time data, DOM elements, CSS), via the original source code or run-time debugging (Chrome and FF's dev tools, among the best IDEs I have seen for such tasks). Which is to say, even after your code has been 'compiled' (whether that refers to the Angular variety, CoffeeScript, Uglifi-/Minification, or whatever) and run - you can still use command-line JavaScript to interact and modify your application. A REPL loop *while the application is running*. 

4. A note about the state of SPAs

Frameworks come and go like crazy, compile-to-js projects won't die (CoffeeScript, asm.js), each introducing its own super powers... and its own complexities. 

Relatedly, it seems most [SPA] frameworks are currently (end of 2014) in the 'trough of disillusionment': the conceptual awesomeness they have brought is now realized to include significant conceptual complexity (which results slow development) in addition to the inevitable technical overhead (slow performance in some cases). And yet, these frameworks are built upon one of the 'highest', most expressive of the software languages. As the web's standards become better adhered-to and more robust (HTML5 official standard, W3C standards, browser compatibility), the individual features of SPAs are gradually replaced by standard web technologies (http://stackoverflow.com/questions/26382156/replacing-angular-with-standard-web-technologies) - which have honestly never been far behind. The major issues large JS application face are usually: DOM directives, modules, routes, and 2-way databinding. Modules and routes are easily managed with good (JS) practices. 2-way databinding is honestly rarely enough used that you can just boilerplate it (write it from scratch per feature) or libify it. DOM directives are making their way towards a standard, and until then projects such as Polymer supply what you need.

I get so frustrated googling for how to do something in [insert framework here] when it's often a one-liner in vanilla. JavaScript is good enough. http://alarmingdevelopment.org/?p=191

5. A note about jQuery and libs in general

The correct thing to say about jQuery is that it is awesome. No less, but no more. You don't need it to do everything, http://youmightnotneedjquery.com/, you might not need it at all, but it's damn good at what it does, especially DOM manipulation. More importantly, jQuery stays peacefully out of the way. Use it when you want to, use Vanilla (or anything else) when you want to. It's just a library, just a set of tools - you use it when you want to and forget about it later, instead of having the whole application handcuffed to it. There are plenty of awesome libraries out there. If you feel comfortable with the basics, libraries become powerful tools, with none of the excess baggage of frameworks. 

JavaScript is the motherfucking force. It is so 

6. Todo app

A random snippet of one (naive, arguable) way to implement a (view-less) ToDo-app in Vanilla. Oh, I <3 JS. 

todos = {tasks: {laundry: {}, cooking: {} } };  
todos.changeStatus = function(taskName, status) { todos.tasks[taskName] = todos.tasks[taskName] || {}; todos.tasks[taskName].status = status }
todos.add = function(taskName) { todos.changeStatus(taskName, 'add') } //syntatic sugar 
todos.complete = function(taskName) { todos.changeStatus(taskName, 'completed') } //syntatic sugar 
todos.add('eat');
todos.changeStatus('eat','done');

http://upload.wikimedia.org/wikipedia/commons/thumb/9/94/Gartner_Hype_Cycle.svg/2000px-Gartner_Hype_Cycle.svg.png

7. CSS 

I wanted to write some CSS to align *n* (an unknown number of) items in rows of three, each row evenly distributed. 
In other words, for *n*==1, we would want:
<---------->
For n==2:
<--->  <--->
For n==3:
<-> <-> <->
For n==4:
<-> <-> <->
<---------->
For n==5:
<-> <-> <->
<--->  <--->
And so on.

I suppose there is some way to do this is in pure CSS -- but we couldn't manage within 30 minutes, and that's way too long in my book for such a task. With JS, it was a simple:

> Vanilla instead of CSS:

var numCols = queryIDsArr.length > 2 ? 3 : queryIDsArr.length
        var width = (100 / numCols)-1+'%';      
        newResultsDiv.css('max-width',width);                  

> Vanilla instead of Angular:

> Vanilla instead of jQuery:

This has been well-discussed. jQuery is frickin awesome, but driving a 
http://howtodoinjava.files.wordpress.com/2013/04/use-jquery.gif

> Vanilla, the official library:
http://vanilla-js.com/



> Atwood's law
> 