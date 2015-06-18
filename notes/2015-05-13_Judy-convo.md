<!-- TOC depth:6 withLinks:1 updateOnSave:1 -->
	- [Abstract](#abstract)
	- [Introduction / Overview](#introduction-overview)
	- [Questions woven into Chapters](#questions-woven-into-chapters)
<!-- /TOC -->

## Abstract

So far, two separate themes:

1. predicting distribution of spp

2. spatial decision frameworks. just focus on this. spp distribution modeling is a component of this.


TODO:
- # pages, add line #s in docx

## Introduction / Overview

problem statement / demand:

  - biodiversity: dangers to endangered spp. inherent value from spiritual, possible biomedical purposes.

  - ecological: planet in danger. ecological stability.

  - political / financial: institutional. looks bad to hurt whales. Navy sued by NRDC to do due diligence by operating in areas that minimize. NOAA gets sued. Navy mid freq sonar, get bad press. Cruise ship with fin whale draped across bow, so min. Transportation industry in Channel Islands. Prologue. Epilogue: insurance and other creative instruments so industries can operate in env sustainable way.

  - slide 3/48 so Crowder (2006) communication device. need text to reflect difficulty in coordinating data.
  - slide 4/48 online system to see overlap b/n species and uses. so env compliance officers across agencies can extract info needed to understand impacts.

  - glossary:

    - Spatial Decision Support System. historically, no dial.

    - Spatial Decision Framework. dial can be throttled. tradeoff of encountering animals vs cost of operating around. key aspect. implies where. "tradeoff analysis".

    figure of input analytical process:
    - get data. obs data + env data = statistical prediction (SDM).
    - industry where they operate / ideal conditions. port to port for transport. fishing grounds. high slope areas for Naval submarine exercise.
    - construction of spatial decision framework.

    figure of s/w stack (technical):
    - front end web interface, back end statistical and datasets.

    figure of decision maker process:
    -

## Questions woven into Chapters

Before chapters and explanation, need overview of systematic data assimilation. Figures. What's sequence of putting these together? What pieces are in place already vs being filled in with this new work. Core of the work is not the chapters, but these are like appendices. Core is structuring of s/w to enable being hooked together. "Putting it All Together". Individual bits in flowchart.

Framework oriented around tradeoff.

A. Tradeoff varies according to industry, so you would use diff't techniques.

  1. Routing. Ship A to B. Transportation or Cruise ship industry.

  2. Siting. Offshore wind farms / oil platforms pile driving. Naval ship shock trials / low freq sonar. Time area closures w/ fisheries.

  -> Table. Perhaps weave in case studies.

  - Identified limitations of technique. More opportunity. Here's the historic solution, eg: 1. Boston Harbor ad hoc rerouting; 2. GeoMarine massive reports, static. Here's the new solution: live and forecastable (SWFSC). Highlight examples tackling here in dissertation vs other animals/techniques (TurtleWatch, billfish industry) which should be saved for later. Historically ad hoc, clunky, disorganized vs this is holistic, comprehensive framework.

B. Improvements of SDM to inform Framework.

- slide 5. Data from Many Platforms. historically silo'd vs bring together to have better prediction of where it.

- figures / tables: s/w, tools, industries, methodologies. like a teacher w/ course. inadequate historical practices, show final solution, so then how did we get there / pull it together?

Seven Questions on p 4, 2nd paragraph. Raise questions, but which ones are addressed? Don't leave them hanging and summarize which chapters answer which questions.

[-> revisit discussion with defense presentation]

On p 5, first inkling of target statement: web services readily available for decision making. Emphasize that these are all new techniques. Put in table form to summarize.


- themes. trending to poleward.

applied, not theoretical. what scientific questions? phenology of timing w/ migratory pathways, climatic trending.


- env covariates. "usual suspects" free, easily obtained: sst, chl, depth. eddy structures, mixed layer depth from complex newly available oceano models.

- uncertainty: observations (detection from surface or acoustic), natural variability / stochasticity in model. Historically, very low density with high uncertainty should still be cautious of encounter w/ endangered spp.

+ tradeoff as theme into Ch 4.

- themes into Q's framework. IAN UMD

hierarchical figure:

A. distributions

  1. over time

  2. wrt env

  3. even w/ gaps in data

  4. using disperate data sources

B. framework

  1. tradeoffs

  2. applying uncertainty

  3. diff't spatial problems: a) routing, b) siting


intro: relate chapters to original issues.

every step, give example w/ industry and data.

link to online repository.

tradeoff. max cost to industry vs max risk to conservation. throttle.
- routing. becomes more tortuous as decr conservation risk.
- siting. start w/ whole area in space & time.
- sources of info: can you drill down. highlight sperm whales in SDSS more detail w/ input survey effort & obs related to env correlation w/ model (GAMs...).
- tradeoff cost to industry. data sources? quantitative vs relative? reductionist axis is composed of. give examples: distance routed around, and quantify w/ employment, fuel, distance and trade lost. Setup dummy company with fleet size and profits over time. Today's fuel cost. Parameterize in form through web interface.

-> dive into tradeoff analysis.
