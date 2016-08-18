rScielo
=====

[![Package-License](https://img.shields.io/badge/license-GPL%20%28%3E=%202%29-brightgreen.svg?style=flat)](http://www.gnu.org/licenses/gpl-2.0.html)

`rScielo` provides a set of functions to scrap meta-data from scientific articles hosted on the [Scientific Electronic Library Online Platform (Scielo)](http://www.scielo.br/). The meta-data information includes author's names, articles' titles, year of the publication, among others. The package also provides additional functions to summarize the scraped data.


### How does it work?

The `rScielo` package contains a main function to scrap meta-data from a journal hosted on Scielo: `get_journal()`. To extract the me



### Installation

For the time being, `rScielo` is only available at [GitHub](https://github.com/). You can install this pre-release version via:

``` {.r}
if (!require("devtools")) install.packages("devtools")
devtools::install_github("meirelesff/rScielo")
```


### Author

[Fernando Meirels](http://www.fmeireles.com)

### License

GPL (>= 2)
