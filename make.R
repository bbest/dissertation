# make.R - compile dissertation into: pdf, word, html, md
#
# TODO:
#  - pdf/tex:
#    - swap hardcoded vars using make_config.R
#    - enable 2nd argument for short entry in list of figures per latex \caption[short]{long}
#  - see rmarkdown::includes
#  - md:
#     - update fig_caption() to add caption for md
#     - link toc to headers

source('make_config.R')

# Rmd: base for other formats ----
cat_Rmd()

# md: github flavored ----
render_md()

# html: quick web view ----
render_html(move=T)

# word: track changes for committee feedback ----
render_word()

# pdf: final submission to graduate school ----
render_pdf(cleanup=T)
