<!-- {"created_at": "2026-11-09"} -->
## Hunting BOLAs with AI SAST

### What we're building

Over the last few months I've been working together with the team at Variablee (an Israeli frontier AI Security research lab) on an AI SAST program specifically targeting IDOR/BOLA weaknesses in large web apps.

### What is a BOLA?

IDOR (Insecure Direct Object Reference) and BOLA (Broken Object Level Authorization, same name but specifically for web APIs) is one of the main web weaknesses and one that is very easy to explain: it's when there is a bug in the code (broken authorization) that allows user A to fetch a private object/private data that belongs to user B. It's basically one of the most classic bugs, that obviously worries data owners (and CISOs) very much (imagine if another user could fetch your bank details, emails, social media messages, etc).

<br/>
<img src='/img/bolaimg1.svg' />
<br/>

### My background: hunting BOLAs with DAST

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

### AI SAST and the context window problem

Now in the AI era, the models can do a LOT of heavy lifting and we're hoping we can utilize the models to detect BOLAs (and other weaknesses) statically. The main drawback AI models have is that even at their best it's a struggle to fit the right context within the model's context window, which is quickly exhausted on large codebases.

### Narrowing the context: one route at a time

The solution for a context window limitation is, of course, to narrow the context just to the data you need. In our case, searching for an endpoint with a BOLA weakness, we need the list of routes, and for each route, just the necessary context.

So: list of routes, and for each route, just the necessary context to determine if there might be a BOLA weakness or otherwise broken authorization on the path that this route executes. (Said differently, is this a route that can be attacked by the attacker supplying an ID of an object that does not belong to them, and still getting access to this data?) The necessary context includes the list of methods that the route handler might invoke, as well as wider auth defined in a different place (e.g., auth middlewares). Any BOLA weakness must by definition reside on a specific route, and so if we iterate on each route and generate just the necessary context for that route's auth and parameter handling, we will provably exhaust all possible options for a BOLA weakness.

<img src='/img/bola2.png' />

### Caveats and edge cases

