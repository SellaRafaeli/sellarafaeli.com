## Classes Are Harmful for Web Backends

- intro
- where are classes necessary?
- why is this not applicable to backends?
- so what should we do?
- how does this affect 

- how does this affect?

Classes are way over-used for web backends. When I say 'web backends' I mean the back-end of most websites, web apps, mobile apps, and basically your standard Rails, Django, whatever API or full-stack CRUD BE. 

Classes are over-used because they are redundant, and because the abstraction they provide is unnecessary. The main reason for this is that in a web backend, most individual objects (class instantiations) exist only for the duration of the request-response cycle (milliseconds). 

Classes (and models) often represent a significant part of the code-base. Desgining, implementing, and testing them takes a lot of time (and money). Doing away with them can save you on all of these. You should do without them. 

### When **are** classes necessary? 

Classes and objects represent a run-time abstraction of our data. Imagine if we are not building a BE for the web but a long-running process such as a flight simulator. We might have Plane object, each of which has a `_hit_points` or `_speed` or `_location` attributes. These attributes exist for a long time - basically, for the duration of the existence of the Plane in RAM. They can be altered in RAM. This is a useful usage pattern of a Class and Object. Since it's useful, we might have a hierarchy of classes, such as a `FighterPlane` class which inherits from Plane, and so on. This is the stuff taught in undergrad curriculums and prevalent in many places. 

However, on the web this is unnecessary. If we have a `User` class, the user object will be instantiated in the beginning of the request, and will be garbage-collected (or otherwise disposed of) at the end of the response. It will exist for mere milliseconds. Modifying for the user in memory is pointless and generally effect-less. Hence, there is no need for a run-time abtraction - no need for an object, and no need for a class. 

== 

Any modifications you want to make on the user, you can make directly on the persistence level. 

`rm -rf *` or `while(true)`