
rScielo
=======

[![Travis-CI Build Status](https://travis-ci.org/meirelesff/rScielo.svg?branch=master)](https://travis-ci.org/meirelesff/rScielo) [![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/meirelesff/rScielo?branch=master&svg=true)](https://ci.appveyor.com/project/meirelesff/rScielo) [![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/rScielo)](https://cran.r-project.org/package=rScielo)

`rScielo` provides a set of functions to scrape meta-data from scientific articles hosted on the [Scientific Electronic Library Online Platform (Scielo.br)](http://www.scielo.br/). The meta-data information includes author's names, articles' titles, year of the publication, among others. The package also provides additional functions to summarize the scrapped data.

### How does it work?

#### Getting a journal's ID

The `rScielo` package scrapes data based on a journal ID (or pid). For example, this is the url of the Brazilian Political Science Review homepage on [Scielo](http://www.scielo.br/):

    http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso

The ID is located between `&pid=` and `&lng` (i.e., `1981-3821`). Most of `rScielo` functions depend on this argument. To automatically extract an ID from a journal hosted on [Scielo](http://www.scielo.br/), you may also use the `get_id_journal()` function:

``` r
get_id_journal("http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso")
#> [1] "1981-3821"
```

#### Scraping articles texts, meta-data, journal information

The `rScielo` package also provides a function to scrape meta-data from a single article:

``` r
# The article's URL on Scielo
url <- "http://www.scielo.br/scielo.php?script=sci_arttext&pid=S1981-38212016000200201&lng=en&nrm=iso&tlng=en"

# Scrape the data
article <- get_articleMetaData(url)
```

To scrape the complete text content of an article (excluding references and pre-textual information - such as authors information and abstracts), use get\_articleText:

``` r
# Gets citation metrics
text <- get_articleText(url)
```

To scrape meta-data from all articles of a journal hosted on [Scielo](http://www.scielo.br/), use the `get_journal()` function:

``` r
df <- get_journalMetaList("1981-3821")
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

Here it is a short description of the `rScielo` functions:

-   `get_id_journal()`: Gets a journal's ID from its url.
-   `get_journalMetaList()`: Gets meta-data from all articles published by a journal.
-   `get_articleMetaData()`: Gets meta-data from a single article.
-   `get_articleText()`: Gets the complete text content of an article.
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
devtools::install_github("meirelesff/rScielo", ref = "testVersion")
```

### Authors

[Fernando Meireles](http://www.fmeireles.com) [Rogério J Barbosa](https://sociaisemetodos.wordpress.com/)

### License

GPL (&gt;= 2)
