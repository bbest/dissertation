library(knitr)
library(rmarkdown)

setwd('~/github/phd_thesis')

# set variables
doc_type  = 'pdf'
cite_style = 'csl/conservation-letters.csl' # 'csl/conservation-biology.csl'
files          = list(
  preamble     = c('abstract', 'acknowledgements'),
  body         = c('intro','robust-sdm','decision-map','range-map','conservation-routing','seasonal-migration','conclusion', 'appendix'),
  epilogue     = c('biography'))

# helper functions ----

# incremental Figure Numbers for md / html / docx, vs alternate short description for pdf
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


# render pdf ----
if (doc_type=='pdf'){
  
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
  
  
  cite_style = 'csl/global-ecology-and-biogeography.csl'
  
  
  for (f in c(files$preamble, 'body', files$epilogue)){ # f = 'body'
    system(paste(
        'pandoc', paste0(f, '.md'), '--chapters',
        '--bibliography=phd_thesis.bib', paste0('--csl=', cite_style),
        '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash',
        '--latex-engine=xelatex -t latex -o', paste0(f, '.tex')))
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
  f_del = setdiff(list.files(pattern='^.*\\.(aux|lof|log|lot|out|toc|tex|md)$'), 'thesis.tex')
  for (f in f_del) unlink(f)
  
}


# render markdown, github flavored and references per chapter ----
# pandoc --format=markdown_github

# render markdown, github flavored and references per chapter ----
# pandoc --format=markdown_github

# if (doc_type=='md'){
# 
# # Rmd to md
# for (f in unlist(files)){ # f_rmd = 'intro.Rmd'  
#   knit(paste0(f,'.Rmd'))
# }
# 
# # cat md body
# body_md = 'body.md'
# if (file.exists(body_md)) unlink(body_md)
# for (f in files$body){ # f='intro'
#   cat(paste(c(readLines(paste0(f,'.md')),'',''), collapse='\n'), file=body_md, append=T)
# }

# 
# 
#   for (f in fn_in){ # f = 'intro'
#   f_Rmd = paste0(f,'.Rmd')
#   f_md  = paste0(f,'.md')
#   
#   # Rmd to md, with References as md
#   render(f_Rmd, output_format='md_document', quiet=F)
#   
#   # read md and tex versions of file 
#   s_md  = readLines(f_md)
#   s_tex = system(sprintf('pandoc %s --filter pandoc-citeproc --to latex', f_Rmd), intern=T)
#   
#   idx = which(s_md=='References')
#   
#   # chunk out before References to md, after to tex, wrapped in to singlespace tex command
#   cat(
#     paste(
#       c(
#         s_md[1:(which(s_md=='References') + 2)],
#         '\\begin{singlespace}\n',
#         s_tex[(which(s_tex=='\\subsection*{References}\\label{references}') + 2):length(s_tex)],
#         '\n\\end{singlespace}\n'), 
#       collapse='\n'), 
#     file=md_out, append=T)
# }

# # md to pdf
# render(md_out, output_format='pdf_document', quiet=F)


# for (f_tex in list.files(pattern=glob2rx('*.tex'))){
#   f = tools::file_path_sans_ext(f_tex)
#   cat(f,'\n')
#   system(sprintf('pandoc %s.tex -t markdown -o %s.md', f, f))
# }
# 
# setwd('~/github/phd_thesis/duke_template')
# for (f_tex in list.files(pattern=glob2rx('*.md'))){
#   f = tools::file_path_sans_ext(f_tex)
#   cat(f,'\n')
#   system(sprintf('pandoc %s.md -t latex -o %s.tex', f, f))
# }
# 
# for ( f in list.files(pattern='^.*\\.(aux|log)$') ) unlink(f)
# 
# # compile from md to tex to dissertation.text to pdf
# setwd('~/github/phd_thesis')
# for ( f in setdiff(list.files(pattern=glob2rx('dissertation.*')), c('dissertation.tex')) ) unlink(f)
# 
# 
# duke_template/chRegularLook.tex:        \label{goodbye}
# duke_template/chRegularLook.tex:        \label{goodbye_b}
# 
# system('
# pdflatex dissertation.tex
# pdflatex dissertation.tex
# bibtex dissertation
# pdflatex dissertation.tex
# pdflatex dissertation.tex
# 
# pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=12pt -V documentclass:book -V papersize:a4paper 
# -V classoption:openright --chapters --bibliography=papers.bib --csl="csl/nature.csl" title.md summary.md 
# zusammenfassung.md acknowledgements.md toc.md "introduction/intro1.md" "introduction/intro2.md" chapter2_paper.md 
# chapter3_extra_results.md chapter4_generaldiscussion.md appendix.md references.md -o "phdthesis.pdf"
# 
# 
# pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=12pt -V documentclass:book -V papersize:a4paper 
# -V classoption:openright --chapters --bibliography=papers.bib --csl="csl/nature.csl" title.md summary.md
# zusammenfassung.md acknowledgements.md toc.md "introduction/intro1.md" "introduction/intro2.md" chapter2_paper.md
# chapter3_extra_results.md chapter4_generaldiscussion.md appendix.md references.md -o "phdthesis.pdf"
# ')
# 
# system('
# pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=12pt -V documentclass:book -V papersize:a4paper 
# -V classoption:openright --chapters --bibliography=papers.bib --csl="csl/nature.csl" title.md summary.md
# zusammenfassung.md acknowledgements.md toc.md "introduction/intro1.md" "introduction/intro2.md" chapter2_paper.md
# chapter3_extra_results.md chapter4_generaldiscussion.md appendix.md references.md -o "phdthesis.pdf"
# ')
# 
# 
# # --- other
# 
