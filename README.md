thesis
======

PhD thesis at Duke University.

See the rendered thesis:

-   [html](http://htmlpreview.github.io/?https://raw.githubusercontent.com/bbest/phd_thesis/master/phd_thesis.html)
-   [pdf](https://github.com/bbest/phd_thesis/raw/master/phd_thesis.pdf)
-   [docx](https://github.com/bbest/phd_thesis/raw/master/phd_thesis.docx)

Knitting the document
---------------------

This thesis is being knitted into a scientifically reproducible document
using the following techniques:

-   **markdown**. Rmarkdown.

-   **citations**. Zotero and pandoc. Use better bibtex Zotero extension
    to enable drag-and-drop of citation into document in Pandoc format.

<!-- -->

    library(rmarkdown)

    all_md    = 'phd_thesis.md'
    dir_other = '~/Dropbox/phd_thesis'

    # render md's
    files_Rmd = list.files(pattern=glob2rx('*.Rmd'))
    for (f_Rmd in files_Rmd){
      render(f_Rmd, 'md_document')
      render(f_Rmd, 'html_document')
    }

    # concat md
    files_md = setdiff(list.files(pattern=glob2rx('*.md')), c('README.md', all_md))
    f <- file(all_md, 'w') 
    for (f_md in files_md){ 
        x <- readLines(f_md) 
        writeLines(c(x,'',''), f)
    } 
    close(f)

    # render html and pdf
    pfx = tools::file_path_sans_ext(all_md)
    render(all_md, 'html_document', output_file=sprintf('%s/%s.html', dir_other, pfx), output_options=list(toc='true', fig_caption='true'))
    system(
      sprintf('/usr/local/bin/pandoc %s.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures --output %s/%s.pdf --table-of-contents --toc-depth 2 --template /Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex --highlight-style tango --latex-engine xelatex --variable geometry:margin=1in', pfx, dir_other, pfx))
    render(all_md, 'word_document', output_file=sprintf('%s/%s.docx', dir_other, pfx))

    # open
    system(sprintf('open %s/%s.%s', dir_other, pfx, 'html')
    system(sprintf('open %s/%s.%s', dir_other, pfx, 'pdf')
    system(sprintf('open %s/%s.%s', dir_other, pfx, 'docx')
