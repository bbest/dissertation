thesis
======

PhD thesis at Duke University.

See the rendered thesis:

-   [html](https://www.dropbox.com/s/2d1ncyu3p9ho00b/phd_thesis.html)
-   [pdf](https://www.dropbox.com/s/xvpiw81izl6beiq/phd_thesis.pdf)
-   [docx](https://www.dropbox.com/s/k2yl5tt2gezvdve/phd_thesis.docx)

Knitting the document
---------------------

This thesis is being knitted into a scientifically reproducible document
using the following techniques:

-   **markdown**. Rmarkdown.

-   **citations**. Zotero and pandoc. Use better bibtex Zotero extension
    to enable drag-and-drop of citation into document in Pandoc format.

<!-- -->

    library(rmarkdown)

    md_all       = 'index.md'
    #dir_other    = '~/Dropbox/phd_thesis'
    dir_other    = '~/github/phd_thesis'
    tex_template = 'thesis_template.latex'

    # render md's
    files_Rmd = list.files(pattern=glob2rx('*.Rmd'))
    for (f_Rmd in files_Rmd){
      render(f_Rmd, 'md_document')
      render(f_Rmd, 'html_document')
    }

    # concat md
    files_md = setdiff(list.files(pattern=glob2rx('*.md')), c('README.md', md_all))
    f <- file(md_all, 'w') 
    for (f_md in files_md){ 
        x <- readLines(f_md) 
        writeLines(c(x,'',''), f)
    } 
    close(f)

    # get prefix
    pfx = tools::file_path_sans_ext(md_all)

    # render html
    render(md_all, 'html_document', output_file=sprintf('%s/%s.html', dir_other, pfx), output_options=list(toc='true', fig_caption='true'))

    # render pdf
    system(
      sprintf('/usr/local/bin/pandoc %s.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures --output %s/%s.pdf --table-of-contents --toc-depth 2 --template %s --highlight-style tango --latex-engine xelatex --variable geometry:margin=1in', pfx, dir_other, pfx, tex_template))

    # render docx
    render(md_all, 'word_document', output_file=sprintf('%s/%s.docx', dir_other, pfx))
      
    # open
    system(sprintf('open %s/%s.%s', dir_other, pfx, 'html'))
    system(sprintf('open %s/%s.%s', dir_other, pfx, 'pdf'))
    system(sprintf('open %s/%s.%s', dir_other, pfx, 'docx'))
