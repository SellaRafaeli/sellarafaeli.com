<!-- {"created_at": "2021-05-20"} -->
## HTML Over the Wire: The Pendulum Swings Back

Something funny is happening in web development. The people at Basecamp released Hotwire a few months ago, and its whole pitch is: *send HTML from the server, and swap it into the page.* htmx is doing the same thing with a few HTML attributes. Phoenix has LiveView, Laravel has Livewire. And people are excited about it like it's a new idea.

It's not a new idea. It's how the web worked before we decided every page needs to be a single-page application. I couldn't be happier.

### How we got here

Around 2013-2015 the industry collectively decided that the server should only send JSON, and the browser should be responsible for everything else: routing, state, templating, validation, data fetching, caching. Sometimes for good reasons - Gmail and Figma really are applications. But mostly because it was the new cool thing, and the new cool thing comes with conference talks and job postings.

So now a typical CRUD app - a list of things, a form to edit a thing - is two apps. A backend that turns database rows into JSON, and a frontend that turns JSON back into HTML. Two codebases, two build systems, two sets of models, two places to validate input, an API contract between them that has to be versioned, and a client-side state management library to keep it all in sync. To show a list of things and a form.

**For most apps, the SPA architecture doubles the work and halves the speed.** I've seen it many, many times.

### HTML is a perfectly good data format

The server already knows how to render a list of things. It has the data, it has the templates, it has the user's permissions. Let it render. When something on the page needs to change, ask the server for the new piece of HTML and put it in the page. That's the whole trick.

You don't even need a framework for the basic version. A few lines of vanilla JS:

~~~ js
document.addEventListener('click', async (e) => {
  const el = e.target.closest('[data-get]')
  if (!el) return
  e.preventDefault()
  const html = await (await fetch(el.dataset.get)).text()
  document.querySelector(el.dataset.target).innerHTML = html
})
~~~

~~~ html
<button data-get="/todos?filter=done" data-target="#todos">Show done</button>
<ul id="todos"><%= erb :todos, locals: {todos: todos} %></ul>
~~~

The server route returns the same `todos` partial it used for the first page load. One template, one source of truth, zero JSON. This is basically what I described a few years ago as [minimal HTML directives](/blog/vanillajs_and_jquery_kiss); the new libraries are nicer, more complete versions of the same idea, and if you need more than a handful of behaviours, use one of them.

### What you get back

- **One app.** One codebase, one deploy, one place where business logic lives.
- **Fast first loads.** The browser gets HTML, which it is extremely good at rendering, instead of a megabyte of JavaScript that has to boot before showing anything.
- **SEO and accessibility, for free.** It's just HTML.
- **Smaller teams.** A single full-stack developer can own a feature end to end, which is - not by coincidence - how I've always liked to work.
- **Fewer dependencies.** Your `node_modules` folder doesn't need to [weigh more than your app](/blog/dependency_madness).

### When the SPA is still right

I'm not religious about it. If you're building a design tool, a spreadsheet, a game, a map, or anything that needs to work offline or respond to every keystroke without a network round-trip - by all means, build a real client-side application. That's what it's for.

But most of us are building forms and lists and dashboards. For those, the server-rendered web was never broken. We just got bored of it.

### The pendulum

Web development swings between "do it on the server" and "do it on the client" roughly once a decade. Mainframes, then PCs. Server pages, then SPAs. Now back towards the server, with the lessons from the client era (nice interactivity, partial updates) built in.

Every swing, the people who were happily building boring server-rendered apps the whole time get to feel smug for a year or two. I'm going to enjoy it.

**Send HTML. The browser knows what to do with it.**
