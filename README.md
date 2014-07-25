thesis
======

PhD thesis at Duke University

Knitting the document
---------------------

This thesis is being knitted into a scientifically reproducible document
using the following techniques:

-   **markdown**. Rmarkdown.

-   **citations**. Zotero and pandoc. Use better bibtex Zotero extension
    to enable drag-and-drop of citation into document in Pandoc format.

<!-- -->

    library(rmarkdown)

    setwd('~/github/phd_thesis')

    # get files to process
    # files_Rmd_exclude = c('README.Rmd')
    # files_Rmd = setdiff(list.files(pattern=glob2rx('*.Rmd')), files_Rmd_exclude)

    for (f_Rmd in list.files(pattern=glob2rx('*.Rmd'))){ # files_Rmd){ # f_Rmd = files_Rmd[1]
      render(f_Rmd, 'md_document')
      render(f_Rmd, 'html_document')
    }
