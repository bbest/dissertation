# TODO:
#  - pdf/tex:
#    - enable additional argument for entry in list of figures per latex \caption[short]{long}
#  - md:
#     - link toc to headers
#  - see rmarkdown::includes

# load libraries ----

library(knitr)
library(rmarkdown)
library(brew)

# set variables ----

# strings for substitution
title       = 'Species Distribution Modeling and Spatial Decision Frameworks for Marine Megafauna'
author      = 'Benjamin D. Best'
supervisor  = 'Patrick N. Halpin'
department  = 'Marine Science and Conservation'
school      = 'Duke University'
member1     = 'Dean L. Urban'
member2     = '[TBD]'
member3     = 'Falk Huettman'

# paths to Rmd and bibliography files. see other cite styles at zotero.org/styles.
cite_bib         = 'dissertation.bib'
cite_style_pdf   = 'csl/apa-no-doi-no-issue.csl'
cite_style_other = 'csl/apa-single-spaced.csl'
dir_notgit       = '~/Dropbox/dissertation'
files_keep       = c('dissertation.brew.tex','dissertation.tex','dissertation.md','README.md')
files_pdf        = list(
  preamble = c('a_abstract', 'a_acknowledgements'),
  body     = c('a_intro','c_sdm','c_siting','c_range','c_routing','c_migration','x_conclusion', 'x_appendix'),
  epilogue = c('x_biography'))
files_other     = c('a_title', 'a_abstract', files_pdf$body)
file_html_head  = 'a_title'

# helper functions ----

# figures
fig = local({
  
  # initialize
  if (!exists('doc_type')) doc_type = 'html'
  i = 0
  figs = numeric(0)
  
  function(short, img, long) {
    
    # set counter
    i    <<- i + 1
    figs <<- c(figs, setNames(i, short))
    
    # return text
    if (doc_type=='pdf'){
      #sprintf('![%s](%s)<a name="%s"></a>', long, img, short))
      return(sprintf(paste(
        '\\begin{figure}[htbp]',
        '\\centering',
        '\\includegraphics[width=6in]{%s}',
        '\\caption{%s}',
        '\\label{%s}',
        '\\end{figure}', collapse='\n'),
        img, long, short))
    } else if (doc_type=='md'){
      return(sprintf('<a name="%s"></a>\n\n![Figure %d. %s](%s) <br />\\\n_Figure %d. %s_', short, i, long, img, i, long))
    } else {
      return(sprintf('<a name="%s"></a>\n\n![Figure %d. %s](%s)', short, i, long, img))
    }
  }
})

# tables
tbl = local({
  
  # initialize
  if (!exists('doc_type')) doc_type = 'html'
  j = 0
  tbls = numeric(0)
  
  function(short, long) {
    
    # set counter
    j    <<- j + 1
    tbls <<- c(tbls, setNames(j, short))
    
    # return text
    if (doc_type=='pdf'){
      return(sprintf('Table: %s <a name="%s"></a>', long, short))
    } else {
      return(sprintf('Table %d: %s <a name="%s"></a>', j, long, short))
    }
  }
})

# reset counters for tables and figures
reset_fig_tbl = function(doc_type){
  environment(fig)$i        = 0
  environment(tbl)$j        = 0
  environment(fig)$figs     = numeric(0)
  environment(tbl)$tbls     = numeric(0)
  environment(fig)$doc_type = doc_type
  environment(tbl)$doc_type = doc_type
}

# reference table or figure
ref = function(short){
  # NOTE: figure or table has to preceed ref. for now.
  
  pfx = substr(short, 1, 3)
  if (!exists('doc_type')) stop('Need to set global variable doc_type for ref() to work.')

  labels = c(fig='Figure', tbl='Table')
  if (!pfx %in% names(labels)) stop(sprintf("The function ref failed because the prefix '%s' for ref('%s') is not of the allowed short figure/table prefixes: %s.", pfx, short, paste(names(labels), collapse=', ')))
  if (doc_type == 'pdf'){
    return(sprintf('%s \\ref{%s}', labels[pfx], short))
  } else {
    return(sprintf('[%s %s](#%s)', labels[pfx], environment(fig)$figs[short], short))
  }
}

