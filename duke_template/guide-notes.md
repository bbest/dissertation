Duke Dissertation Class Documentation {#chap:guide}
=====================================

texttt<span> dukedissertation.cls </span> — a document class for
dissertations and theses conforming to the 2011 Duke University
guidelines. This class is by Michael Gratton and modified by Hugh
Crumley. It is based on the 2004 LaTeX2$\epsilon$ version of report.cls
and code in the older dukethesis.cls dating back to 1987.

The report.cls is Copyright 1993 1994 1995 1996 1997 1998 1999 2000 2001
2002 2003 2004 The LaTeX3 Project.

The original dukethesis.cls contained work by Mark Holliday, Charlie
Martin, Russ Tuck, Sean O’Connell, Michael Todd, Syam Gadde, and Rajiv
Wickremesinghe. Some of this work has been folded into the new document
class.

This file may be distributed and/or modified under the conditions of the
LaTeX Project Public License, either version 1.3 of this license or (at
your option) any later version. The latest version of this license is in
<http://www.latex-project.org/lppl.txt> and version 1.3 or later is part
of all distributions of LaTeX version 2003/12/01 or later.

This is the June 13,2011 version, 0.5,(updated by Hugh Crumley) by
Michael Gratton. [^1]

Features
--------

This class conforms to the 2011 style guidelines for dissertations,
including:

1.  Page numbers centered in the footer of each page

2.  Margins: 1in top, 1in right, 1.5in left, 1in below footer

3.  Title signature page, UMI abstract title signature page, and
    copyright page automatically generated at texttt

4.  ’Double’ spacing throughout body text (really about 10pt extra
    instead of 12pt extra.)

5.  Double spacing between and single spacing within the Table of
    Contents, List of Tables, List of Figures, Bibliography, and in
    chapter, section titles, and figure/table captions.

6.  Footnotes are numbered consecutively within a chapter and placed at
    the bottom of the page on which the reference number appears.

7.  Page ordering and numbering: roman numeral page numbers appear in
    the frontmatter (prior to the introduction or Chapter 1). The first
    numbered page is the Abstract (iv). Arabic numbering from ’1’ starts
    in the Introduction or Chapter 1 if there’s no Introduction.

8.  Optional material supported:

    -   Dedication

    -   Acknowledgements

    -   Introduction (different from ’Chapter 1: Introduction’)

    -   Appendices

This class also provides some handy features:

1.  Use the option ’economy’ to get a single-spaced document appropriate
    for giving to colleagues.

2.  Change your copyright from ’All rights reserved’ if you’re not
    actually reserving all your rights.

3.  New Look: boldface mostly removed in headers for a lighter feel. The
    word ’Chapter’ no longer appears on opener pages, only the number.

Limitations
-----------

In it’s current form, this class does not support committees larger than
six members, or titles longer than four lines. The figure-to-caption
space has been abbreviated, as most plotting programs provide ample
bottom margins. This default may not be acceptable in all cases.

Class options
-------------

The class supports the following options. Options appear in pairs with
the default option in each pair listed first. The exception is the first
listed option, which merely activates several other options for
convenience.

economy
:   Macro. Enables the options singlespace, nogradschool, and nobind.
    **Changed in version 0.3**

gradschool
:   Default. Produces signature lines and a UMI abstract title page.

nogragschool
:   Supresses the above.

PhD
:   Default. Format is suitable for a Ph.D dissertation.

MS
:   Modifies the format for Masters Theses. Changes the text on the
    title page, omits the UMI page, and generates warnings when
    forbidden document parts are used (i.e., Biography).

openany
:   Default. Allows a chapter to start on any page.

openright
:   Chapters only start on right-hand pages. Only makes sense for
    twosided documents.

oneside
:   Default. Wide margin (where the binding will be) always occurs on
    the left edge of a page.

twoside
:   Wide margin occurs on the left of odd pages and the right of even
    pages. This is for binding duplex printed documents.

final
:   Default. No extra marks, include all pictures.

draft
:   Prints black bars on pages where the contents overflow the margins.
    Suppresses the inclusion of graphics for speed.

doublespace
:   Default. Double-spaces body text and adds extra space between
    entries in the Table of Contents, List of Figures, List of Tables,
    List of Abbreviations, and Bibliography.

singlespace
:   Normal distances between baselines in all cases. Normal spacing in
    all list-type environments.

newstyle
:   Default. Lighter look for headings.

oldstyle
:   Headings in the classic LaTeXstyle. **New in version 0.3**

bind
:   Default. 1.5in margin for bidning appears on spine-side of a page.

nobind
:   Left and right margins are both 1.25in. **New in version 0.3**

The default options are chosen so that the document will pass the Ph.D
format specifications of the graduate school.

Here are some handy examples. Format required by graduate school:

    \documentclass{dukedissertation}

Easy-to-read format for printing, sending to collaborators, etc:

    \documentclass[economy]{dukedissertation}

Suitable for spiral bound copies and the like

    \documentclass[economy, twoside, bind]{dukedissertation}

[^1]: E-mail: <mgratton@math.duke.edu>

