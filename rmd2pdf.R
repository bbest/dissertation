#' @title Render an R Markdown file into a PDF
#' 
#' @description Use knitr and pandoc to convert an R Markdown file into a
#' TeX file, and run xelatex (and biber) on the converted file to produce a PDF.
#'  
#' @param file the location and name of the R Markdown file to be rendered.
#' @param template the location and name of the pandoc latex template to use
#' during the conversion from R Markdown to TeX. 
#' @param biber logical flag indicating if biber (or biblatex) backend should
#' be run after xelatex is called.
#' @param saveTmpFiles logical flag indicating if intermediary files should be 
#' kept after PDF file is created. If \code{FALSE} the files are deleted.
#' 
#' @details 
#' There's no markdown (yet) that allows for LaTeX preamble to be specified
#' inside a .md file. To get around this, we have to redefine a Pandoc latex
#' template using the preamble we'd normally use if we were using the LaTeX or
#' knitr templates. The template, \code{inst/rmarkdown/thesis_template.latex},
#' is a modification of the default template found via
#' \code{pandoc -D latex}. If you need to add more packages to your preamble,
#' e.g. \code{\\usepackage{amsmath}}, modify \code{thesis_template.latex} 
#' accordingly.
#' 
#' Temporary files (e.g. .md's, .log's, .aux's, etc.) are stored in a temporary 
#' (sub)directory, \code{tmp/}.
#' @import rmarkdown
#' @export
#' 
#' @return The name of the xelatex rendered PDF.
#' 
#' @examples
#' \dontrun{
#' setwd("inst/rmarkdown")
#' rmd2pdf()
#' }
rmd2thesis <- function(
  dir_in = '~/github/ucbthesis/inst/bbest',
  fn_in = c(
    'abstract','dedication','intro','robust-sdm','decision-map','range-map','conservation-routing','seasonal-migration'
  ), 
  fn_out = 'thesis',
  do_pdf = T,
  tex_template = 'thesis_template.latex',
  saveTmpFiles = FALSE,
  biber=TRUE) {
  
  # DEBUG
  dir_in = '~/github/ucbthesis/inst/bbest'
  fn_in = c(
    'abstract', 'dedication',' intro','robust-sdm','decision-map','range-map','conservation-routing','seasonal-migration'
  )
  fn_out = 'thesis'
  do_pdf = T
  tex_template = 'thesis_template.latex'
  saveTmpFiles = FALSE
  biber=TRUE
  library(rmarkdown) # library(stringr)
  
  if (nchar(Sys.which('xelatex')) == 0) {
    stop(paste(
      'Must have xelatex installed and accesible from the command line',
      ' to run this function.'))
  }
  
  if (biber && nchar(Sys.which('biber')) == 0) {
    stop(paste(
      'Must have biber installed and accesible from the command line',
      'to run this function.'))
  }
  
  if (nchar(Sys.which('pandoc')) == 0) {
    stop(paste(
      'Must have pandoc installed and accesible from the command line',
      'to run this function.')
    )
  }
  
  #   cat("Working in", getwd(), "...\n")  
  #   filename <- tail(
  #                 str_split(
  #                   string = str_split(file, ".(R|r)md", n=2)[[1]][1],
  #                   pattern = "/")[[1]],
  #                 n=1)
  
  #   cat("Making ./tmp/ directory to hold temporary files...\n")
  #   system("mkdir tmp")
  #if (!file.exists(dir_tmp)) dir.create(dir_tmp, recursive=T)
  
  #pfx_in  = paste(sapply(rmd_in, function(x) tools::file_path_sans_ext(basename(x))), collapse=', ')
  setwd(dir_in)
  # sapply(rmd_in, function(x) sprintf('%s/%s.md', dir_tmp, tools::file_path_sans_ext(basename(x))))
  cat("rendering Rmarkdown files: \n    ", paste(fn_in, collapse=', '), "\n  into:\n    ", md_out, "\n")
  md_out  = paste0(fn_out,'.md')
  if (file.exists(md_out)) unlink(md_out)
  for (f in fn_in){ # f = 'intro'
    f_Rmd = paste0(f,'.Rmd')
    f_md  = paste0(f,'.md')
    
    # Rmd to md, with References as md
    render(f_Rmd, output_format='md_document', quiet=F)
    
    # read md and tex versions of file 
    s_md  = readLines(f_md)
    s_tex = system(sprintf('pandoc %s --filter pandoc-citeproc --to latex', f_Rmd), intern=T)
    
    idx = which(s_md=='References')
    
    # chunk out before References to md, after to tex, wrapped in to singlespace tex command
    cat(
      paste(
        c(
          s_md[1:(which(s_md=='References') + 2)],
          '\\begin{singlespace}\n',
          s_tex[(which(s_tex=='\\subsection*{References}\\label{references}') + 2):length(s_tex)],
          '\n\\end{singlespace}\n'), 
        collapse='\n'), 
      file=md_out, append=T)
  }
  
  # md to pdf
  render(md_out, output_format='pdf_document', quiet=F)
  
  # md to pdf: unmodified default.tex
  system('pandoc thesis.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures \
    --output thesis.pdf --template /Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex \
    --highlight-style tango --latex-engine xelatex --variable geometry:margin=1in')

  # md to pdf: modified default.tex
  system('pandoc thesis.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures+raw_tex \
    --output thesis.pdf --template default.tex \
    --highlight-style tango --latex-engine xelatex --variable geometry:margin=1in; open thesis.pdf')
  
  # md to pdf: modified default.tex
  system('pandoc thesis.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures \
    --output thesis.pdf --template default.tex \
         --highlight-style tango --latex-engine xelatex --variable geometry:margin=1in; open thesis.pdf')
  
  # thesis-markdown-pandoc
  pdf_out = paste0(fn_out,'.pdf')
  #render(md_out, 'pdf_document', quiet=F)
  cmd = paste(
    'pandoc', md_out, '--to latex',
    '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures',
    '--output', pdf_out,
    '--template', tex_template,
    '--highlight-style tango --latex-engine xelatex --variable geometry:margin=1in')
  cat(cmd)
  system(cmd)

  # md to tex
  tex_out = paste0(fn_out,'.tex')
  cmd = paste(
    'pandoc', md_out, '--to latex',
    '--from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures',
    '--output', tex_out,
    '--template', tex_template,
    '--highlight-style tango --latex-engine xelatex --variable geometry:margin=1in')
  cat(cmd)
  system(cmd)
  
  # tex to pdf
get
  
  
  
  # /usr/local/bin/pandoc thesis.utf8.md --to latex --from markdown+autolink_bare_uris+ascii_identifiers+tex_math_single_backslash-implicit_figures --output thesis.pdf --template /Library/Frameworks/R.framework/Versions/3.1/Resources/library/rmarkdown/rmd/latex/default.tex --highlight-style tango --latex-engine pdflatex --variable geometry:margin=1in 
  cmd = paste0(
    'pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=12pt -V documentclass:book -V papersize:a4paper 
    -V classoption:openright --chapters --bibliography=papers.bib --csl="csl/nature.csl" title.md summary.md
    zusammenfassung.md acknowledgements.md toc.md "introduction/intro1.md" "introduction/intro2.md" chapter2_paper.md
    chapter3_extra_results.md chapter4_generaldiscussion.md appendix.md references.md -o "phdthesis.pdf"

  
  # make pandoc command string
  # tex_template='/Users/bbest/github/ucbthesis/inst/bbest/thesis_template.latex'
  # tex_template = '~/github/ucbthesis/inst/bbest/thesis_template.latex'
  tex_out = paste0(fn_out,'.tex')
  cmd = paste0(
    'pandoc ', shQuote(md_out),
    ' -t latex -o ', shQuote(tex_out),
    ' --template=', shQuote(tex_template))
  cat("pandoc'ing", md_out, 'into', tex_out, '\n\n', cmd, '\n\n...\n')
  system(cmd)
  
  # copy other files needed for latex to compile into tmp folder
  #tex_other = '~/github/ucbthesis/inst/bbest/ucbthesis.cls'  
  #sapply(tex_other, function(f) stopifnot(file.copy(f, sprintf('%s/%s', dir_tmp, basename(f)), overwrite=T)) )
  
    
    # run xelatex 
    cat("xelatex'ing", tex_out, "...\n")
    xelatexFail <- system(paste('xelatex', tex_out))
    
    if (biber) {
    cat("\n\nRunning biber on intermediate files...\n\n")
    system(str_c("biber ", filename))
    
    cat("\n\nRe-running xelatex to clean up cross-references...\n\n")
    xelatexFail <- system(xelatexCmd)
    }
    
    cat("\n\nMove temporary files created from xelatex:\n")
    moveLatexFiles()
    
    saveExtensions <- c("Rmd", "rmd", "bib", "latex", "cls", "sty", "pdf")
    
    if (xelatexFail) {
    stop("\n\nxelatex failed to compile a PDF from the rendered .tex file...\n")
    stop("Cleaning up temporary files...\n\n")
    cleanUp(saveExtensions)
    } 
    
    if (!saveTmpFiles) cleanUp(saveExtensions)
    
    return(str_c(filename, ".pdf"))
}
    
