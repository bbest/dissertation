library(knitr)
library(rmarkdown)

setwd('~/github/phd_thesis')

# set variables ----
doc_type   = 'pdf'
cite_style = 'csl/global-ecology-and-biogeography.csl' # 'csl/conservation-letters.csl' # 'csl/conservation-biology.csl'
files          = list(
  preamble     = c('abstract', 'acknowledgements'),
  body         = c('intro','robust-sdm','decision-map','range-map','conservation-routing','seasonal-migration','conclusion', 'appendix'),
  epilogue     = c('biography'))

title      = 'Marine Species Distribution Modeling and Spatial Decision Frameworks'
author     = 'Benjamin D. Best'
supervisor = 'Patrick N. Halpin'
department = 'Marine Science and Conservation'
school     = 'Duke University'

# helper functions ----

# incremental Figure Numbers for md / html / docx, vs alternate short description for pdf
fig_caption = local({
  if (!exists('doc_type')) stop("First set doc_type variable doc_type='pdf|md|html|docx' before rendering.")
  i = 0
  browser()
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


# render pdf for Grad School final submission ----
doc_type = 'pdf'
  
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
      '--bibliography=phd_thesis.bib', paste0('--csl=', cite_style),
      '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash',
      '--latex-engine=xelatex --to latex --output', paste0(f, '.tex')))
}

# turn off chapter numbering outside body
for (f_tex in sprintf('%s.tex', c(files$preamble, files$epilogue))){ # f_tex = 'abstract.tex'
  a = readLines(f_tex)
  b = sub('\\\\chapter\\{(.*)\\}\\\\label\\{(.*)\\}', '\\\\chapter*\\{\\1}\\\\label\\{\\2}\n\\\\addcontentsline{toc}{chapter}{\\1}', a)
  writeLines(b, f_tex)
}

# note: any errors hang RStudio, so better to run from Terminal or with Complile PDF button in RStudio with thesis.tex open
system('pdflatex thesis.tex; pdflatex thesis.tex; open thesis.pdf')

# clean up
f_del = setdiff(list.files(pattern='^.*\\.(aux|lof|log|lot|out|toc|tex|md)$'), c('thesis.tex','thesis.md'))
for (f in f_del) unlink(f)

  

# render word docx for track changes with committee ----
doc_type = 'word'
  
# Rmd to md
for (f_Rmd in sprintf('%s.Rmd', c('title',unlist(files)))){ # f_rmd = 'intro.Rmd'  
  knit(f_Rmd)
}

# cat md body
body_md = 'body.md'
if (file.exists(body_md)) unlink(body_md)
for (f in c('title', 'abstract', files$body)){ # f='intro'
  cat(paste(c(readLines(paste0(f,'.md')),'',''), collapse='\n'), file=body_md, append=T)
}

# add references
cat('\n\n# References\n', file=body_md, append=T)

# md to docx
system(paste(
    'pandoc', body_md, '--chapters',
    '--bibliography=phd_thesis.bib', paste0('--csl=', cite_style),
    '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash', # -implicit_figures
    '--highlight-style tango',
    '--latex-engine=xelatex --to docx --output', 'thesis.docx', '; open thesis.docx'))

# manual post-hoc
cat('now manually:
    - style Title and Subtitle, center subtitle
    - Insert > Index and Tables > Table of Contents
    - Insert Watermark > text DRAFT, orientation 45, transparency 60
    - View > Sidebar > Document Map Pane')

# clean up
f_del = setdiff(list.files(pattern=glob2rx('*.md')), 'thesis.md')
for (f in f_del) unlink(f)
  

# render markdown, github flavored ----
doc_type = 'md'

thesis_Rmd = 'thesis.Rmd'
if (file.exists(thesis_Rmd)) unlink(thesis_Rmd)
for (f_Rmd in sprintf('%s.Rmd', c('title', 'abstract', files$body))){ # f='intro'
  cat(paste(c(readLines(f_Rmd),'',''), collapse='\n'), file=thesis_Rmd, append=T)
}

# add references, single-spaced
cat('\n\n# References\n', file=thesis_Rmd, append=T)

# added yaml
---
title: "thesis title"
author: "Ben Best"
date: "July 30, 2014"
output: 
  md_document:
    toc: true
bibliography: phd_thesis.bib
csl: csl/nature.csl
---
render(thesis_Rmd, output_format='md_document', quiet=F)
# /usr/local/bin/pandoc thesis.utf8.md --to markdown_strict --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash --output thesis.md --filter /usr/local/bin/pandoc-citeproc --standalone --table-of-contents --toc-depth 3 --bibliography phd_thesis.bib 
# pandoc --format=markdown_github