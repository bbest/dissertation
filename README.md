# phd_thesis

This repository is for drafting my PhD thesis at Duke University.

Here's the draft thesis rendered in various formats:

- [pdf](https://www.dropbox.com/s/k1g47p1jejw8jk1/thesis.pdf)
- [docx](https://www.dropbox.com/s/xzgsxaghxkrj5e6/thesis.docx)
- [html](https://www.dropbox.com/s/jml6ybe4qa1x14k/thesis.html)

## Knitting the document

This thesis is being knitted into a scientifically reproducible document using the following techniques:

- **markdown**. Rmarkdown.

- **citations**. Zotero and pandoc. Use better bibtex Zotero extension to enable drag-and-drop of citation into document in Pandoc format.

```{r run, eval=FALSE}
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
system(sprintf('open %s/%s.%s', dir_other, pfx, 'html'))

# render pdf
tex_template = '/Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex'
tex_template = 'dissertation.tex'
tex_template = 'thesis_template.tex'
#render(md_all, 'pdf_document', output_file=sprintf('%s/%s.pdf', dir_other, pfx), output_options=list(toc='true', fig_caption='true'))
# /usr/local/bin/pandoc index.utf8.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash --output ~/github/phd_thesis/index.pdf --table-of-contents --toc-depth 2 --template /Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex --highlight-style tango --latex-engine pdflatex --variable geometry:margin=1in
tex_template = '/Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex'
cmd = paste0(
  '/usr/local/bin/pandoc ', pfx, '.md \\\n',
  '--to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures \\\n',
  '--output ', dir_other, '/', pfx, '.pdf \\\n',
  '--table-of-contents --toc-depth 2 --template ', tex_template, ' \\\n',
  '--highlight-style tango --latex-engine xelatex --variable geometry:margin=1in')
tex_template = '/Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex'

tex_template = '~/github/phd_thesis/thesis_template.latex'
cmd = paste0(
  '/usr/local/bin/pandoc ', pfx, '.md \\\n',
  '--to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures \\\n',
  '--output ', dir_other, '/', pfx, '.pdf \\\n',
  '--table-of-contents --toc-depth 2 --template ', tex_template, ' \\\n',
  '--highlight-style tango --latex-engine xelatex --variable geometry:margin=1in')
cat(cmd)
system(cmd)
system(sprintf('open %s/%s.%s', dir_other, pfx, 'pdf'))

# render docx
render(md_all, 'word_document', output_file=sprintf('%s/%s.docx', dir_other, pfx))
system(sprintf('open %s/%s.%s', dir_other, pfx, 'docx'))  
```

