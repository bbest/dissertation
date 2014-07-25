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

    files_Rmd = list.files(pattern=glob2rx('*.Rmd'))
    for (f_Rmd in files_Rmd){
      render(f_Rmd, 'md_document')
      render(f_Rmd, 'html_document')
    }

    files_md = setdiff(list.files(pattern=glob2rx('*.md')), c('README.md', 'phd_thesis.md'))
    all_md = 'phd_thesis.md'
    f <- file(all_md, 'w') 
    for (f_md in files_md){ 
        x <- readLines(f_md) 
        writeLines(c(x,'',''), f)
    } 
    close(f)

    render(all_md, 'html_document', output_options=list(toc='true'))
