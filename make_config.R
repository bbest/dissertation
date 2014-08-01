# load libraries ----

library(knitr)
library(rmarkdown)

# set variables ----

cite_bib    = 'dissertation.bib'
cite_style  = 'csl/apa-single-spaced.csl' # get others at zotero.org/styles
files_cat   = list(
  preamble     = c('a_abstract', 'a_acknowledgements'),
  body         = c('a_intro','c_sdm','c_siting','c_range','c_routing','c_migration','x_conclusion', 'x_appendix'),
  epilogue     = c('x_biography'))
files_keep  = c('dissertation.tex','dissertation.md','README.md')
dir_dropbox = '~/Dropbox/dissertation'

title       = 'Marine Species Distribution Modeling and Spatial Decision Frameworks'
author      = 'Benjamin D. Best'
supervisor  = 'Patrick N. Halpin'
department  = 'Marine Science and Conservation'
school      = 'Duke University'
date        = Sys.Date()

# helper functions ----

# handle figure captions: numbering for all but pdf (todo: short description for toc)
fig_caption = local({
  if (!exists('doc_type')) doc_type = 'html' # default for quick Knit HTML of individual Rmd files
  i = 0
  function(x) {
    i <<- i + 1
    if (doc_type=='pdf'){
      paste(x)
    } else {
      paste('Figure ', i, '. ', x, sep = '')
    }
  }
})

mv_open = function(f, dir=dir_dropbox, mv_f=T, open_f=T){
  
  # move to dropbox folder
  if (mv_f){
    p = file.path(dir, f)
    file.copy(f, p, overwrite=T)
    unlink(f)
  } else {
    p = f
  }
  
  # open
  if (open_f){
    system(paste('open', p))
  } 
}

# render functions ----

cat_Rmd = function(
  files_Rmd = sprintf('%s.Rmd', c('a_title', 'a_abstract', files_cat$body)),
  out_Rmd   = 'dissertation.Rmd'){
  
  doc_type = 'Rmd'
  
  if (file.exists(out_Rmd)) unlink(out_Rmd)
  for (f_Rmd in files_Rmd){
    
    # strip YAML metadata header
    o = rmarkdown:::partition_yaml_front_matter(readLines(f_Rmd))
    
    # cat into single file
    cat(paste(c(o$body,'',''), collapse='\n'), file=out_Rmd, append=T)
  }
  
  # add references
  cat('\n\n# References {-}\n <!-- adding blank content for References to show up in toc -->', file=out_Rmd, append=T)
}

render_md = function(
  in_Rmd = 'dissertation.Rmd', 
  out_md = sprintf('%s.md', tools::file_path_sans_ext(in_Rmd)),
  open   = F){
  
  doc_type = 'md'
  environment(fig_caption)$i = 0 # reset counter
  
  render(
    in_Rmd, md_document(
      variant='markdown_github', 
      toc=T, toc_depth=3, 
      pandoc_args=c(
        '--bibliography', cite_bib,
        '--csl', cite_style)), 
    out_md, quiet=F)
  
  if (open) system(paste0('open', out_md))
}

render_html = function(
  in_Rmd   = 'dissertation.Rmd', 
  out_html = sprintf('%s.html', tools::file_path_sans_ext(in_Rmd)),
  move     = F,
  open     = T){
  
  doc_type = 'html'
  environment(fig_caption)$i = 0 # reset counter
  
  tmp_Rmd = tempfile('tempfile_', tmpdir=dirname(in_Rmd), fileext='.Rmd')
  if (in_Rmd != 'dissertation.Rmd'){
    
    # add title header
    title = tools::file_path_sans_ext(in_Rmd)
    file.copy('a_title.Rmd', tmp_Rmd)
    
    # copy body
    cat(readLines(in_Rmd), file=tmp_Rmd, sep='\n', append=T)
    
    # add references
    cat('\n\n# References {-}\n <!-- adding blank content for References to show up in toc -->', file=tmp_Rmd, append=T)
    
  } else {
    file.copy(in_Rmd, tmp_Rmd)
  }
  
  # render
  render(
    tmp_Rmd, output_format=html_document(
      number_sections=T, fig_width = 7, fig_height = 5, fig_retina = 2, fig_caption = T, smart=T,
      self_contained=T, theme='default',
      highlight='default', mathjax='default', template='default',
      toc=T, toc_depth=3,
      pandoc_args=c(
        '--bibliography', cite_bib,
        '--csl', cite_style)), 
    out_html, quiet=F)
  
  # move to dropbox and open
  unlink(tmp_Rmd)
  mv_open(out_html, mv_f=move, open_f=open)
}

render_word = function(
  in_Rmd   = 'dissertation.Rmd', 
  out_word = sprintf('%s.docx', tools::file_path_sans_ext(in_Rmd)),
  open     = T){
  
  doc_type = 'word'
  environment(fig_caption)$i = 0  # reset counter
  
  # render Rmd to docx
  render(
    in_Rmd, output_format=word_document(
      fig_caption = T, fig_width = 7, fig_height = 5, 
      highlight='default', reference_docx='default',
      pandoc_args=c(
        '--bibliography', cite_bib,
        '--csl', cite_style)), 
    out_word, quiet=F) 
  
  # move to dropbox and open
  mv_open(out_word, open_f=open)
  
  # manual post-hoc
  cat('todo manually:
    - style Title and Subtitle, center subtitle
    - Insert > Index and Tables > Table of Contents
    - Insert Watermark > text DRAFT, orientation 45, transparency 60
    - View > Sidebar > Document Map Pane
    - Add page numbering')
}

render_pdf   = function(
  files      = files_cat, 
  out_pdf    = 'dissertation.pdf',
  cite_style = 'csl/apa-no-doi-no-issue.csl',
  open       = T,
  cleanup    = T){
  
  doc_type = 'pdf'
  environment(fig_caption)$i = 0  # reset counter
  
  # Rmd to md
  for (f_Rmd in sprintf('%s.Rmd', unlist(files))){
    knit(f_Rmd)
  }
  
  # cat md body
  body_md = 'body.md'
  if (file.exists(body_md)) unlink(body_md)
  for (f_md in sprintf('%s.md', files$body)){ # f='a_intro'
    o = rmarkdown:::partition_yaml_front_matter(readLines(f_md))
    cat(paste(c(o$body,'',''), collapse='\n'), file=body_md, append=T)
  }
  
  # add references, single-spaced
  cat(
'
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
  for (f in c(files$preamble, 'body', files$epilogue)){
    system(paste(
      'pandoc', paste0(f, '.md'), '--chapters',
      '--bibliography', cite_bib, '--csl', cite_style,
      '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash',
      '--latex-engine=xelatex --to latex --output', paste0(f, '.tex')))
  }
  
  # note: any errors hang RStudio, so better to run from Terminal or with Complile PDF button in RStudio with dissertation.tex open
  system('pdflatex dissertation.tex; pdflatex dissertation.tex')
  
  # move to dropbox and open
  mv_open('dissertation.pdf', , open_f=open)
  
  # clean up
  if (cleanup){
    f_del = setdiff(list.files(pattern='^.*\\.(aux|lof|log|lot|out|toc|tex|md)$'), files_keep)
    for (f in f_del) unlink(f)
  }
}