(Side note: atm we do not yet address or handle all edge cases, including but not limited to non-HTTP interfaces such as GraphQL, Websockets, and other exotic cases like dynamic route invocation. Another note: it is impossible to determine for certain whether open access to an object is by-design or a bug; c.f. fetching a user's comments with no auth in Facebook would be considered a bug, while in Reddit this would be considered a feature.)

### Building the call graph for each route

To build this context, we traverse the list of files and make a map of which methods are defined in each file, then recursively walk the potential hits to build the graph between invoked functions, which we can later coalesce into a single small contextual blob ("the code for this route") which an LLM can easily handle (for a single route's context or a batched group of routes + context in a single call).

Phrased differently, then, we recursively parse the codebase (along with a map of the symbols defined in each file, which we build ahead of time) and ask at each iteration what the next batch of methods+files can be invoked, and so we build the tree.

(example of a trace, a JSON containing the data):
<img src='/img/example_from_trace.png' />

### Judging each route with the LLM

Once you have the full security context together with each route, it is trivial to pass it to the LLM to judge and find weaknesses - the context window for each route is tiny, and parsing all of the routes is parallelizable and batchable. Having passed all the routes and security context we found and create a list of found issues along with their exact security context (Where the auth is missing, similar routes where it is present, the exact files and lines, and a bottom-line assessment of which findings require a human and/or adversarial agent to assess, triage and verify).

<img src='/img/bola3.png' />

### Benchmarking on known vulnerable repos

A scanner is only as good as its results, so we need a way to measure it: a set of test repos where we already know where the BOLAs are, so we can check whether the scanner finds them (and doesn't flood us with false positives).

We started with three repos, one per language - Python, Node.js and Ruby. Two of them (dvws-node and RailsGoat) are well-known deliberately vulnerable apps, used in the security community for training and for testing security tools - the bugs are planted on purpose and documented as exercises. The third, aegra, is a real-world open-source project, pinned to a version (v0.9.6) with real, publicly disclosed BOLAs that were fixed later. Either way, the weaknesses are documented and serve as our ground truth:

| Repo | Stack | What it is | Known BOLAs |
|------|-------|------------|-------------|
| [aegra](https://github.com/aegra/aegra) v0.9.6 | Python / FastAPI | Open-source, self-hosted agent backend (real project) | CVE-2026-44504, GHSA-q494-8v3j-cp9j, fixes in PRs #424 and #431 |
| [dvws-node](https://github.com/snoopysecurity/dvws-node) | Node.js / Express | Deliberately vulnerable web services app | CHALLENGES.md #15, #19, #33, #39, #53 |
| [RailsGoat](https://github.com/OWASP/railsgoat) | Ruby / Rails | OWASP's deliberately vulnerable Rails app | Wiki: A4 IDOR (work info), IDOR in account settings update |

#### aegra v0.9.6 (Python / FastAPI)

aegra is an open-source alternative to LangGraph Platform: a FastAPI + Postgres backend for running AI agents. Users are kept apart by filtering every query on the caller's `user_id`, so a BOLA here is any route that forgets that filter (or lets the request override it). The known ones in v0.9.6:

- **Runs on another user's thread** - `POST /threads/{thread_id}/runs` (and `/stream`, `/wait`). The run endpoints never checked who owns the thread, so anyone with a victim's `thread_id` could run on it, read its full state and write into its history. [CVE-2026-44504 / GHSA-m98r-6667-4wq7](https://github.com/aegra/aegra/security/advisories/GHSA-m98r-6667-4wq7), fixed in 0.9.7.
- **Store search leaks across users** - `POST /store/items/search` and `POST /store/namespaces`. The user's namespace was matched with an unescaped `LIKE` prefix, so `alice` could read `alice2`'s items, and a user named `%` could read everyone's. [GHSA-q494-8v3j-cp9j](https://github.com/aegra/aegra/security/advisories/GHSA-q494-8v3j-cp9j), fixed in 0.10.8.
- **Running another user's assistant** - `POST /threads/{thread_id}/runs`. The `assistant_id` from the request was looked up without a `user_id` filter, leaking the assistant's private config (API keys, system prompts) into the run. [PR #424](https://github.com/aegra/aegra/pull/424), fixed in 0.9.22.
- **Thread ID override in the body** - the run routes and `POST /threads/{thread_id}/state`. A `thread_id` sent inside the request body overrode the one in the URL, giving read/write access to another user's thread state. [PR #431](https://github.com/aegra/aegra/pull/431), fixed in 0.9.22.

The last two were fixed in PRs without a formal advisory, but the vulnerable code is present in v0.9.6.

#### dvws-node (Node.js / Express)

dvws-node ("Damn Vulnerable Web Services") is a deliberately vulnerable app for practicing API security testing, with REST, GraphQL, SOAP and XML-RPC interfaces. Each vulnerability is a numbered challenge in its [CHALLENGES.md](https://github.com/snoopysecurity/dvws-node/blob/master/CHALLENGES.md). The BOLA ones:

- **#15 IDOR** - `GET/PUT/DELETE /api/v2/notes/:noteId`. Notes have sequential IDs and no ownership check, so any logged-in user can read, edit or delete anyone's private notes.
- **#19 Horizontal access control** - `GET /api/v2/passphrase/:username` (no auth at all) and the notes endpoint above: users can read other users' data.
- **#33 GraphQL access control** - `POST /graphql`, resolvers `readNote`, `userFindbyId` and `userSearchByUsername`. Any valid token can read any user's notes and user record, including the password hash.
- **#39 Account recovery IDOR chain** - `POST /api/v2/account-recovery/lookup` then `/reset`. The lookup turns an email into a `userId`, and the reset accepts any `userId` with no proof of ownership - full account takeover.
- **#53 Support ticket IDOR** - `GET /api/v2/support/tickets/:id`. It checks that the ticket exists, not who owns it. The IDs are UUIDs, but one leaks in another user's notifications - a nice reminder that an unguessable ID is not authorization.

The file has more access-control challenges (admin functions open to regular users, mass assignment of the `admin` flag), but those are function-level rather than object-level, so we don't count them as BOLAs.

#### RailsGoat (Ruby / Rails)

[RailsGoat](https://github.com/OWASP/railsgoat) is OWASP's deliberately vulnerable Rails app - an HR/payroll portal for a fictional company - with a [wiki](https://github.com/OWASP/railsgoat/wiki) tutorial for each bug. The documented object-level bugs:

- **Work info IDOR** ([wiki: A4 Insecure Direct Object Reference](https://github.com/OWASP/railsgoat/wiki/A4-Insecure-Direct-Object-Reference)) - `GET /users/:user_id/work_info`. The `user_id` from the URL is never compared to the logged-in user, so you can read any employee's work info, including their SSN.
- **Account settings IDOR** - `PATCH /users/:id`. The user to update is taken from the request body (in a SQL-injectable query, which is what the wiki tutorial focuses on), so you can overwrite another user's email or password - including the admin's.

Again, RailsGoat's admin filter bypass and mass-assignment bugs are filed under broken access control, but they aren't object-level, so we don't count them. Reading the source also turns up a few BOLA-like bugs the wiki doesn't mention (e.g. reading or deleting other users' messages via `/users/:user_id/messages/:id`). They're not part of the official ground truth, but they're a good reminder that a finding missing from a repo's docs isn't automatically a false positive.

Adding a test repo to the benchmark is simple: we pin a specific version of the repo (so results are reproducible), write down the list of known BOLAs as the expected findings, run the scanner on it, and compare what it found against the expected list.

And then we run our scanner on all three and see we are almost perfect on them. Amazing.

<img src='/img/test_results_bola.png' />

### Source code and results

You can see the full source code and up-to-date test results in our [GitHub](https://github.com/SellaRafaeli/ai_sast)
