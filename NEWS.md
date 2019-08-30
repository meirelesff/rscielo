# rscielo 1.1.0 (pre-release)

In this release, we implemented two main changes to the core functionality of the rscielo. First,
we redesigned the package's API to support the scrape of all collection maintained by the 
<https://www.scielo.org/> repository, which currently stores journals in several countries. 
With this change, users are now able to obtain data from any scientific publications ever published 
in the platform. Finally, we improved and fixed some functions to make them more flexible and stable. 
There were no breaking changes.

## Changes

* Added a `NEWS.md` file to track changes to the package.
* Added two new internal functions to abstrat the proccess of generating valid URLs for journals and articles.
* Change `get_journal` to accept as input any journal ID stored in the <https://www.scielo.org/>'s collection.
* `get_journal_list` now returns information on more than 17000 journals maintained in the <https://www.scielo.org/>. 
* Changed the `get_journal_id` function to accept vetors of URLs.
