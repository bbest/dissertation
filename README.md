# dissertation

This repository is for drafting my PhD dissertation at Duke University.

Here's the draft dissertation rendered in various formats: for different purposes.

- [**html**](https://www.dropbox.com/s/oq0rqikqtwmwu6s/dissertation.html): quick web view (reference links via doi)
- [**docx**](https://www.dropbox.com/s/9we24lwcttq1x8v/dissertation.docx): track changes for committee feedback
- [**pdf**](https://www.dropbox.com/s/anncmip53zvmvlu/dissertation.pdf): final grad school submission

The outputs are binary (including HTML which has embedded images and javascript), so the files were placed into Dropbox for download (since Github more suitable for versioned text files). The [Rmarkdown](http://rmarkdown.rstudio.com) files here are collated into a single [dissertation.Rmd](./dissertation.Rmd), which is most easily viewed through Github as markdown [dissertation.md](./dissertation.md). The pdf takes special handling to conform to the Duke Graduate School. See [./make.R](make.R) and [./make_config.R](make_config.R) for details on how these individual Rmarkdown files are collated and rendered into the various forms.

Prefixes to Rmarkdown files (\*.Rmd) are simple letters for sorting front matter (a\_\*), core chapters (c\_\*) and back matter (x\_\*).

## Rendering

This dissertation is being knitted into a scientifically reproducible document using the following free software:

- [**RStudio**](http://www.rstudio.com/): excellent free, cross-platform R integrated development environment for writing code and text.

- [**Rmarkdown**](http://rmarkdown.rstudio.com): versatile "literate programming" R package for weaving chunks of R code with formatted text (markdown), built into RStudio.

- [**Pandoc**](johnmacfarlane.net/pandoc): the standalone conversion engine used by the rmarkdown package.

- [**Zotero**](https://www.zotero.org): excellent free bibliographic management software, like Endnote. With the [BetterBibtex](https://github.com/ZotPlus/zotero-better-bibtex) extension, I can simply drag and drop from a Zotero collection to get the inline citation and pandoc will later generate the full bibliography at the end of the document.  To get this to work:

  - Install [Zotero Better Bibtex](https://github.com/ZotPlus/zotero-better-bibtex)
  
  - In Zotero Preferences, set:
  
    1. Export: "Default Output Format" to `Pandoc citation`
    
    1. Better Bib(La)tex: "Citation key format" to `[auth:lower]_[veryshorttitle:lower]_[year]`
    
  - Process:
  
    1. Place all references used by dissertation into its own dedicated collection (eg "dissertation").
    
    1. Drag and drop references from this collection into the document editor (I like RStudio or [Sublime](http://www.sublimetext.com)). This will add a text citation, eg `@worm_impacts_2006`.
    
    1. Right-click on collection > Export Collection and choose `Better BibTex` and export to `dissertation.bib` file (which is assigned to `cite_bib` variable in make.R).

    1. You can get a quick formatted view of the document as you write with 'Knit HTML' button (or Ctrl+Shift+Y of [RStudio shortcuts](https://support.rstudio.com/hc/en-us/articles/200711853-Keyboard-Shortcuts)). Note that the *.html files are ignored by git in [.gitignore](./.gitignore).
    
    1. Run [./make.R](make.R) to generate collated document in all formats.
      
    1. Repeat as you write. For more, see [**pandoc citations**](http://johnmacfarlane.net/pandoc/demo/example19/Citations.html).
  
_Aside_. It is possible to your entire Zotero library using [AutoZotBib](http://www.rtwilson.com/academic/autozotbib), but my library is too large to practically use this.

## Technical Inspirations

Here are a few related resources from which I borrowed.

- [UC Berkeley](https://github.com/stevenpollack/ucbthesis): uses Rmarkdown templates
- [Duke theses](http://gradschool.duke.edu/academics/theses/): latex formatting specific to Duke
- [thesis-markdown-pandoc](https://github.com/chiakaivalya/thesis-markdown-pandoc): pandoc commands
- [knitr-examples / 070-caption-num.Rmd](https://github.com/yihui/knitr-examples/blob/master/070-caption-num.Rmd): trick with use of `local` and `global` variable assignment for caption counter
- [brew: Creating Repetitive Reports](http://learnr.wordpress.com/2009/09/09/brew-creating-repetitive-reports/): used to substitute variables `dissertation.brew.tex` -> `dissertation.tex`.
