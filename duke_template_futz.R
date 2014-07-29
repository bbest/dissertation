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

