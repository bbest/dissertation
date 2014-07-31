# compile thesis into:
#  - pdf:
#  - word:
#  - md:
#    - equations don't show
#  - html: 
#
# TODO:
#  - see rmarkdown::includes
#  - md:
#     - update fig_caption() to add caption for md
#     - add links to toc anchors to headers and links to toc using tolower hyphenated heading
#  - 

library(knitr)
library(rmarkdown)

setwd('~/github/phd_thesis')

# set variables ----
doc_type    = 'pdf'
cite_bib    = 'phd_thesis.bib'
cite_style  = 'csl/global-ecology-and-biogeography.csl' # 'csl/conservation-letters.csl' # 'csl/conservation-biology.csl'
files          = list(
  preamble     = c('a_abstract', 'a_acknowledgements'),
  body         = c('a_intro','c_sdm','c_siting','c_range','c_routing','c_migration','x_conclusion', 'x_appendix'),
  epilogue     = c('x_biography'))
files_keep  = c('thesis.tex','thesis.md','README.md')
dir_dropbox = '~/Dropbox/phd_thesis'

title       = 'Marine Species Distribution Modeling and Spatial Decision Frameworks'
author      = 'Benjamin D. Best'
supervisor  = 'Patrick N. Halpin'
department  = 'Marine Science and Conservation'
school      = 'Duke University'

# helper functions ----

# handle figure captions: numbering for all but pdf (todo: short description for toc)
fig_caption = local({
  if (!exists('doc_type')) stop("First set doc_type variable doc_type='pdf|md|html|docx' before rendering.")
  i = 0
  function(x) {
    i <<- i + 1
    if (doc_type=='pdf'){
      # TODO: enable 2nd argument for short entry in list of figures per latex \caption[short]{long}
      paste(x)
    } else {
      paste('Figure ', i, '. ', x, sep = '')
    }
  }
})

# move to dropbox folder and open
mv_open = function(f, dir=dir_dropbox, open_f=T){
  p = file.path(dir, f)
  file.copy(f, p, overwrite=T)
  unlink(f)
  if (open_f) system(paste('open', p))
}

# Rmd: base for other formats ----

thesis_Rmd = 'thesis.Rmd'
if (file.exists(thesis_Rmd)) unlink(thesis_Rmd)
for (f_Rmd in sprintf('%s.Rmd', c('a_title', 'a_abstract', files$body))){ # f='intro'
  cat(paste(c(readLines(f_Rmd),'',''), collapse='\n'), file=thesis_Rmd, append=T)
}

# add references, single-spaced
cat('\n\n# References {-}\n <!-- adding to show up in toc -->', file=thesis_Rmd, append=T)

# md: github flavored ----
doc_type = 'md'
environment(fig_caption)$i = 0 # reset counter

# render
render(
  thesis_Rmd, output_format=md_document(
    variant='markdown_github', 
    toc=T, toc_depth=3, 
    pandoc_args=c(
      '--bibliography', cite_bib,
      '--csl', cite_style)), quiet=F)

# html: quick web view ----
doc_type = 'html'
environment(fig_caption)$i = 0 # reset counter

# render
render(
  thesis_Rmd, output_format=html_document(
    number_sections=T, fig_width = 7, fig_height = 5, fig_retina = 2, fig_caption = T, smart=T,
    self_contained=T, theme='default',
    highlight='default', mathjax='default', template='default',
    toc=T, toc_depth=3,
    pandoc_args=c(
      '--bibliography', cite_bib,
      '--csl', cite_style)), quiet=F)

# move to dropbox and open
mv_open('thesis.html')

# word: track changes with committee ----
doc_type = 'word'
environment(fig_caption)$i = 0 # reset counter

# render Rmd to docx
render(
  thesis_Rmd, output_format=word_document(
    fig_caption = T, fig_width = 7, fig_height = 5, 
    highlight='default', reference_docx='default',
    pandoc_args=c(
      '--bibliography', cite_bib,
      '--csl', cite_style)), quiet=F)

# move to dropbox and open
mv_open('thesis.docx')

# manual post-hoc
cat('todo manually:
    - style Title and Subtitle, center subtitle
    - Insert > Index and Tables > Table of Contents
    - Insert Watermark > text DRAFT, orientation 45, transparency 60
    - View > Sidebar > Document Map Pane
    - Add page numbering')

# pdf: final submission to graduate school ----
doc_type = 'pdf'
environment(fig_caption)$i = 0 # reset counter

# Rmd to md
for (f in unlist(files)){ # f_rmd = 'intro.Rmd'  
  knit(paste0(f,'.Rmd'))
}

# cat md body
body_md = 'body.md'
if (file.exists(body_md)) unlink(body_md)
for (f in files$body){ # f='intro'
  cat(paste(c(readLines(paste0(f,'.md')),'',''), collapse='\n'), file=body_md, append=T)
}

# add references, single-spaced
cat('\\normalbaselines \n\n# References\n', file=body_md, append=T)

# md to tex
for (f in c(files$preamble, 'body', files$epilogue)){ # f = 'body'
  system(paste(
    'pandoc', paste0(f, '.md'), '--chapters',
    '--bibliography', cite_bib, '--csl', cite_style,
    '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash',
    '--latex-engine=xelatex --to latex --output', paste0(f, '.tex')))
}

# note: any errors hang RStudio, so better to run from Terminal or with Complile PDF button in RStudio with thesis.tex open
system('pdflatex thesis.tex; pdflatex thesis.tex')

# move to dropbox and open
mv_open('thesis.pdf')

# clean up
f_del = setdiff(list.files(pattern='^.*\\.(aux|lof|log|lot|out|toc|tex|md)$'), files_keep)
for (f in f_del) unlink(f)
