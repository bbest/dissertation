# compile dissertation into:
#  - pdf:
#  - word:
#  - md:
#    - equations don't show
#  - html: 
#
# TODO:
#  - tex:
#    - swap hardcoded vars with below
#  - see rmarkdown::includes
#  - md:
#     - update fig_caption() to add caption for md
#     - add links to toc anchors to headers and links to toc using tolower hyphenated heading
#  - 

library(knitr)
library(rmarkdown)
#setwd('~/github/dissertation')

source('make_config.R')

# Rmd: base for other formats ----

dissertation_Rmd = 'dissertation.Rmd'
if (file.exists(dissertation_Rmd)) unlink(dissertation_Rmd)
for (f_Rmd in sprintf('%s.Rmd', c('a_title', 'a_abstract', files$body))){ # f='intro'
  cat(paste(c(readLines(f_Rmd),'',''), collapse='\n'), file=dissertation_Rmd, append=T)
}

# add references, single-spaced
cat('\n\n# References {-}\n <!-- adding to show up in toc -->', file=dissertation_Rmd, append=T)

# md: github flavored ----
doc_type = 'md'
environment(fig_caption)$i = 0 # reset counter

# render
render(
  dissertation_Rmd, output_format=md_document(
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
  dissertation_Rmd, output_format=html_document(
    number_sections=T, fig_width = 7, fig_height = 5, fig_retina = 2, fig_caption = T, smart=T,
    self_contained=T, theme='default',
    highlight='default', mathjax='default', template='default',
    toc=T, toc_depth=3,
    pandoc_args=c(
      '--bibliography', cite_bib,
      '--csl', cite_style)), quiet=F)

# move to dropbox and open
mv_open('dissertation.html')

# word: track changes with committee ----
doc_type = 'word'
environment(fig_caption)$i = 0 # reset counter

# render Rmd to docx
render(
  dissertation_Rmd, output_format=word_document(
    fig_caption = T, fig_width = 7, fig_height = 5, 
    highlight='default', reference_docx='default',
    pandoc_args=c(
      '--bibliography', cite_bib,
      '--csl', cite_style)), quiet=F)

# move to dropbox and open
mv_open('dissertation.docx')

# manual post-hoc
cat('todo manually:
    - style Title and Subtitle, center subtitle
    - Insert > Index and Tables > Table of Contents
    - Insert Watermark > text DRAFT, orientation 45, transparency 60
    - View > Sidebar > Document Map Pane
    - Add page numbering')

# pdf: final submission to graduate school ----
doc_type = 'pdf'
environment(fig_caption)$i = 0             # reset counter

# Rmd to md
for (f in unlist(files)){ # f_rmd = 'intro.Rmd'  
  knit(paste0(f,'.Rmd'))
}

# override bibliography style
cite_style = 'csl/apa-no-doi-no-issue.csl' 

# cat md body
body_md = 'body.md'
if (file.exists(body_md)) unlink(body_md)
for (f in files$body){ # f='a_intro'
  o = rmarkdown:::partition_yaml_front_matter(readLines(paste0(f,'.md')))
  cat(paste(c(o$body,'',''), collapse='\n'), file=body_md, append=T)
}

# add references, single-spaced
cat('

# References {-}

<!-- add hanging indent, per https://groups.google.com/d/msg/pandoc-discuss/4SKA5E11rO4/fDGiNSOsIMkJ, https://groups.google.com/d/msg/pandoc-discuss/SUZ08-Kc6Og/ce0icuemwkkJ -->
\\noindent
\\vspace{-2em}
\\setlength{\\parindent}{-0.3in}
\\setlength{\\leftskip}{0.3in}
\\setlength{\\parskip}{10pt}
    
<!-- single space -->
\\normalbaselines

', file=body_md, append=T)

# md to tex
for (f in c(files$preamble, 'body', files$epilogue)){ # f = 'body'
  system(paste(
    'pandoc', paste0(f, '.md'), '--chapters',
    '--bibliography', cite_bib, '--csl', cite_style,
    '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash',
    '--latex-engine=xelatex --to latex --output', paste0(f, '.tex')))
}

# note: any errors hang RStudio, so better to run from Terminal or with Complile PDF button in RStudio with dissertation.tex open
system('pdflatex dissertation.tex; pdflatex dissertation.tex')

# move to dropbox and open
mv_open('dissertation.pdf')

# clean up
f_del = setdiff(list.files(pattern='^.*\\.(aux|lof|log|lot|out|toc|tex|md)$'), files_keep)
for (f in f_del) unlink(f)
