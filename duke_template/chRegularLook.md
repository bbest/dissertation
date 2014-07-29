Basic Document Class Features {#chap:example}
=============================

This chapter is an example of how to format normal material in the
dissertation style. Most of this information is standard to LaTeX.

Intra-chapter divisions: Sections
---------------------------------

Section headlines are `` and in the standard font. Compare them to
subsections below.

### Subsections: Wow! Italics!

Yes, italics. You may now dance. Isn’t it funny that upright letters are
called “roman” while slanted letters are “italic”. That’s like Italian,
and Romans are Italians too. What gives?

#### Subsubsections: Smaller and smaller

Subsubsections are allowed, but are not numbered and don’t appear in the
table of contents. Likewise, you can use the next level of sectioning.

##### Paragraphs

These divisions are unnumbered and do not appear in the Table of
Contents.

###### Subparagraphs

This is the finest division possible. It’s also unnumbered and omitted
from the Table of Contents.

Let’s do some math
------------------

Let’s look at an equation:

$$\label{eq:diffeq}
\partial{f}{t} = f(t) \quad \text{subject to} \quad f(0) = c.$$

We’ve used the defined in the preamble of `dissertation.tex` to produce
the derivative. You can get a second derivative like
$\partial{^2 f}{t^2}$ by adding some sneaky superscripts. Fancy.

More advanced equation formatting is available in the AMS environments.
See the guide [amsmath user’s
guide](ftp://ftp.ams.org/pub/tex/doc/amsmath/amsldoc.pdf). Here are some
nice examples of cases people usually have trouble with.

An equation that’s too long for one line — use `multline`:

$$\begin{gathered}
    a +b+c+d+e+f+g+h+i+j+k+l+m+n+o\\ 
    = p+q+r+s+t+u+v+w+x+y+z.\end{gathered}$$

An equation with multiple parts and one number per line — use `align`:

$$\begin{aligned}
    a_1 &= b_1 + c_1\\
    a_2 &= b_2 + c_2.\end{aligned}$$

The same equation, set inside the `subequations` environment:

[hello]

$$\begin{aligned}
        \label{goodbye}
        a_1 &= b_1 + c_1\\
        a_2 &= b_2 + c_2.
    \end{aligned}$$

Notice that by clever placement of labels, I can reference the pair via
, the first , or the second . One number for multiple equations can be
accomplished using the `split` environment:

$$\begin{split}
        a &= b + c - d\\
         &\phantom{=} + e - f\\
         &= g + h\\
         &= i.
    \end{split}$$

People often struggle under the complicated and ugly ’eqnarray’
environment. Don’t do it! The AMS ones are easy. Other stumbling blocks
are cases:

$$a = \begin{cases}
        b & \text{for $ x > 0$}\\
        c & \text{otherwise,}
    \end{cases}$$

matrices:

$$A = \begin{pmatrix} a_{11} & a_{12} \\ a_{21} & a_{22} \end{pmatrix}
     = \begin{bmatrix} a_{11} & a_{12} \\ a_{21} & a_{22} \end{bmatrix},$$

and evaluation bars:

$$a = \frac{\partial u}{\partial x}\bigg\lvert_{x=0}.
    % Note: if you do this a lot, consider defining a command
    % 'eval' to format this the same every time.$$

See the source file for details.

When we reference an equation with something like texttt . If you click
on the above references in the PDF, your viewer should scroll up to the
above equation. It’s handy. Labels and references may be attached to all
sorts of objects. There is a texttt<span> </span> attached to this
chapter (it appears at the top of this file), and we may reference it by
(texttt<span> Chapter [chap:example] </span>), producing
“Chapter [chap:example]”. By default these ref’s are hyperlinked as
well. Later, we’ll see labeled and referenced figures and tables.
Particular pages may be labeled with standard texttt<span> </span>
commands in the text and referenced via texttt<span> </span>.

You might also like the links from texttt<span> </span> commands to the
corresponding bibliographic entry. Go look at this imaginary book by
Stephen Colbert @fancy. If you’re not a bibtex expert, look in
`mybib.bib` at the texttt<span> @ARTICLE </span> that generated this
entry. It shows an example of accents on author names and how to
preserve upper-case for letters in the title. Other entries show the use
of the texttt<span> and </span> keyword between author names. You may
order a particular author’s name as either “first last” or as “last,
first”. The actual format of the bibliography is controlled by the
texttt

command in `dissertation.tex`.

Table of Contents Behavior
--------------------------

Now is a good time to look back at the Table of Contents. Notice that
you may click on entries here to warp to the corresponding document
location. In Adobe Acrobat and many other viewers, you can open a
’bookmarks’ pane. This should be populated with named and numbered
sections and subsections identical to the Table of Contents.

Figures and footnotes
---------------------

Figures are set with very little space between the caption and the
bottom of the included graphic. This is because most graphics programs
pad the edges of images. If you find the spacing unsatisfactory, you may
always add a bit manually. The text of the caption is single-spaced, and
the word ’Figure’ is set in small caps. See Fig. [fig:example]. Notice
the use of the nonbreakable space “texttt<span>   </span>” between the
“Fig.” and the reference.

![Longer caption for actual body of dissertation. Figure captions should
be BELOW the figure.](dukeshield)

Figures (and tables) are examples of ’floats — objects that LaTeXdecides
where to place for you. You may give LaTeXsome hints. Change the
placement. Inside the [ ], you can put the following

-   Allow placement at the top of the page

-   Allow placement at the bottom of the page

-   Allow placement ’here’, in the middle of the page close to the text
    that the figure environment appears next to.

-   Allow placement on a seperate ’floats page’ that has no body text.

-   Tighten the screws on the placement algorithm. This doesn’t force
    things to happen as you say, but it makes it much more likely. Be
    careful: the bang option can cause figures to appear above the
    chapter title and in other bad locations.

Notice that each entry just changes what is *allowed*, but no preference
among the entries can be registered. The default is [tbp], which is a
very good default for a document like this, since floats in the middle
of a page trap too much whitespace for double-spaced text. There is also
a prohibition against having a page with more than 75% float. Instead,
long floats will get kicked over onto float pages. Float pages are often
a bad idea, as the creation of one will often cause a domino effect,
with all subsequent figures appearing on float pages themselves, and all
these float pages appearing together at the end of the chapter. (This is
more like sinking than floating.) Avoid this by physically moving where
the figure environment appears in your source file to an earlier
location. Don’t be afraid to put the environment before the first spot
you reference it! Many float problems can be solved by a combination of
relocating the figure environment and a little fiddling with the [ ]
options.

Also notice the order of the graphic, caption, and label. If you deviate
from this, strange things can happen. The caption of this figure shows
the use of short captions (inside []). These caption appear in the List
of Tables, while the <span> </span> captions appear in the body. If you
omit the [ ] short caption, the long caption will be used in its place.

Another technical note: since this style sheet is designed for
processing by pdflatex, texttt<span> </span> looks for `PDF`s, `PNG`s,
and `JPG`s instead of the usual `PS`, `EPS`, and `TIFF` formats. You can
convert existing graphics with a vareity of tools. `PDF` graphics are
preferred, as they scale nicely. The open-source software Inkscape runs
on Mac OSX, Windows, Linux, and some UNIX variants. Versions 0.46 and
beyond have great support for creating and editing `PDF`s. It can even
be used to convert other docs.

### List of Figures

If you’ve put even one measly figure in your document, grad school rules
say you need a List of Figures. It’s automatically generated for you if
you do a texttt<span> </span> in the master file (heck, it’s there right
now). Go look at the list of figures now. You should be able to click on
the figure number to warp to the figure. You’ll also see the result of
the ’short caption’ used above.

Table example
-------------

Just to make sure tables are formatted correctly, here’s an example of a
table float, see Table [tab:example].

[tab:example]

   Numbers   Letters      Symbols
  --------- --------- ----------------
      1         a        $\dagger$
      2         b      $\ddot \smile$
      3         c         $\times$
      4         d         $\sharp$

  : Long table caption appears on in the body text. See the short
  caption in the List of Tables. Table captions need to be ABOVE the
  table.

You should note that [b] formatting can cause floats to appear under the
footnotes. Try changing it here and see the ugliness. Tables are
identical to figures, except that the word ’Table’ appears in the
caption and its entry is in the List of Tables instead of the List of
Figures.

### Footnotes

Footnotes are allowed.[^1] They are numbered with arabic numerals inside
each chapter and appear at the bottom of the page.[^2] The little
footnote numbers are also hyperlinks. Try clicking them. You should
place the footnote command immediately following the period of the
sentence it is attached to. Any spaces or newlines will result in
strange spacing between the number and the sentence.

Corner cases in formatting, such as very very very long section titles. Man, this goes on forever.
--------------------------------------------------------------------------------------------------

Common corner-cases involve very long titles (like above). In these
cases, the long titles are set single-spaced both here and in the Table
of Contents.

### Figure and Table caption cases are neat, and this is an absurdly long subsection heading {#sec:fig-tab}

Consider the shield logo again with an absurd caption, as in
Fig. [fig:shield]. Also examine the new table, Table [tab:long-caption].
Both of these have been forced onto a floats page so you can see what
that looks like.

![The Duke logo again, but now with a really long rambling caption. This
caption should be set single-spaced in the LoF and in the body text.
What do you think about having graphics in the main directory of a
project? I’d prefer them in a folder, then put ’foldername/picturename’
as the argument to includegraphics.](dukeshield)

[fig:shield]

[tab:long-caption]

   Numbers   Letters      Symbols
  --------- --------- ----------------
      1         a        $\dagger$
      2         b      $\ddot \smile$
      3         c         $\times$
      4         d         $\sharp$

  : The same silly table again, but with a really really really really
  really really really really really really really really really really
  really really really really really really really long caption.

[^1]: But, you should probably just work them into the text since it’s
    annoying to jump around when reading.

[^2]: …rather than the end of the chapter or the thesis. Those would
    properly be endnotes, I guess.

