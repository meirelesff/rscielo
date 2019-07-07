
rScielo
=======

[![Travis-CI Build Status](https://travis-ci.org/meirelesff/rScielo.svg?branch=master)](https://travis-ci.org/meirelesff/rScielo) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/rScielo?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/rScielo) [![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rScielo)](https://cran.r-project.org/package=rScielo)

`rScielo` provides a set of functions to scrape meta-data from scientific articles hosted on the [Scientific Electronic Library Online Platform (Scielo.br)](http://www.scielo.br/). The meta-data information includes authors' names, articles' titles, year of the publication, among others. The package also provides additional functions to summarize the scrapped data.

### How does it work?

#### Getting a journal's ID

The `rScielo` package scrapes data based on a journal ID (or pid). For example, consider the link to the Brazilian Political Science Review homepage on [Scielo](http://www.scielo.br/):

    http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso

The ID is located between `&pid=` and `&lng` (i.e., `1981-3821`). Most of `rScielo` functions depend on this argument. To automatically extract an ID from a journal hosted on [Scielo](http://www.scielo.br/), you may also use the `get_id_journal()` function:

``` r
get_id_journal("http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#> [1] "1981-3821"
```

#### Scraping data

To scrape meta-data from all articles of a journal hosted on [Scielo](http://www.scielo.br/), use the `get_journal()` function:

``` r
df <- get_journal("1981-3821")
```

Then summarize the scrapped data with `summary`:

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

The `rScielo` package also provides a function to scrape meta-data from a single article:

``` r
# The article's URL on Scielo
url <- "http://www.scielo.br/scielo.php?script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en"

# Scrape the data
article <- get_article(url)
```

Finally, `get_journal_info()` and `get_journal_list()` scrapes a journal's meta-information (publisher, ISSN, and mission) and a list of all journals hosted on [Scielo](http://www.scielo.br/), respectively:

``` r
# Get a journal's meta-information
meta_info <- get_journal_info("1981-3821")

# Get a list with all journals names, URLs and IDs
journals <- get_journal_list()
```

#### Scraping metrics

With the `rScielo`, it is possible to scrape several publication and citation metrics of a journal hosted on [Scielo](http://www.scielo.br/):

``` r
# Gets citation metrics
cit <- get_journal_metrics("1981-3821")

# Plots the data for a quick visualization
plot(cit)
```

### Functions

Here is a description of the `rScielo` functions:

-   `get_id_journal()`: Gets a journal's ID from its url.
-   `get_journal()`: Gets meta-data from all articles published by a journal.
-   `get_article()`: Gets text from a single article.
-   `get_article_fnotes()`: Gets footnote from a single article.
-   `get_article_references()`: Gets references from a single article.
-   `get_article_meta()`: Gets meta-data from a single article.
-   `get_journal_info()`: Gets a journal's description.
-   `get_journal_list()`: Gets a list with all journals' names, URLs and ID's.
-   `get_journal_metrics()`: Gets publication and citation metrics of a journal.

### Installation

Install the latest stable release from [CRAN](http://cran.r-project.org/) via:

``` r
install.packages("rScielo")
```

Alternatively, install the latest pre-release version from [GitHub](https://github.com/) via:

``` r
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/rScielo")
```

### Author

[Fernando Meireles](http://www.fmeireles.com)

### License

GPL (&gt;= 2)
