
# rscielo

**Authors:** [Fernando Meireles](https://fmeireles.com/), [Denisson
Silva](http://denissonsilva.com/), and Rogerio Barbosa<br/>

[![Travis-CI Build
Status](https://travis-ci.org/meirelesff/rScielo.svg?branch=master)](https://travis-ci.org/meirelesff/rScielo)
[![AppVeyor Build
Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/rScielo?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/rScielo)
[![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rscielo)](https://cran.r-project.org/package=rscielo)
[![Lifecycle:
maturing](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://www.tidyverse.org/lifecycle/#maturing)

`rscielo` offers functions to easily scrape bibliometric information
from scientific journals and articles hosted on the [Scientific
Electronic Library Online Platform (Scielo.br)](http://www.scielo.br/).
The retrieved data includes a journal’s details and citation counts;
article’s contents, footnotes, bibliographic references; and several
other common information used in bibliometric studies. The package also
provides functions to quickly summarize the scrapped data.

### Installing

To install the latest stable release of `rscielo` from
[CRAN](https://cran.r-project.org/), use:

``` r
install.packages("rscielo")
```

Alternatively, one may install the latest pre-release version from
[GitHub](https://github.com/) via:

``` r
if(!require("remotes")) install.packages("remotes")
remotes::install_github("meirelesff/rscielo")
```

### How does it work?

At its core, `rscielo` is a scraper that offers a transparent and
reproducible approach to gather data from the [Scientific Electronic
Library Online Platform (Scielo.br)](http://www.scielo.br/), one of the
largest open repositories for scientific publications in the world. In
particular, the package provides functions to automatically extract and
parse different types of information from (1) scientific journals
(pointed by `_journal` or `_journal_` in their names) and (2) articles
(with functions that contains `_article` or `_article_` in their names).

### Data from journals

#### Getting a journal’s ID

To get data from a particular journal, such as citation counts and
[ISSN](https://en.wikipedia.org/wiki/International_Standard_Serial_Number),
the `rscielo` relies on an ID (or pid) that uniquely identifies each
journal within the [Scielo](http://www.scielo.br/) repository. As an
example, this is the URL of the [Brazilian Political Science
Review](http://www.scielo.br/bpsr/) homepage on
[Scielo](http://www.scielo.br/):

    http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso

The journal ID can be found between `&pid=` and `&lng` (i.e.,
`1981-3821`). Most of `rscielo`’s functions that retrieve data from
journals rely on this information to work. To automatically extract an
ID from the URL of a journal, one may use the `get_journal_id()`
function:

``` r
get_journal_id("http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#> [1] "1981-3821"
```

#### Scraping data from a journal

With a journal ID in hand, use the `get_journal()` function to scrape
meta-data from all articles published in its last issue:

``` r
df <- get_journal("1981-3821")
```

This code returns a `tibble` in which the observations correspond to the
articles that appeared in the selected journal’s lastest issue. Among
the returned variables are authors’ names, institutional affiliations,
and home countries; articles’ abstracts, keywords, and the number of
pages (check the `get_journal` documentation executing
`help(get_journal)` for a full description of the retrieved data).

For a quick glimpse at the scrapped data, one may use the `summary`
method:

``` r
summary(df)
#> 
#> ### JOURNAL: Brazilian Political Science Review
#> 
#> 
#>  Total number of articles:  1 
#>  Total number of articles (reviews excluded):  1
#> 
#>  Mean number of authors per article:  5 
#>  Mean number of pages per article:  Not available
```

`get_journal()` also extracts data from all articles ever published by a
journal. To do that, set the argument `last_issue` to `FALSE`:

``` r
get_journal("1981-3821", last_issue = "FALSE")
```

#### Scraping journal metrics

`rscielo` contains functions to scrape and report publication and
citation counts of a journal:

``` r
# Gets citation metrics
cit <- get_journal_metrics("1981-3821")

# Plots the data for a quick visualization
plot(cit)
```

![](man/figures/README-unnamed-chunk-8-1.png)<!-- -->

#### Other functions

`get_journal_info()` and `get_journal_list()` scrapes a journal’s
meta-information (publisher, ISSN, and mission) and a list of all
journals hosted on [Scielo](http://www.scielo.br/), respectively:

``` r
# Get a journal's meta-information
meta_info <- get_journal_info("1981-3821")


# Get a list with all journals names, URLs and IDs
journals <- get_journal_list()
```

### Data from articles

#### Getting an articles’ ID

Scientific articles stored on [Scielo](http://www.scielo.br/) are also
identified by a unique ID, which is formed by a combination between
their Digital Object Identifiers
([DOI](https://en.wikipedia.org/wiki/Digital_object_identifier)) plus
other characters. These IDs can se seen in each article’s URL (after
`&pid=` until `&lng=`):

``` r
# URL of an article
url_article <- "http://www.scielo.br/scielo.php?script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en"
```

By design, `rscielo` handles full articles’ URLs as inputs, but users
may obtain the IDs by using the `get_article_id` function:

``` r
get_article_id(url_article)
#> [1] "S1981-38212016000200201"
```

#### Contents of a single article

To scrape the content of a single scientific article, the `rscielo`
provides the `get_article()` function:

``` r
# Scrape the meta-data
article <- get_article(url_article)
```

As can be seen, the function returns the full text of the requested
article as a `character` vector. Users may also pass the article’s ID to
the function to achieve the same results:

``` r
article <- get_article("S1981-38212016000200201")
```

Or set the argument `output_text` to `FALSE` to get a `tibble` with the
article’s DOI (which might be useful in bibliometric analysis):

``` r
article <- get_article("S1981-38212016000200201", output_text = FALSE)
```

#### Meta-data of an article

Similar to the `get_journal()` function, `get_article_meta` returns
meta-data of a selected article hosted on
[Scielo](http://www.scielo.br/):

``` r
url <- "http://www.scielo.br/scielo.php?script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en"
article_meta <- get_article_meta(url)
```

#### Bibliographic references and footnotes

To retrieve a list of bibliographic items cited by an article, use
`get_article_referencs()`:

``` r
article_references <- get_article_references(url)
```

The function outputs a `tibble` in which every bibliographic item
corresponds to an observation. `get_article_footnotes()` returns a
similar object, but with footnotes in the rows:

``` r
article_foots <- get_article_footnotes(url)
```

### A list of functions

For convenience, here is a description of the `rscielo` functions.

**Function to extract data from journals:**

  - `get_journal_id()`: Get a journal’s ID from its URL.
  - `get_journal()`: Get meta-data of all articles published by a
    journal.
  - `get_journal_info()`: Get a journal’s description.
  - `get_journal_list()`: Get a list with all journals’ names, URLs and
    ID’s.
  - `get_journal_metrics()`: Get publication and citation counts of a
    journal.

**Function to extract data from articles:**

  - `get_article_id()`: Get an article’s ID from its URL.
  - `get_article()`: Get the full text of a single article.
  - `get_article_meta()`: Get meta-data of a single article.
  - `get_article_referencs()`: Get the list of bibliographic references
    cited by a single article.
  - `get_article_footnotes()`: Get the list of the footnotes of a single
    article.

**Methods:**

  - `summary.Scielo()`: Summarize the data of a `tibble` returned by
    `get_journal`.
  - `plot.scielo_metrics()`: Plot citation counts of a journal retrieved
    by `get_journal_metrics`.

### A note about the data

The `rscielo`‘s functions extract data directly from the
[Scielo](http://www.scielo.br/) online repository. In any event,
sometimes users might find errors or obtain incomplete information when
using its functions, mainly when using the `_article` ones to scrape
articles’ full contents. This happens when journals feeds invalid or
wrongly formatted information into the Scielo platform. In most
situations, a bit of data cleaning solves the issues, but users must be
aware that the retrieved data still might be lacking.

### Citation

To cite `rscielo` in publications, use:

``` r
citation("rscielo")
#> 
#> To cite package 'rscielo' in publications use:
#> 
#>   Fernando Meireles, Denisson Silva and Rogerio Barbosa (2019).
#>   rscielo: A Scraper for Scientific Journals Hosted on Scielo. R
#>   package version 1.0.0. https://github.com/meirelesff/rscielo
#> 
#> A BibTeX entry for LaTeX users is
#> 
#>   @Manual{,
#>     title = {rscielo: A Scraper for Scientific Journals Hosted on Scielo},
#>     author = {Fernando Meireles and Denisson Silva and Rogerio Barbosa},
#>     year = {2019},
#>     note = {R package version 1.0.0},
#>     url = {https://github.com/meirelesff/rscielo},
#>   }
```

### Contributions

We welcome comments or suggestions to improve the package. Feel free to
start a issue at our [GitHub
repository](https://github.com/meirelesff/rscielo).
