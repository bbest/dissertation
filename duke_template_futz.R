setwd('~/github/phd_thesis/duke_template')
for (f_tex in list.files(pattern=glob2rx('*.tex'))){
  f = tools::file_path_sans_ext(f_tex)
  cat(f,'\n')
  system(sprintf('pandoc %s.tex -t markdown -o %s.md', f, f))
}

setwd('~/github/phd_thesis/duke_template')
for (f_tex in list.files(pattern=glob2rx('*.md'))){
  f = tools::file_path_sans_ext(f_tex)
  cat(f,'\n')
  system(sprintf('pandoc %s.md -t latex -o %s.tex', f, f))
}

for ( f in list.files(pattern='^.*\\.(aux|log)$') ) unlink(f)

# compile from md to tex to dissertation.text to pdf
setwd('~/github/phd_thesis')
for ( f in setdiff(list.files(pattern=glob2rx('dissertation.*')), c('dissertation.tex')) ) unlink(f)


duke_template/chRegularLook.tex:        \label{goodbye}
duke_template/chRegularLook.tex:        \label{goodbye_b}

system('
pdflatex dissertation.tex
pdflatex dissertation.tex
bibtex dissertation
pdflatex dissertation.tex
pdflatex dissertation.tex


pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=12pt -V documentclass:book -V papersize:a4paper 
-V classoption:openright --chapters --bibliography=papers.bib --csl="csl/nature.csl" title.md summary.md
zusammenfassung.md acknowledgements.md toc.md "introduction/intro1.md" "introduction/intro2.md" chapter2_paper.md
chapter3_extra_results.md chapter4_generaldiscussion.md appendix.md references.md -o "phdthesis.pdf"
')

system('
pandoc --latex-engine=xelatex -H preamble.tex -V fontsize=12pt -V documentclass:book -V papersize:a4paper 
-V classoption:openright --chapters --bibliography=papers.bib --csl="csl/nature.csl" title.md summary.md
zusammenfassung.md acknowledgements.md toc.md "introduction/intro1.md" "introduction/intro2.md" chapter2_paper.md
chapter3_extra_results.md chapter4_generaldiscussion.md appendix.md references.md -o "phdthesis.pdf"
')
