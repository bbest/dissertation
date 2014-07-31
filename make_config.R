# set variables ----

cite_bib    = 'dissertation.bib'
cite_style  = 'csl/apa-single-spaced.csl' # get others at zotero.org/styles
files          = list(
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
