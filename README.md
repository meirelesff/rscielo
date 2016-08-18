
rScielo
=======

[![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

`rScielo` provides a set of functions to scrap meta-data from scientific articles hosted on the [Scientific Electronic Library Online Platform (Scielo)](http://www.scielo.br/). The meta-data information includes author's names, articles' titles, year of the publication, among others. The package also provides additional functions to summarize the scraped data.

### How does it work?

#### Getting a journal's ID

The `rScielo` package scrapes data based on a journal ID (or pid). For example, this is the url of the Brazilian Political Science Review:

    http://www.scielo.br/scielo.php?script=sci_serial&pid=1981-3821&lng=en&nrm=iso

The ID is located between `&pid=` and `&lng` (i.e., `1981-3821`). Most of `rScielo` functions depend on this argument. To automatically extract an ID from a journal hosted on Scielo, you may also use the `get_id_journal()` function:

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

Or use the resulting object as a `data.frame`

``` r
str(df)
#> Classes 'Scielo' and 'data.frame':   98 obs. of  13 variables:
#>  $ author    : chr  "Marcelo de Almeida Medeiros; Mariana Hipólito Ramos Mota; Isabel Meunier" "Matias López" "Kai Michael Kenkel; Marcelle Trote Martins" "Thomas Kestler; Juan Bautista Lucca; Silvana Krause" ...
#>  $ title     : chr  "Modernization Without Change: Decision-Making Process in the Mercosur Parliament" "Elite Framing of Inequality in the Press: Brazil and Uruguay Compared" "Emerging Powers and the Notion of International Responsibility: moral duty or shifting goalpost?" "'Break-In Parties' and Changing Patterns of Democracy in Latin America" ...
#>  $ year      : chr  "2016" "2016" "2016" "2016" ...
#>  $ journal   : chr  "Brazilian Political Science Review" "Brazilian Political Science Review" "Brazilian Political Science Review" "Brazilian Political Science Review" ...
#>  $ volume    : chr  "10" "10" "10" "10" ...
#>  $ number    : chr  "1" "1" "1" "1" ...
#>  $ first_page: num  NA NA NA NA NA NA NA NA NA NA ...
#>  $ last_page : num  NA NA NA NA NA NA NA NA NA NA ...
#>  $ abstract  : chr  "This article analyzes the role of Mercosur's Parliament within Mercosur&#8217;s institutional design and decision-making proces"| __truncated__ "Current elite studies argue that inequality produces negative externalities to elites, who may either promote democracy or adop"| __truncated__ "The rise of new powers and attendant shifts in the global balance of power have led to calls for UN Security Council reform. Es"| __truncated__ "Although Lijphart's typology of consensus and majoritarian democracy can be regarded as the most widely used tool to classify d"| __truncated__ ...
#>  $ keywords  : chr  "Mercosur Parliament; institutions; representativeness; Banzhaf Index" "Brazil; elites; inequality; press; Uruguay" "Responsibility; intervention; political philosophy; emerging powers; Brazil; R2P" "Break-in parties; types of government; Latin America; democracy; informality" ...
#>  $ doi       : chr  "10.1590/1981-38212016000100001" "10.1590/1981-38212016000100002" "10.1590/1981-38212016000100003" "10.1590/1981-38212016000100004" ...
#>  $ n_authors : int  3 1 2 3 2 1 1 1 1 1 ...
#>  $ n_pages   : num  NA NA NA NA NA NA NA NA NA NA ...
```

The `rScielo` package also provides a function to scrap meta-data from a single article:

Finally, `get_journal_info()` and `get_journal_list()` scraps a journal's meta-information (publisher, ISSN, and mission) and a list of all journals hosted on [Scielo](http://www.scielo.br/), respectivelly:

### Functions

Here is a description of the `rScielo` functions:

-   `get_id_journal()`: Extracts a journal's ID from its url.
-   `get_journal()`: Scrapes meta-data from all articles published by a journal.
-   `get_article()`: Scrapes meta-data from a single article.
-   `get_journal_info()`: Scrapes a journal's description.
-   `get_journal_list()`: Scrapes a list with all journals' names, urls and ID's.

### Installation

Currently, `rScielo` is only available at [GitHub](https://github.com/). You can install this pre-release version via:

### Author

[Fernando Meireles](http://www.fmeireles.com)

### License

GPL (&gt;= 2)
