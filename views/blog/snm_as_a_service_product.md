TLDR: I'd like to create a generic social-network / marketplace, to be sold as a service/product.

I have recently been interested in the generalizability of backends, positing that it is feasible and desirable to create an abstract 'backend', one that could be [offered either as a service or as a product](baas.html). 

In this post I propose and discuss a sub-variant of the above: **a generic social-network / marketplace**. 

Over the past few years I have been intimately involved in the development / running of [fiverr.com](https://fiverr.com) (a marketplace for services) and [yes.no](https://yes.no) (a Q&A social network). I have seen first-hand (and the reader probably knows this themselves) how similar most such sites are. 

A super-set of the features of most such sites might be:

* Users can sign up using email / phone-number / social-sign 
* Users can edit their page
* Users can find other users by name, category or facets
* Users can view other users' pages
* Users can recover their password 
* Admins can edit users and categories 
* Emails are sent to users on certain conditions

In addition, possible features might include:

* Users can add 'posts' to their page and/or comment on other users' posts
* Users can send messages to other users
* Users can add sellable items to their page
* Users can pay via the site to purchase said sellable items from the page

As with the case of a [generic backend](baas.html), the technical is generally identical, including issues such as background processing, responsive web layout, DBs, error monitoring and handling, a mobile-facing API, and so on. 

Clearly, there is much repetition and duplicate work done amongst such sites. An entrepreneur vying to set up a marketplace or a social network might try to stretch some SaaS like Wix or Wordpress to the limit (which would be the correct idea), and then eventually have to resort to shelling out mucho dinero to hire some guys and gals to build it for him. 

To the extent that the generalizability described above is true, it is possible to offer a much faster and cheaper alternative than writing it from the ground up, which might take months to achieve a stable product. From a business perspective, this would not (necessarily) be a product sold to the masses, but as a premium product. 

I am interested in exploring this option: creating a social network / marketplace 'template' that is 95% ready for deployment as a real site, necessating only the 'wrapping' elements of customization such as selecting which features to enable, graphic design and copy, branding, DNS resolving, and adding/modifying unique business logic (which I posit is usually negiligible, certainly when applied by the owning developer). 

The implementation of such a 'generic social network / marketplace' might range from:
a) Complete SaaS - hosting the slew of networks on the same process (sharing the same DB, background queues, and process) 
b) Complete SaaP - generating the code and deploying it separately, existing as a complete stand-alone app.

Option a) above would proably be difficult to create and easier to maintain, while b) is essentially an expansion of a 'services' company offering. The above also might vary by whether the FE is a SPA: if the FE is essentially a stand-alone application, it might be much easier to support a singular BE for all supported apps. 

If you are interested in exploring this concept (from the BE, business, or FE perspective) - hit me up. :)