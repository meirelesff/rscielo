
rScielo
=======

[![Travis-CI Build Status](https://travis-ci.org/meirelesff/rScielo.svg?branch=master)](https://travis-ci.org/meirelesff/rScielo) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/rScielo?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/rScielo) [![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

`rScielo` provides a set of functions to scrap meta-data from scientific articles hosted on the [Scientific Electronic Library Online Platform (Scielo)](http://www.scielo.br/). The meta-data information includes author's names, articles' titles, year of the publication, among others. The package also provides additional functions to summarize the scraped data.

### How does it work?

#### Getting a journal's ID

The `rScielo` package scrapes data based on a journal ID (or pid). For example, this is the url of the Brazilian Political Science Review homepage on [Scielo](http://www.scielo.br/):

    http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso

The ID is located between `&pid=` and `&lng` (i.e., `1981-3821`). Most of `rScielo` functions depend on this argument. To automatically extract an ID from a journal hosted on [Scielo](http://www.scielo.br/), you may also use the `get_id_journal()` function:

``` r
get_id_journal("http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#> [1] "1981-3821"
```

#### Scraping data

To scrap meta-data from all articles of a journal hosted on [Scielo](http://www.scielo.br/), use the `get_journal()` function:

``` r
df <- get_journal("1981-3821")
#> 
#> 
#> Scraping articles from: 
#> 
#> 
#>  Brazilian Political Science Review
#> 
#> 
#> ...
#> 
#> Done.
```

Then summarize the scraped data with `summary`:

``` r
summary(df)
#> 
#> ### JOURNAL SUMMARY: Brazilian Political Science Review (2012 - 2016)
#> 
#> 
#>  Total number of articles:  98 
#>  Total number of articles (reviews excluded):  67
#> 
#>  Mean number of authors per article:  1.61 
#>  Mean number of pages per article:  29.38
```

The `rScielo` package also provides a function to scrap meta-data from a single article:

``` r
# The article's url on Scielo
url <- "http://www.scielo.br/scielo.php?script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en"

# Scrap the data
article <- get_article(url)
```

Finally, `get_journal_info()` and `get_journal_list()` scraps a journal's meta-information (publisher, ISSN, and mission) and a list of all journals hosted on [Scielo](http://www.scielo.br/), respectivelly:

``` r
# Gets a journal's meta-information
meta_info <- get_journal_info("1981-3821")

# Gets a list with all journals names, urls and IDs
journals <- get_journal_list()
```

### Functions

Here is a description of the `rScielo` functions:

-   `get_id_journal()`: Extracts a journal's ID from its url.
-   `get_journal()`: Scrapes meta-data from all articles published by a journal.
-   `get_article()`: Scrapes meta-data from a single article.
-   `get_journal_info()`: Scrapes a journal's description.
-   `get_journal_list()`: Scrapes a list with all journals' names, urls and ID's.

### Installation

Currently, `rScielo` is only available at [GitHub](https://github.com/). You can install this pre-release version via:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/rScielo")
```

### Author

[Fernando Meireles](http://www.fmeireles.com)

### License

GPL (&gt;= 2)