# move and open file
mv_open = function(f, dir=dir_notgit, mv_f=T, open_f=T){
  
  # move to dropbox folder, outside of git versioning
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
  files_Rmd = sprintf('%s.Rmd', files_other),
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
  open   = F,
  cite_style = cite_style_other){
  
  doc_type <<- 'md'
  reset_fig_tbl(doc_type)
  
  # Rmd to md
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
  open     = T,
  cite_style = cite_style_other,
  header   = file_html_head){
  
  doc_type <<- 'html'
  reset_fig_tbl(doc_type)
  
  cat('render_html:\n','  in_Rmd:',in_Rmd,'\n','  header:',header,'\n')
  
  tmp_Rmd = tempfile('tempfile_', tmpdir=dirname(in_Rmd), fileext='.Rmd')
  if (in_Rmd != 'dissertation.Rmd'){
    
    cat('header:',header,'\n')
    
    # add title header
    title = in_Rmd
    file.copy(sprintf('%s.Rmd', header), tmp_Rmd)
    
    # copy body
    cat(readLines(in_Rmd), file=tmp_Rmd, sep='\n', append=T)
    
    # add references
    cat('\n\n# References {-}\n <!-- adding blank content for References to show up in toc -->', file=tmp_Rmd, append=T)
    
  } else {
    file.copy(in_Rmd, tmp_Rmd)
  }
  
  # Rmd to html
  render(
    tmp_Rmd, output_format=html_document(
      number_sections=T, fig_width = 7, fig_height = 5, fig_retina = 2, fig_caption = T, smart=T,
      self_contained=T, theme='default',
      highlight='default', mathjax='default', template='default',
      toc=T, toc_depth=3,
      pandoc_args=c(
        '--bibliography', cite_bib,
        '--csl', cite_style)), 
    out_html, clean=T, quiet=F)
  
  # move to dropbox and open
  unlink(tmp_Rmd)
  mv_open(out_html, mv_f=move, open_f=open)
}

render_word = function(
  in_Rmd   = 'dissertation.Rmd', 
  out_word = sprintf('%s.docx', tools::file_path_sans_ext(in_Rmd)),
  open     = T,
  cite_style = cite_style_other){
  
  doc_type <<- 'word'
  reset_fig_tbl(doc_type)
  
  # Rmd to docx
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
  cat('to be handled by dissertation_quick_fixes macro (see dissertation/README):
    - resize all pictures to 6 inch width
    - Insert > Index and Tables > Table of Contents\n')
  cat('to do manually:
    - style Title and Subtitle, center subtitle
    - Insert Watermark > text DRAFT, orientation 45, transparency 60
    - View > Sidebar > Document Map Pane
    - Add page numbering\n')
}

render_pdf   = function(
  files      = files_pdf, 
  out_pdf    = 'dissertation.pdf',
  cite_style = cite_style_pdf,
  open       = T,
  cleanup    = T,
  debug      = F){
  
  doc_type <<- 'pdf'
  reset_fig_tbl(doc_type)
  
  # Rmd to md
  for (f_Rmd in sprintf('%s.Rmd', unlist(files))){
    knit(f_Rmd)
  }
  
  # cat md body
  body_md = 'body.md'
  if (file.exists(body_md)) unlink(body_md)
  for (f_md in sprintf('%s.md', files$body)){
    o = rmarkdown:::partition_yaml_front_matter(readLines(f_md))
    cat(paste(c(o$body,'',''), collapse='\n'), file=body_md, append=T)
  }
  
  # add references, single-spaced, hanging indent
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
  
  # substitute variables: dissertation.brew.tex -> dissertation.tex
  brew('dissertation.brew.tex', 'dissertation.tex')  

  # note: any errors hang RStudio, so better to run from Terminal or with Complile PDF button in RStudio with dissertation.tex open
  if (!debug) {
    system('pdflatex dissertation.tex; pdflatex dissertation.tex')

    # move to dropbox and open
    mv_open('dissertation.pdf', , open_f=open)
  
    # clean up
    if (cleanup){
      f_del = setdiff(list.files(pattern='^.*\\.(aux|lof|log|lot|out|toc|tex|md)$'), files_keep)
      for (f in f_del) unlink(f)
    }
  } else {
    cat('In debug=T mode, so next run on terminal:n\n  pdflatex dissertation.tex; pdflatex dissertation.tex\n\n')
  }
}