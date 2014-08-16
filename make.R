# make.R - compile dissertation into: pdf, word, html, md

source('make_config.R')

# Rmd: base for other formats, except pdf
cat_Rmd()

# md: github flavored
render_md()

# html: quick web view
render_html(move=T)

# word: track changes for committee feedback
render_word()

# pdf: final submission to graduate school
render_pdf(cleanup=T, debug=F)
