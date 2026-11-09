<!-- {"created_at": "2026-11-09"} -->
## Hunting BOLAs with AI SAST

Over the last few months I've been working together with the team at Variablee (a frontier research lab) on an AI SAST program specifically targeting IDOR/BOLA weaknesses in large web apps.

IDOR (Insecure Direct Object Reference) and BOLA (Broken Object Level Authorization, same name but specifically for web APIs) is one of the main web weaknesses and one that is very easy to explain to muggles: it's when there is a bug in the code (broken authorization) that allows user A to fetch a private object/private data that belongs to user B. It's basically one of the most classic bugs, that obviously worries data owners (and CISOs) very much (imagine if another user could fetch your bank details, emails, social media messages, etc).

<br/>
<img src='/img/bolaimg1.svg' />
<br/>

(My personal background: a few years ago ('21, pre-GPT) I led (designed, built, integrated with customers) a web attack simulator tool for web API weaknesses (DAST, including IDOR/BOLAs) for a company called Wib Security. ([Here's one presentation](https://www.youtube.com/watch?v=m4eYiP8Z1aI) I gave of the tool at an API Days conference.) This was a great project and an awesome tool: it could read an API spec and automatically generate thousands of different variations of deep sessions, execute each one of them against the API, analyze the results and display findings. The generation of the different attack vectors was based on our pentest experience and research, and the tool could implement every type of attack, execute deep sessions - e.g. log in, create private resource, create private sub-resource, attack sub-resource with other user's auth, etc. The combination of brute force + domain algorithms for generating attacks and analyzing results was one of the most powerful API security tools (offensive/defensive) I have personally seen, covering both one-shot (knowledge-less user) and expert mode (to be used in the hands of a skilled attacker).)
<br/>

<iframe width="560" height="315" 
  src="https://www.youtube.com/embed/m4eYiP8Z1aI" 
  title="YouTube video player" 
  frameborder="0" 
  allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" 
  allowfullscreen>
</iframe>

<br/>

Now in the AI era, the models can do a LOT of heavy lifting and we're hoping we can utilize the models to detect BOLAs (and other weaknesses) statically. The main drawback AI models have is that even at their best it's a struggle to fit the right context within the model's context window, which is quickly exhausted on large codebases.

The solution for a context window limitation is, of course, to narrow the context just to the data you need. In our case, searching for an endpoint with a BOLA weakness, we need the list of routes, and for each route, just the necessary context.

So: list of routes, and for each route, just the necessary context to determine if there might be a BOLA weakness or otherwise broken authorization on the path that this route executes. (Said differently, is this a route that can be attacked by the attacker supplying an ID of an object that does not belong to them, and still getting access to this data?) The necessary context includes the list of methods that the route handler might invoke, as well as wider auth defined in a different place (e.g., auth middlewares). Any BOLA weakness must by definition reside on a specific route, and so if we iterate on each route and generate just the necessary context for that route's auth and parameter handling, we will provably exhaust all possible options for a BOLA weakness.

<img src='/img/bola2.png' />

(Side note: atm we do not yet address or handle all edge cases, including but not limited to non-HTTP interfaces such as GraphQL, Websockets, and other exotic cases like dynamic route invocation. Another note: it is impossible to determine for certain whether open access to an object is by-design or a bug; c.f. fetching a user's comments with no auth in Facebook would be considered a bug, while in Reddit this would be considered a feature.)

To build this context, we traverse the list of files and make a map of which methods are defined in each file, then recursively walk the potential hits to build the graph between invoked functions, which we can later coalesce into a single small contextual blob ("the code for this route") which an LLM can easily handle (for a single route's context or a batched group of routes + context in a single call).

Phrased differently, then, we recursively parse the codebase (along with a map of the symbols defined in each file, which we build ahead of time) and ask at each iteration what the next batch of methods+files can be invoked, and so we build the tree.

(example of a trace, a JSON containing the data):
<img src='/img/example_from_trace.png' />

Once you have the full security context together with each route, it is trivial to pass it to the LLM to judge and find weaknesses - the context window for each route is tiny, and parsing all of the routes is parallelizable and batchable. Having passed all the routes and security context we found and create a list of found issues along with their exact security context (Where the auth is missing, similar routes where it is present, the exact files and lines, and a bottom-line assessment of which findings require a human and/or adversarial agent to assess, triage and verify).

<img src='/img/bola3.png' />

You can see the full source code in our [GitHub](https://github.com/SellaRafaeli/ai_sast) along with reference repos we have built together for the community (/r/ai_sast) use for benchmarks (10 Python repos, one JS, one Ruby).