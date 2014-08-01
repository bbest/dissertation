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
fig = local({
  
  # initialize
  if (!exists('doc_type')) doc_type = 'html'
  i = 0
  figs = numeric(0)
  
  function(short, img, long) {
    
    # set counter
    i    <<- i + 1
    figs <<- c(figs, setNames(i, short))
    cat(sprintf('fig\n i: %d \n  short: %s \n  figs: %s \n  doc_type: %s \n', i, short, dput(figs), doc_type)) # DEBUG
    
    # return text
    if (doc_type=='pdf'){
      #sprintf('![%s](%s)<a name="%s"></a>', long, img, short))
      return(sprintf(paste(
        '\\begin{figure}[htbp]',
        '\\centering',
        '\\includegraphics{%s}',
        '\\caption{%s}',
        '\\label{%s}',
        '\\end{figure}', collapse='\n'),
        img, long, short))
    } else if (doc_type=='md'){
      return(sprintf('<a name="%s"></a>\n\n![Figure %d. %s](%s)\\\n_Figure %d. %s_', short, i, long, img, i, long))
    } else {
      return(sprintf('<a name="%s"></a>\n\n![Figure %d. %s](%s)', short, i, long, img))
    }
  }
})

tbl = local({
  
  # initialize
  if (!exists('doc_type')) doc_type = 'html'
  j = 0
  tbls = numeric(0)
  
  function(short, long) {
    
    # set counter
    j    <<- j + 1
    tbls <<- c(tbls, setNames(j, short))
    cat(sprintf('tbl\n  j: %d \n  short: %s \n  tbls: %s \n  doc_type: %s \n', j, short, dput(tbls), doc_type)) # DEBUG
    
    # return text
    if (doc_type=='pdf'){
      return(sprintf('Table: %s <a name="%s"></a>', long, short))
    } else {
      return(sprintf('Table %d: %s <a name="%s"></a>', j, long, short))
    }
  }
})

reset_fig_tbl = function(doc_type){
  environment(fig)$i    = 0
  environment(tbl)$j    = 0
  environment(fig)$figs = numeric(0)
  environment(tbl)$tbls = numeric(0)
  environment(fig)$doc_type = doc_type
  environment(tbl)$doc_type = doc_type
}

ref = function(short){
  
  pfx = substr(short, 1, 3)
  if (!exists('doc_type')) stop('Need to set global variable doc_type for ref() to work.')
  cat(sprintf('ref\n  short: %s\n  pfx: %s \n figs: %s \n tbls: %s \n  doc_type: %s \n', short, pfx, dput(environment(fig)$figs), dput(environment(tbl)$tbls), doc_type)) # DEBUG

  labels = c(fig='Figure', tbl='Table')
  if (!pfx %in% names(labels)) stop(sprintf("The function ref failed because the prefix '%s' for ref('%s') is not of the allowed short figure/table prefixes: %s.", pfx, short, paste(names(labels), collapse=', ')))
  if (doc_type == 'pdf'){
    return(sprintf('%s \\ref{%s}', labels[pfx], short))
  } else {
    return(sprintf('[%s %s](#%s)', labels[pfx], environment(fig)$figs[short], short))
  }
}

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
  
  doc_type <<- 'Rmd'
  
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
  
  doc_type <<- 'md'
  reset_fig_tbl(doc_type)
  
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
  
  doc_type <<- 'html'
  reset_fig_tbl(doc_type)
  
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
    out_html, clean=F, quiet=F)
  
  # move to dropbox and open
  unlink(tmp_Rmd)
  mv_open(out_html, mv_f=move, open_f=open)
}

render_word = function(
  in_Rmd   = 'dissertation.Rmd', 
  out_word = sprintf('%s.docx', tools::file_path_sans_ext(in_Rmd)),
  open     = T){
  
  doc_type <<- 'word'
  reset_fig_tbl(doc_type)
  
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
  
  doc_type <<- 'pdf'
  reset_fig_tbl(doc_type)
  
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