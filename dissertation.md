-   Abstract
-   Introduction
-   Robust and Dynamic Distribution Models
-   Decision Mapping
    -   todo: Simulations
    -   Methods
        -   Species Distributions
-   Probabilistic Range Maps
-   Marine Conservation Routing: Transparently Deciding Tradeoffs between Risk to Species and Cost to Industry
    -   Abstract
    -   Introduction
    -   Methods
        -   Species Distributions
        -   Cumulative Risk Surface
        -   Vessel Routing
    -   Results
    -   Discussion
    -   Figures
    -   Notes
    -   References
-   Predicting Seasonal Migration
-   Conclusion
-   Appendix
-   References

**Spatio-Temporal Decision Frameworks for Minimizing Impact of Human Activities on Marine Megafauna**
Draft PhD dissertation by Benjamin D. Best
in Marine Science and Conservation, Duke University
Last modified: 2015-09-01

<!--- `source('make_config.R'); render_html('a_abstract.Rmd')` # run for quick render -->
Abstract
========

Human use of the oceans is increasingly in conflict with conservation of endangered species. Methods for managing the spatial and temporal placement of industries such as military, fishing, transportation and offshore energy, have historically been post-hoc; ie the time and place of human activity is already determined before assessment of environmental impacts. Instead, I describe a spatio-temporal decision framework that transparently optimizes the tradeoff between conservation risk and industry profit for placement of human activities in space and time. Spatially, placement is framed either as a siting or routing problem. For instance, determination of military exercises, fishing grounds and offshore pile driving get sited based on determining times and places that minimize conservation risk and industry costs. Whereas the transportation or cruise line industries need to route between destinations in a manner so as to minimize risk of encounter with endangered species as well as minimize cost of extra travel.

The reliability of this spatio-temporal decision framework depends on the input species distributions, which are inherently uncertain. Accounting for this uncertainty within the decision framework is therefore essential.

Furthermore, reduction and/or accurate description of this uncertainty is demonstrated through several methods. Where marine animal observation data are readily available from scientific surveys, data from multiple platforms can be combined so as to provide the most complete description of the species distribution. In data poor areas, expert range maps can be combined with environmental covariates to achieve a probabilistic distribution having a measure of uncertainty. Another common problem with marine environmental predictors are data gaps caused by cloud cover in remotely sensed imagery. These gaps are filled using neighboing data in space and time such that the associated uncertainty is passed along to the species distribution and decision framework. Finally, rather than the usual suspects of readily available environmental predictors, I propose a suite of comprehensive predictors that includes distances from dominant current, sea surface temperature fronts and eddy structures. Beyond simply remotely sensed variables, oceanographic model data are used such as mixed layer depth.

Introduction
============

In order to maintain marine biodiversity, we need to effectively describe the distributions of endangered marine life and mitigate potential impacts from human uses of the ocean. Successful conservation of marine megafauna is dependent upon identifying times and places of greatest use, within the context of a changing climate and increasing array of human activities.

![Figure 1.1: Example human uses of the ocean with potential for harm to endangered species (upper left, clockwise): pile driving and maintenance from offshore wind energy installations, ship shock trials and low frequency sonar use by military, fisheries gear entanglement, ship strike by transportation and cruise industries.](fig/marine_conflicts_redo.png)

Concurrent with a rise in conflicting human uses (see Figure 1.1) has been a rapid decline in overall marine biodiversity and ecosystem services (Butchart et al., 2010; B. S. Halpern et al., 2008b; Worm et al., 2006, 2009).

![Figure 1.2: Example from Crowder et al.(2006) of the many mixed uses of our oceans necessitating coordinated, holistic approaches to marine spatial management.Example human uses of the ocean with potential for harm to endangered species (upper left, clockwise): pile driving and maintenance from offshore wind energy installations, ship shock trials and low frequency sonar use by military, fisheries gear entanglement, ship strike by transportation and cruise industries.](fig/Crowder2006_fig1_redo.png)

In response, recent calls for holistic management practices, such as ecosystem-based management and marine spatial planning, are encouraging multi-species, multi-sector approaches (L. B. Crowder et al., 2006; L. Crowder & Norse, 2008; Dahl, Ehler, & Douvere, 2009; F. Douvere, 2008; M. M. Foley et al., 2010; B. S. Halpern, <span>McLeod</span>, Rosenberg, & Crowder, 2008a; Lubchenco & Sutley, 2010; US Commission on Ocean Policy, 2004) (see Figure 1.2). For these applications I’ll be focusing on marine spatial planning of cetaceans, but methods will be transferable to other marine megafauna.

In the US, marine mammals are legally protected through the Marine Mammal Protection Act and 22 are listed as threatened or endangered so are covered by The Endangered Species Act. Human activities that pose threats include: fishing bycatch or prey depletion (A. J. Read, 2008), ship strikes (Laist, Knowlton, Mead, Collet, & Podesta, 2001), anthropogenic noise (Weilgart, 2007), pollution of oil or bioaccumulating contaminants (Aguilar, Borrell, & Reijnders, 2002; O’Shea & Brownell Jr., 1994; Ross, 2006), and global climate change (Alter, Simmonds, & Brandon, 2010; Learmonth et al., 2006). Relocating potentially harmful human activities away from known cetacean distributions is generally the safest and simplest way to minimize risk (S. J. Dolman, Weir, & Jasny, 2009; Redfern et al., 2006).

The current state of marine spatial planning begs several broad questions of decision makers and decision support scientists. How do you optimize use of ocean resources to provide long-term ecosystem services in a sustainable manner while minimizing impacts on endangered species? How much risk are you willing to accept? What are the tradeoffs between conservation value and economic impact? How do you handle poor data availability within marine systems? How do you manage the dynamic nature of the environment with species distributions? How do you handle uncertainty while making spatial decisions? Which human uses require custom applications?

![Figure 1.3: Spatial decision support system depicting the input survey tracks (lines), observations (blue dots) and habitat prediction surface (blue=low vs red=high likelihood of encounter) for sperm whales in the US Atlantic east coast region.](fig/serdp-mapper_sperm-whale-summer-east_zoom_redo.png)

While much work has been done already to support description of species distributions for planning purposes (J. Elith & Leathwick, 2009; Margules & Sarkar, 2007; Pressey & Bottrill, 2009; Pressey, Cabeza, Watts, Cowling, & Wilson, 2007), there is room for improvement in answering the questions above for adopting a marine operational framework. Providing web services makes these data readily available for decision making (see Figure 1.3[1]).

![Figure 1.4: Observational data on species distributions can be very heterogenous, coming from a variety of platforms (clockwise from upper left): ship, plane, telemetry, expert opinion, and shore.](fig/mixed_platforms.png)

![Figure 1.5: Environmental predictors which are temporally dynamic and more closely aligned with the aggregation and visibility of potential prey-rich areas can significantly improve the species distribution model. Here are examples of extracting: eddies from the AVISO satellite sea-surface height data using the Okubo-Weiss equation(left); fronts from Pathfinder satellite sea-surface temperature data using the Cayula-Cornillon bimodal detection algorithm (right).](fig/predictors-dynamic.png)

![Figure 1.6: Components (and corresponding chapter numbers) of the dissertation are summarized by the decision framework posed as either a siting (1) or routing (2) problem that transparently weighs the tradeoff between species conservation and industry costs while accounting for uncertainty inherent in the species distribution model (SDM). Further chapters minimize or account for the SDM's uncertainty by either: combining boat and plane platforms of data in survey rich areas (3), combining expert opinion of species ranges and presence-only observations in data poor areas (4), and filling in gaps due to cloud cover with satellite derived environmental predictors (5).](fig/components.png)

| chapter                        | component            | improvement                                                                                 |
|--------------------------------|----------------------|---------------------------------------------------------------------------------------------|
| 1. siting                      | decision framework   | site in space & time with tradeoff                                                          |
| 2. routing                     | decision framework   | pose siting as routing problem                                                              |
| 3. mixed platform              | species distribution | incorporate survey data from multiple platforms                                             |
| 4. probabalistic range mapping | species distribution | where survey data is unavailable, mix expert opinion with presence-only observations        |
| 5. gap filling / migration     | species distribution | where clouds create gaps in satellite data, fill in with cascadable measures of uncertainty |

Over the next 5 chapters I propose methods for addressing these questions within two study areas, British Columbia and US Atlantic (see [[TODO: study area map]]).

1.  I start with pooling boat and plane datasets in order to incorporate more data into the species distribution models (SDMs). A variety of SDMs will be compared for their requirements, outputs and performance. Improvements in the SDMs will include novel environmental predictors, addressing scale and exploring lags in space and time.

2.  Decision Mapping provides a framework for incorporating uncertainty into decision making spatially.

3.  Seasonal Migrations explicitly includes time-varying habitats in SDMs.

4.  Probabilistic Range Maps combine range maps and occurrence through a Bayesian environmental model.

5.  In Conservation Routing layers of species data are combined into a single cost surface for routing ships using least cost paths. These tools should enable a more transparent, operational and robust set of methods for incorporating cetacean species distribution models into the marine spatial planning process.

<!--
## Notes

- PBR potential biological removal

- Titles to consider:
  - Data to Decisions: Applying Dynamic Species Distribution Models to Cetacean Conservation Management
  - Marine Spatial Planning for Megafauna in a Dynamic Ocean: Methods and Applications for the Future

- History of Cetacean Distribution Modeling
  - historic whaling charts by Admiral Matthew Maury [map of whales](http://maps.bpl.org/id/m8753) [data visualizations of whaling history]](http://sappingattention.blogspot.com/2012/10/data-narratives-and-structural.html)
  - whaling (graphic), extirpation. examples of extinct whales. locally extinct, eg gray whale from Atlantic, but then climate change doing interesting things with whale showing up in Med.
  - summarized by [@smith_spatial_2012]

- counting whales from satellite [@fretwell_whales_2014]

-->
<!--- `source('make_config.R'); render_html('c_sdm.Rmd') # run for quick render` -->
Robust and Dynamic Distribution Models
======================================

Species distribution modeling literature and available techniques are vast (J. Elith & Leathwick, 2009). Predictive (vs explanatory) techniques are broadly divisible as regression, such as generalized linear model (GLM) or generalized additive model (GAM), or as machine learning, such as multiple adaptive regression splines (MARS), boosted regression trees (BRT), or maximum entropy (Maxent). MARS can uniquely produce a multi-species response allowing for pooling of data, especially helpful for rare species (Hein<span>ä</span>nen & Numers, 2009; J. Leathwick, Elith, & Hastie, 2006; Nally, Fleishman, Thomson, & Dobkin, 2008). Multiple models can be combined as an ensemble (Araujo & New, 2007). Output can predict likelihood of presence (i.e. habitat) or density (i.e. abundance per unit area). Some habitat modeling techniques (e.g. Maxent) require only presence data, whereas others require absence or pseudo-absence records. Density models require more information on group sizes and parameters for detectability. Density predictions enable the calculation of potential take, often required for environmental impact assessment. Habitat requires less data and may be more appropriate for determining go/no-go areas. Habitat has been correlated to density for cetaceans in Scotland waters, but inconsistently (Hall et al., 2010). Issues such as autocorrelation (Dormann et al., 2007) and sampling bias (Phillips et al., 2009) need to be addressed with each set of data.

Taking advantage of recently completed cetacean habitat models for US Atlantic waters (Best et al., 2012), I will compare performance of modeling techniques ranging from presence-only to presence-absence to density . These will include both correlative techniques (GLM, GAM) and machine learning (random forest, BRT, Maxent). Does more information as required by presence-absence and especially density add value? In order to use both ship and plane datasets the cell values for fitting the GAMs were offset residence time of survey effort per cell. No known methods exist to simultaneously incorporate density surface models from different platforms, so data will need to be subset for comparability. Measures such as AUC will assess model performance.

Megafauna often move between several habitats depending on life stage while exhibiting complex behaviors. They live in a dynamic world of shifting currents or winds, temperature and prey. This compounds typical data limitations, often resulting in species distributions having poor levels of variance explained. Inclusion of dynamic variables could improve predictability. The original models only included depth, distance to shore, distance to continental shelf break, and sea-surface temperature (SST). The next generation of models will include novel covariates from satellite-derived features which tend to aggregate prey: improved sea-surface temperature fronts, geostrophic eddies and the Lagrangian technique finite-size Lyapunov exponent (Tew Kai et al., 2009). Mixed layer depth (MLD) has proven to be a strong predictor for the habitat of some cetaceans (Redfern et al., 2006), but has historically been limited to in situ measurements by boat limiting its prediction across the seascape. Now 4D oceanographic models such as the Hybrid Coordinate Ocean Model (HyCOM) make MLD available over the entire oceanographically modeled extent. Oceanographic models also do not suffer from cloud cover and can resolve more finely in time and space, although error still exists. Most importantly they can be used to forecast conditions. California NOAA colleagues Elizabeth Becker and Karin Forney have been extending their models (Becker et al., 2010) with the Regional Oceanographic Modeling System (ROMS) to forecast in the Pacific. HYCOM currently predicts out 5 days and ROMS up to 3 months. Most of these data and tools relevant to US Atlantic are easily accessed within an ArcGIS workflow through the Marine Geospatial Ecology Tools[2] (Roberts, Best, Dunn, Treml, & Halpin, 2010).

Adaptive management practices are emerging for responding to real-time oceanographic features and endangered species observations. Hawaii-based longline vessels in the Pacific are advised by a regularly update satellite contour map from the TurtleWatch service[3] to fish in waters warmer than 65.5° C to avoid bycatch of loggerhead sea turtles (Howell, Kobayashi, Parker, Balazs, & Polovina, 2008). A similar temperature contour was used for separation of commercially fished tuna species in southwestern Australia (A. J. Hobday & Hartmann, 2006). All vessels larger than 65 ft around Boston Harbor must travel 10 knots or less in critical habitat areas, and those heavier than 300 gross tons must report entrance into key areas and respond in real-time to current observations delivered through the right whale sighting advisory system[4] (L. I. Ward-Geiger, Silber, Baumstark, & Pulfer, 2005). The notion of pelagic reserves (K. D. Hyrenbach, Forney, & Dayton, 2000) is still young and has been more recently suggested beyond countries' exclusive economic zones (Ardron, Gjerde, Pullen, & Tilot, 2008). The UN Convention on Biological Diversity is reviewing criteria for Ecological and Biological Significant Areas for applying these measures, organized in coordination with the Halpin lab through the Global Ocean Biodiversity Initiative[5]. In short a receptive audience awaits for determining pelagic habitats with the latest predictive tools relevant to policy in process (D. C. Dunn, Boustany, & Halpin, 2010).

Dynamic management can include time-area closures, response to environmental cues, and response to real-time observations. Whenever considering these measures, the question to be asked is how much added value does dynamic management provide in reducing risk versus cost for additional management complexity?

Scaling issues are pervasive in ecology (Wiens, 1989) and at least as relevant here. Grain of the satellite imagery or oceanographic model is the limiting factor for differentiating local behavior and response. For instance the geostrophic currents is at about a 9km resolution. Many smaller-scale oceanographic features exist relevant to species. From the minimal resolution raster layers could be scaled to larger grain sizes to evaluate the sensitivity and performance of the models at different scales. This can similarly be done in time. A tradeoff generally exists with finer temporal scales such as daily or weekly, suffering from more missing data due to cloud cover. Larger scales, such as annual or climatic, average out of existence significant ephemeral features like SST fronts or geostrophic eddies.

Distribution of a species can lag in time and space from the characterization of the environment, whether from remotely sensed data or oceanographic models. The degree to which one is coupled to the other may inform key ecological process, such as trophic linkages. For instance, zooplanktivorous baleen whales, like the right whale feeding on Calanus, are hypothesized to be respond more quickly and predictably to the environment than pisciverous whales since more time is allowed for drift. One study in South Africa boldly measured temperature, chlorophyll, zooplankton, fish, bigger fish and birds, and found a spatial mismatch in trophic linkages (Gremillet et al., 2008). Simple testing of this drift in time between species and environment could simply be accomplished by including lagged terms in the model and allowing model selection to determine the best lag. Spatial lag would test neighbors in space, hence testing 4 rook or 8 cardinal neighbors per cell.

<!--- `source('make_config.R'); render_html('c_siting.Rmd') # run for quick render` -->
Decision Mapping
================

Often in ecology our predictive models yield very uncertain estimates. Incorporating this uncertainty into the decision-making process is a challenge. Typically this error is never used in the planning process, just the mean prediction surface or a thresholded binary map based on cross-validation. Areas exhibiting a low mean prediction but high uncertainty could still be too risky for some human activities. Conversely, habitat predicted with high confidence is presumably riskier than those with less.

An elegant solution for incorporating risk into decision making is to use a loss function (Ellison, 1996; Shrader-Frechette & <span>McCoy</span>, 1993; B. L. Taylor, Wade, Stehn, & Cochrane, 1996; P. R. Wade, 2000). For different decision outcomes, loss functions multiply a loss factor over the integrated probability for the parameter of interest. The recommended decision is then the one that minimizes the loss. For instance, in order to decide whether to conduct an activity in an area which may be harmful to a species that has some probability of being present, two loss functions could be constructed reflecting a decision to: 1) “go” or 2) “no-go.” Each function is multiplied by the probabilities of each cell resulting in two surfaces representing the loss for each decision. The loss function for the “go” decision would reflect the loss associated with negatively impacting the species if present and conducting the activity, whereas the “no-go” loss function represents the opportunity cost for not conducting the activity if the species is not likely to be present. In its simplest form, these decisions could be represented as a linear or step function. Applying this function over the entire study area results in a loss surface for each decision rule set. By determining the decision yielding the minimal loss per pixel, a decision map is constructed which shows the best decision spatially which minimizes loss. This represents the first known instance of risk loss function applied spatially to conservation science.

todo: Simulations
-----------------

``` r
install.packages(c('mrds','Distance','dsm','DSsim','mads','DSpat'))
```

Methods
-------

### Species Distributions

See (Best, Fox, Williams, Halpin, & <span>PAQUET</span>, 2015).

For harbour seals and stellar sea lions, the in and out of water densities were added to produce the single species density estimates. The standard errors were also added using the delta method (Seber Ref).

<!--- `source('make_config.R'); render_html('c_range.Rmd') # run for quick render` -->
Probabilistic Range Maps
========================

Global observations of marine animals are often constrained to nearshore environments. To overcome the paucity of observations, expert-derived opinion, often in the form of drawn range maps, is enlisted for global species assessments (Schipper et al., 2008). These are binary (habitat or not habitat) without any measure of uncertainty. So little data was available for this analysis that of the 120 marine species the range of those threatened to extinction varied as widely as 23 to 61%. Ready et al. (2010) extracted simple environmental envelopes (Kaschner, Watson, Trites, & Pauly, 2006) from the literature and areas of exclusion based on range maps to produce a global distributions of cetacean and other marine taxa . We will apply a hierarchical state-space Bayes framework (Clark & Gelfand, 2006; Schick et al., 2008) for mixing IUCN range maps (Schipper et al., 2008) with observational data and associated environmental data.

In areas rich in observational data, the quantitative data should overwhelm the qualitative opinion in terms of matching to environmental signal. As more data becomes available it is easily updateable.

Marine Conservation Routing: Transparently Deciding Tradeoffs between Risk to Species and Cost to Industry
==========================================================================================================

Abstract
--------

Human activities such as shipping and cruising can harm endangered marine mammals through ship strike, acoustic noise and pollution. In the case of right whales in the Gulf of Maine, shipping lanes have been routed around observational hotspots of right whales. Voluntary avoidance areas have been designated elsewhere. Rerouting to date has been handled in an ad-hoc individual basis. Instead, I propose a tradeoff analysis that weights cost to industry versus risk to species. The cost to industry can be tailored to industry profiles based on extra commute distance deviating from the least cost Euclidean path. The risk to species is aggregated from species distribution models based on weights of extinction risk and sensitivities to the industry chosen profile. The final species risk surface acts as the resistance surface by which least-cost routing is implemented. Transformations are applied to this surface for providing a series of routes offering a range of tradeoffs between conservation and industry. Tradeoffs from past decisions can be mapped into this framework for providing consistent decision making elsewhere in a systematic manner. Where species distributions are available seasonally or forecast given present or future environmental conditions, routes can be dynamically generated. Realtime feedback through an interactive online application facilitates transparent decision making by industry professionals and governmental policy makers.

Introduction
------------

Vessel traffic poses the threat of ship strike, acoustic noise and spill of oil or other cargo pollutants. Reducing risk to endangered wildlife while maintaining human activities and maritime operations requires objective assessment of species habitats and human uses in both space and time. In order to better assess management options for separating endangered species and potentially harmful interactions we need to develop a synthetic, composite valuation of our marine species and then apply explicit optimization methods. Here we build a cost surface based on species distributions that are then applied to optimize the routing of vessels in the region to potentially reduce the risk of adverse interactions.

In Boston harbor where the critically endangered right whales are of concern, shipping lanes were redrawn around a simple right whale density of historical opportunistic sightings (L. I. Ward-Geiger et al., 2005). This ad-hoc method doesn’t account for variability in species distribution, observational bias or other analytical rigor for easily applying elsewhere. Methods for incorporating multiple species in such a routing analysis are untested. Studies have worked on risk of ship strike vs. cost of vessel rerouting based on a pre-defined track (Fonnesbeck, Garrison, Ward-Geiger, & Baumstark, 2008; Schick et al., 2009; Angelia <span>SM</span> Vanderlaan & Taggart, 2007; A. S.M Vanderlaan & Taggart, 2009; A. S.M Vanderlaan, Taggart, Serdynska, Kenney, & Brown, 2008; A. Vanderlaan et al., 2009; L. I. Ward-Geiger et al., 2005), but have yet to be suggested in a prescriptive manner.

To avoid encounters with marine mammals, hotspots of expected encounters are to be avoided, and routed around. Least-cost path algorithms, such as Djikstra’s, are commonly used in online driving directions and many other route-optimization applications. These graph-theoretic algorithms have also been playing an increasing role in routing corridors of habitat and testing connectivity of habitat patches (Chetkiewicz, Clair, & Boyce, 2006) for both terrestrial (D. L. Urban, Minor, Treml, & Schick, 2009; D. Urban & Keitt, 2001) and marine applications (E. A. Treml, Halpin, Urban, & Pratson, 2008). The algorithm minimizes the total cost of travel between two points traversing over a resistance surface. For the sake of this conservation routing problem, the resistance surface represents the risk of species encounter.

To create this synthetic cost surface, individual species density surfaces were first relativized, and then weighted by conservation score before adding them up into a single cost surface layer. The cost surface was then used to determine alternate navigation routes for ships, which have the potential for striking animals or fouling habitat from potential spills. These methods employ least-cost path algorithms as a means to develop vessel paths that follow the most economical path through the environment while avoiding areas of high environmental risk.

In our case study area of British Columbia, an oil pipeline has been routed to Port Kittimat and oil tankers are being routed from the points of entry north and south of the Haida Gwaii islands (FIGURE XX).

While a wide variety of industries are increasingly active in the coastal waters of British Columbia, many environmental groups (PNCIMA, BCMCA, LOS) are seeking conservation-minded solutions for safely locating activities. The current ecological data layers in widest use are based on an expert feedback approach delineating important areas. Several large oil and gas projects that are currently underway are likely to increase heavy shipping into Kitimat (EnviroEmerg Consulting Services, 2008), making this a useful example of the approach. One map ([Figure 1.3](#bc_routes_proposed)) depicts the areas in the latest draft PNCIMA Atlas, originally provided by (Clarke & Jamieson, 2006). The maps in these atlases identify areas of importance as polygons. These polygon areas are then overlaid and summed to create an index of potential importance and environmental sensitivity. In the absence of observational data, this qualitative approach is the best available science. Given the availability of Raincoast surveys (Best et al., 2015), the density surfaces of each species can be combined to provide a more quantitative layer for planning purposes.

Existing routes may have preference for other factors than efficiency, such as scenic beauty or protection against inclement weather. Given that existing routes are generally preferred, a cost can be associated with movement away from these preferred routes. Here we take the case of cruise routes reported online. Euclidean distance from existing cruise route was relativized by the maximum within the study area and multiplied by the maximum cost surface value. The two surfaces can be added to obtain the final cost surface for routing, providing an example of equal weighting to conservation and routing goals.

The relative weights of these layers could be gleaned from the past precedent of re-routing shipping lanes in Boston Harbor based on overlap with a density of right whale observations. A similar spatial decision-making process could then be applied globally as thought experiment using the global shipping layer from (B. S. Halpern et al., 2008b). The ability to operationally provide a framework for minimizing impacts on marine animals is especially appealing. For example, ship traffic lanes have been re-routed in Boston Harbor to reduce likelihood of striking right whales (Fonnesbeck et al., 2008; Russell, Knowlton, & Zoodsma, 2001; L. I. Ward-Geiger et al., 2005). Global data layers on human impacts in marine systems are being actively developed, including vessel traffic density (B. S. Halpern et al., 2008b). Here we provide a simple framework for proposing alternative shipping routes to minimize impacts on marine animals. In this framework competing priorities, such as cost of additional travel distance and time versus risk of striking a marine mammal can be more objectively assessed.

Methods
-------

### Species Distributions

See (Best et al., 2015).

For harbour seals and stellar sea lions, the in and out of water densities were added to produce the single species density estimates. The standard errors were also added using the delta method (Seber Ref).

### Cumulative Risk Surface

Density surface model outputs were assembled into a marine mammal composite risk map, or cost surface. Each species density surface was normalized in order to highlight areas of high density relative to its average. The unitless standard score, or z-value (\(z\)), per species (\(s\)) and pixel (\(i\)) is calculated as the pixel’s marine mammal density estimate (\(x_{i,s}\)) subtracted from the mean of all density estimates for the species (\(\mu_s\)), divided by the standard deviation of those density estimates (\(\sigma\)). The final conservation score per pixel (\(Z_i\)) represents the sum of all species scores (\(z_{i,s}\)) weighted by the extinction risk (\(w_s\)).

\[
z_{i,s} = \frac{ x_{i,s} - \mu_s }{ \sigma_s }
\] \[
Z_i = \frac{ \sum_{s=1}^{n} z_{i,s} w_s }{ n }
\]

**ALTERNATIVE**. The problem with

Rank density into:

1.  0, or negligibly present.
2.  1 = low
3.  2 = below average
4.  3 = average (\(\mu\) +/- )
5.  4 = above average ()
6.  5 = high (2x \(\mu\))
7.  6 = very high

<!---
TODO:
Is $\sigma$ per pixel or for entire DSM?
How does uncertainty play into this decision making?
--->
An inverse weighting scheme based on species extinction risk (Figure 1.4) was applied to favor representation of more endangered species (Wood & Dragicevic, 2007). These rankings were obtained from the Provincial listing status at British Columbia’s Endangered Species and Ecosystems website (<http://www.env.gov.bc.ca/atrisk>). Elephant seal is listed as SNA, species “not applicable”, presumably because of its semi-migratory status in BC waters. Given that its status is S4 in California and Alaska to the south and north of BC, this status was used to conform with the scheme. The values on the y-axis indicate the relativised weight used in the analysis.

From supplemental in (Maxwell et al., 2013)...

> ***Methods*** The vulnerability weight of each stressor was determined through ranking of six measures: (1) stressor frequency, (2) if the impact was direct or indirect, (3) resistance of the species to the stressor, (4) recovery time of an individual from the impact, (5) relative impact on reproduction and (6) relative impact on the population (detailed description in Supplementary Table S4). All vulnerability measures were normalized (scaled between 0 and 1) and summed to obtain a weight for each stressor for each species (Supplementary Table S2; Supplementary Note 1 for summary of each impact).

> **Supplementary Table S4**. Summary of vulnerability measures used to determine the weightings for impact scores across species.

> 1.  **Frequency** (0 - 4): What is the frequency of the impact?
> 2.  **Direct/Indirect impact** (0 - 3): What’s the mechanism by which it is affecting the *individual*?
> 3.  **Resistance (Likelihood of mortality)** (0 - 3): How likely is that impact to affect the individual?
> 4.  **Recovery time of individual (years)** (0 - 4): How long does it take the individual to recover from exposure to the impact?
> 5.  **Reproductive Impacts** (0 - 3): What is the level of impact on reproduction of an individual?
> 6.  **Population Effects** (0 - 3): How are the impact distributed across the population?

[TODO: get original summaries of these for described spp. Max possible: 20]

> ***Ocean-Based Pollution*** Ocean-based pollution in the form of discharge from ships or large-scale oil spills can impact all predator species but has perhaps the greatest impacts on seabirds111-113. Oiled birds can lose flight capability in addition to wasting fat and muscle tissues, abnormal conditions in the lungs, kidneys and other organs from even small amounts of exposure to oil slicks97,114,115.

> ***Shipping*** Impacts on marine mammals and sea turtles from shipping occur in the form of ship strikes128,129. Though rare for most species, this impact is of particular concern to even the largest whales that are killed as a result of ship strikes130-132. Studies in the North Atlantic have shown that over 40% of right whale mortalities are attributable to ship strikes133. Seabirds are attracted to ship lights at night and are killed or injured when they strike parts of the ship134, though this has not been well studied in the California Current region.

from (Wiley, Thompson, Pace <span>III</span>, & Levenson, 2011):

$ v\_i$

-   speed by industry (v\_i)

Table 1 The probability of lethality resulting from a collision between a whale and ship in the Stellwagen Bank National Marine Sanctuary and percent risk reductions achieved by limiting ship speed to thresholds of 16, 14, 12, or 10 knots (29.6, 25.9, 22.2, and 18.5 km/h, respectively).

Table 2 Probability of lethality to a whale struck by a ship in the sanctuary (SPLETH) Percent reduction (observed-status quo SPLETH)/ status quo SPLETHh aracteristics of vessel traffic (502 unique vessels) in the Stellwagen Bank National Marine Sanctuary for the year 2006. Data derived from the US Coast Guard’s Automatic Identification System.

speed

### Vessel Routing

The routing will be performed with Python scripts using ESRI’s ArcGIS ArcInfo version 9.3 with the Spatial Analyst toolbox. The CostPath function was used with input cost distance and back-directional raster grids generated from the CostDistance function. The 5km original density surface grids will be resampled to a 1km resolution for use as the resistance cost surface to provide finer spatial resolution and routing within the inlets. An alternative raster grid in which all cells would be assigned a cost value of 1 serves as the Euclidean linear distance optimal spatial route providing a comparison of direct routing.

The cost surface from the composite risk map provides the biological hotspot surface around which to route. The routing was performed with Python scripts using ESRI’s ArcGIS ArcInfo version 9.3 with the Spatial Analyst toolbox. The CostPath function was used with input cost distance and back-directional raster grids generated from the CostDistance function. The 5km original density surface grids were resampled to a 1km resolution for use as the resistance cost surface to provide finer spatial resolution and routing within the inlets. An alternative raster grid in which all cells were assigned a cost value of 1 served as the Euclidean linear distance optimal spatial route providing a comparison of direct routing.

The proposed routes from Figure 10 were digitized and endpoints for north and south approaches used with the exercise to test the framework moving in and out of Kitimat. Routes between all navigation points, originally including other ports (Prince Rupert and Port Hardy), were also calculated. Existing routes may have preference for other factors than efficiency, such as scenic beauty or protection against inclement weather. Given that existing routes are generally preferred, a cost can be associated with movement away from these preferred routes. Here we take the case of cruise routes reported online . Euclidean distance from existing cruise route was relativized by the maximum within the study area and multiplied by the maximum cost surface value. The two surfaces were added to obtain the final cost surface for routing, providing an example of equal weighting to conservation and routing goals.

Results
-------

The composite risk map for all marine mammals (Figure 12) is very similarly distributed as just the large whales (Figure 13) composed of killer, humpback, fin and minke whale. Consistent with (Clarke & Jamieson, 2006), Hecate Strait was found to be relatively important, along with the Dixon entrance. The highest value hotspot is in Gwaii Hanas Reserve, already under some level of protection. The high levels in stratum 3 Johnstone Strait (see zoom view) may be an anomaly of the environmental conditions there, since few sightings were made by comparison.

The routes do differ markedly (Figure 14). It is not clear whether Grenville Channel is deep and wide enough to support the kind of tanker traffic envisioned. Besides being closer to the northern approach, as evidenced by that inlet choice with the Euclidean path, Grenville Channel exhibits a lower level of potential marine mammal interaction as predicted by the composite marine mammal densities than through the Principe Channel as proposed. By routing through the Grenville Channel the potential interactions in the Hecate Strait could also be avoided. The proposed Southern approach exhibits relatively lower potential interactions with the least-cost route even dipping south around the Gwaii Haanas Reserve.

The existing ship routes pass through both the Principe and Grenville Channels. Models developed to conduct least-cost path analysis use raster grid cells. For modeling purposes these cells provide eight possible directions at each step (i.e. 4 side and 4 diagonal directions). These models create uneven turns when compared to the smoother Euclidean route or with the proposed routes (Figure 15). Although the Euclidean path should be the shortest, the existing industry route up the Principe Channel is the shortest (Table 1.2).

TODO: describe Table 1.1.

Discussion
----------

NOTES - GoalIdeally win win situation. - is to make routing around whale traffic in ocean as common as getting directions in Google Maps. Trend of AI. - Incentivize conscientious behavior by industries similar to good driver discounts withfor insurance. - Recent Supreme Court ruled against EPA carbon emissions regulation on the grounds that costs to industry were not considered. [Supreme Court rules EPA did not compute cost of regulation on industry - MRT.com: Business](http://www.mrt.com/business/article_bb80953c-20e5-11e5-9efa-cb4dd8fa86eb.html) Tables

| Species        | Oil Tanker | Shipping Tanker | Cruise Ship |
|----------------|------------|-----------------|-------------|
| fin whale      | 100        | 100             | 100         |
| humpback whale | 70         | 70              | 70          |
| killer whale   | 100        |                 |             |
| ...            |            |                 | ...         |

| Route                                                    | Euclidean | Industry | Least-Cost |
|----------------------------------------------------------|-----------|----------|------------|
| Kitimat to N. Approach (Conservation)                    | 391       | 410      | 425        |
| Kitimat to S. Approach (Conservation)                    | 304       | 319      | 336        |
| S. to N. Cruise Route (Conservation + Distance to Route) | 470       | 450      | 504        |

Figures
-------

![Figure 1.1: The process of conservation routing starts with gathering species densities (1a) created from species distribution models that correlate the environment with the observations. Industries (1b) can have differential impacts on species and costs associated with routing.](fig/routing_process.png)

![Figure 1.2: Interactive routing application with chart (left) of cost to industry versus risk to species in which the selected tradeoff (blue point) corresponds to the route (blue line) displayed within the interactive map (right) of the study area. Available online at <http://shiny.env.duke.edu/bbest/consmap/>.](fig/routing_app_tradeoff-map.png)

![Figure 1.3: On the left, polygons of important areas for gray, humpback, and sperm whales derived from expert opinion in the PNCIMA Atlas (Draft 2009). On the right, proposed tanker vessel route for servicing the forthcoming Kitimat oil and gas projects (EnviroEmerg Consulting Services 2008).](fig/bc_routes_proposed.png)

![Figure 1.4: Weighting by BC conservation status for fin whale (FW), Steller sea lion (SSL), harbour porpoise (HP), humpback whale (HW), killer whale (KW), Elephant seal (ES), minke whale (MW), Dall’s porpoise (DP), Pacific white-sided dolphin, and harbour seal (HS).](fig/bc_species_weights.png)

![Figure 1.5: Conservation-weighted composite map of all marine mammal z-scored densities.](fig/bc_composite_risk_map.png)

![Figure 1.6: Proposed, linear (Euclidean), and least-cost routes for oil tankers to Port Kitimat. The least-cost route uses the conservation weighted cost surface.](fig/bc_route_oil_tankers.png)

![Figure 1.7: Existing, Euclidean and least-cost routes for cruise ships along the BC coast. The least-cost route uses a cost surface which is the sum of the conservation risk surface and a surface of distance from existing routes scaled to the equivalent range. The least cost-path is chosen which thus avoids biological hotspots while being equally attracted to existing routes.](fig/bc_route_cruise_ships.png)

![Figure 1.8: Ships were rerouted in Boston Harbor around hotspots of right whale observations, but in ad-hoc fashion without quantitifying the tradeoff between cost to industry and conservation gain. Source: (L. I. Ward-Geiger et al., 2005).](fig/routing_boston_harbor.png)

![Figure 1.9: Given this spatial decision framework, routes to all ports globally could be similarly proposed. (B. S. Halpern et al., 2008b).](fig/routing-global-traffic_sized.png)

Notes
-----

TODO: - add layer: ports - add layer: MPAs `~/github/consmap/data/mpas_canada/CARTS_20141231_noQC/CARTS_20141231_noQC.shp`

-   add figure: tradeoff points + route map, color coded
    -   optimal least-cost on outside
    -   less optimal, linearized for IMO shipping lane standards
-   handle speed reductions in given areas (see Schick 2008; Vanderwaal), which accumulate lower risk
-   compliance: Vanderwaal, elsewhere
-   industry routing: weather, other considerations?
-   TIME:
-   show routes over time with same decision point
-   APP:
    -   do real time routing
-   feedback from Raincoast, Mersk, Shaun on actual application. How could this relate to insurance incentivizing program?
-   research issues with SB Channel in trying to get rerouting accomplished

References
----------

<!--- `source('make_config.R'); render_html('c_migration.Rmd') # run for quick render` -->
Predicting Seasonal Migration
=============================

The presence of seasonal migration in a species’ life history can obviously alter distribution greatly. As a species alternates between foraging, breeding, calving or migratory behaviors response to the environmental is likely to vary. Accounting for these spatial and behavioral disparities is commonly done by building separate seasonal models to represent the different of habitats (Redfern et al., 2006). Migrations however can last up to 4 months over 20,000 km distances in the case of the grey whale. Models describing them as present over the entire range during that period would be insufficient for planning purposes. The general timing and broad locales are often available in natural history and scientific literature. Surprisingly I could not find a single species distribution model for cetaceans that explicitly includes migration.

Most papers which discuss migration and species distribution modeling are modeling the long term shift in distribution, typically poleward, imposed by climate change (Guisan & Thuiller, 2005; L. M. Robinson et al., 2011), and not the seasonal migrations common to megafauna. Mechanistic species distribution models have been suggested (Kearney & Porter, 2009; L. M. Robinson et al., 2011) but are complicated with energy and mass balance equations using parameters often difficult attain. Complex Markov models have been used with bird data to model bird migrations and trajectories (Sheldon, Elmohamed, & Kozen, 2007).

A simpler method is possible and desirable for easily providing marine stakeholders and the general public (e.g. through OBIS-SEAMAP[6] or GROMS[7]) with a best guess view of what whales are where when. In its simplest form, separate models would be fit from observations separated out seasonally and spatially to distinguish the breeding, foraging and 2 migrating habitats. For the migratory habitat, time would be included as an interaction term for all environmental variables. Another variable could be introduced which measures distance along the axis of the median path, or straight line from the centroids of the breeding and foraging grounds. A significant fit for the interaction with this linear predictor would provide a clear description of where the whale is expected to be on its journey. Using the distance from this median line should give an idea of how widely dispersed the animals are along the way. If using a GAM then to model this interaction term, then it would be a bivariate smoother which could expand and contract along the axis. Compositing these models together could then provide a simple time-varying habitat model incorporating migratory movement.

I propose to do this with the North Atlantic right whale (*Eubalaena glacialis*) since data is easily obtained through OBIS-SEAMAP over the entire species range and existing datasets are available for habitat in the Gulf of Maine foraging grounds (Best et al., 2012; Department of the Navy (DON), 2007) and calving grounds off Florida (C. P. Good, 2008), as well as comparison with migratory model based on telemetry data (Schick et al., 2009).

Kenney et al. (2001) conceptualized a hierarchical sensory model for right whales to hone in on prey and navigate between summer foraging grounds in the Gulf of Maine and winter calving grounds off Florida, but fell short of postulating specific cues to initiate migration. Past years of observations and environmental data could be mined to explore a more specific environmental cue than date. This would enable predictions of the onset of migration. Other unmeasurable factors, such as satiation or hunger, are likely candidates, perhaps not inferable by environmental proxy.

<!--- `source('make_config.R'); render_html('x_conclusion.Rmd') # run for quick render` -->
Conclusion
==========

Integrated spatial decision support frameworks should maximize use of all available species data, utilize the best available environmental predictors, handle inherent uncertainty in model results, and transparently manage trade-offs between conservation and industry.

Military exercises require environmental impact assessment in relation to cetaceans (S. J. Dolman et al., 2009). More recently, facilities for offshore renewable energies, such as wind and wave, pose another potential impact on cetaceans (S. Dolman & Simmonds, 2010). All of these human activities, which continue to be on the rise, have been prioritized for systematic planning under the auspices of “ocean zoning” (L. B. Crowder et al., 2006; B. S. Halpern et al., 2008a) or “marine spatial planning” (F. Douvere, 2008) by the United States (Lubchenco & Sutley, 2010) and internationally (Ardron et al., 2008; Dahl et al., 2009). In order to best plan for such activities, there will be a continuing need to improve our models.

I have data and much of the analysis already completed for all of the above with several collaborators. The conservation climate is ripe for application of these analysis to real world scenarios. The US Navy is responding to lawsuits by the Environmental Defense Fund over whale strandings from use of low-frequency sonar. In British Columbia, the largest oil pipeline in Canada is terminating at port Kittimat where heavy oil tankers will traffic waters rich in wildlife not too far in memory or geography from the Valdez disaster. Renewable energies are on the rise, with offshore development most recently highlighted by a Google investment of $5 billion for an offshore wind backbone in the US East coast. These marine developments are now part of a presidential mandate to address marine spatial planning in the US outlined by the Ocean Task Force. The Global Ocean Biodiversity Initiative is now in process through United Nations Convention on Biological Diversity to address pelagic conservation strategies. These projects further fit into actively funded and proposed projects in the Halpin Marine Geospatial Ecology Lab:

1.  NASA funded SDSS for Integrating Ocean Observing Data to Enhance Protected Species,

2.  NASA proposed Forecasting of climate change and its effect on the abundance and distribution of cetaceans using downscaled output of IPCC class earth system models, and the

3.  Census funded Global Ocean Biodiversity Initiative.

Appendix
========

Some extra code, graphs, etc here.

References
==========

<!-- adding blank content for References to show up in toc -->

Aguilar, A., Borrell, A., & Reijnders, P. J. H. (2002). Geographical and temporal variation in levels of organochlorine contaminants in marine mammals. *Marine Environmental Research*, *53*(5), 425–452. doi:[doi:\\%0020DOI:\\%002010.1016/S0141-1136(01)00128-3](http://dx.doi.org/doi:\%0020DOI:\%002010.1016/S0141-1136(01)00128-3)

Alter, S. E., Simmonds, M. P., & Brandon, J. R. (2010). The tertiary threat: Human-mediated impacts of climate change on cetaceans. *Paper IWC/SC61/E8 Submitted to the Scientific Committee of the International Whaling Commission*.

Araujo, M. B., & New, M. (2007). Ensemble forecasting of species distributions. *Trends in Ecology & Evolution*, *22*(1), 42–47. doi:[10.1016/j.tree.2006.09.010](http://dx.doi.org/10.1016/j.tree.2006.09.010)

Ardron, J., Gjerde, K., Pullen, S., & Tilot, V. (2008). Marine spatial planning in the high seas. *Marine Policy*, *32*(5), 832–839. doi:[10.1016/j.marpol.2008.03.018](http://dx.doi.org/10.1016/j.marpol.2008.03.018)

Becker, E. A., Forney, K. A., Ferguson, M. C., Foley, D. G., Smith, R. C., Barlow, J., & Redfern, J. V. (2010). Comparing california current cetaceanhabitat models developed using in situ and remotely sensed sea surface temperature data. *Marine Ecology Progress Series*, *413*, 163–183. doi:[10.3354/meps08696](http://dx.doi.org/10.3354/meps08696)

Best, B. D., Fox, C. H., Williams, R., Halpin, P. N., & <span>PAQUET</span>, P. C. (2015). Updated marine mammal distribution and abundance estimates in coastal british columbia. *Journal of Cetacean Research and Management*.

Best, B. D., Halpin, P. N., Read, A. J., Fujioka, E., Good, C. P., <span>LaBrecque</span>, E. A., … <span>McLellan</span>, W. A. (2012). Online cetacean habitat modeling system for the US east coast and gulf of mexico. *Endangered Species Research*, *18*(1), 1–15. doi:[10.3354/esr00430](http://dx.doi.org/10.3354/esr00430)

Butchart, S. H. M., Walpole, M., Collen, B., Strien, A. van, Scharlemann, J. P. W., Almond, R. E. A., … Watson, R. (2010). Global biodiversity: Indicators of recent declines. *Science*, *328*(5982), 1164–1168. doi:[10.1126/science.1187512](http://dx.doi.org/10.1126/science.1187512)

Chetkiewicz, C. L. B., Clair, C. C. S., & Boyce, M. S. (2006). Corridors for conservation: Integrating pattern and process.

Clark, J. S., & Gelfand, A. E. (2006). A future for models and data in environmental science. *Trends in Ecology & Evolution*, *21*(7), 375–380. doi:[10.1016/j.tree.2006.03.016](http://dx.doi.org/10.1016/j.tree.2006.03.016)

Clarke, C. L., & Jamieson, G. S. (2006). Identification of ecologically and biologically significant areas in the pacific north coast integrated management area: Phase iIdentification of important areas. *Canadian Technical Report of Fisheries and Aquatic Sciences*, *2678*, 59. Retrieved from <http://smtp.pncima.org/media/documents/pdf/phase-2-id.pdf>

Crowder, L. B., Osherenko, G., Young, O. R., Airame, S., Norse, E. A., Baron, N., … Wilson, J. A. (2006). Resolving mismatches in u.s. ocean governance. *Science*, *313*(5787), 617–618. doi:[10.1126/science.1129706](http://dx.doi.org/10.1126/science.1129706)

Crowder, L., & Norse, E. (2008). Essential ecological insights for marine ecosystem-based management and marine spatial planning. *Marine Policy*, *32*(5), 772–778. doi:[10.1016/j.marpol.2008.03.012](http://dx.doi.org/10.1016/j.marpol.2008.03.012)

Dahl, R., Ehler, C., & Douvere, F. (2009). Marine spatial planning, a step-by-step approach toward ecosystem-based management. *IOC Manuals and Guides*, *53*.

Department of the Navy (DON). (2007). *Navy OPAREA density estimate (NODE) for the northeast OPAREAs.* (p. 217). Prepared for the Department of the Navy, U.S. Fleet Forces Command, Norfolk, Virginia. Contract \#N62470-02-D-9997, CTO 0030. Prepared by Geo-Marine, Inc., Hampton, Virginia.

Dolman, S. J., Weir, C. R., & Jasny, M. (2009). Comparative review of marine mammal guidance implemented during naval exercises. *Marine Pollution Bulletin*, *58*(4), 465–477. doi:[10.1016/j.marpolbul.2008.11.013](http://dx.doi.org/10.1016/j.marpolbul.2008.11.013)

Dolman, S., & Simmonds, M. (2010). Towards best environmental practice for cetacean conservation in developing scotland’s marine renewable energy. *Marine Policy*, *34*(5), 1021–1027. doi:[10.1016/j.marpol.2010.02.009](http://dx.doi.org/10.1016/j.marpol.2010.02.009)

Dormann, C. F., M. Mcpherson, J., B. Araujo, M., Bivand, R., Bolliger, J., Carl, G., … Wilson, R. (2007). Methods to account for spatial autocorrelation in the analysis of species distributional data: a review. *Ecography*, *30*(5), 609–628. doi:[10.1111/j.2007.0906-7590.05171.x](http://dx.doi.org/10.1111/j.2007.0906-7590.05171.x)

Douvere, F. (2008). The importance of marine spatial planning in advancing ecosystem-based sea use management. *Marine Policy*, *32*(5), 762–771. doi:[10.1016/j.marpol.2008.03.021](http://dx.doi.org/10.1016/j.marpol.2008.03.021)

Dunn, D. C., Boustany, A. M., & Halpin, P. N. (2010). Spatio-temporal management of fisheries to reduce by-catch and increase fishing selectivity. *Fish and Fisheries*.

Elith, J., & Leathwick, J. R. (2009). Species distribution models: Ecological explanation and prediction across space and time. *Annual Review of Ecology, Evolution, and Systematics*, *40*(1), 677–697. doi:[10.1146/annurev.ecolsys.110308.120159](http://dx.doi.org/10.1146/annurev.ecolsys.110308.120159)

Ellison, A. M. (1996). An introduction to bayesian inference for ecological research and environmental decision-making. *Ecological Applications*, 1036–1046. Retrieved from <http://www.jstor.org/stable/2269588>

EnviroEmerg Consulting Services. (2008). *Major marine vessel casualty risk and response preparedness in british columbia*. Cowichan Bay, BC Canada.

Foley, M. M., Halpern, B. S., Micheli, F., Armsby, M. H., Caldwell, M. R., Crain, C. M., … Steneck, R. S. (2010). Guiding ecological principles for marine spatial planning. *Marine Policy*, *34*(5), 955–966. doi:[10.1016/j.marpol.2010.02.001](http://dx.doi.org/10.1016/j.marpol.2010.02.001)

Fonnesbeck, C. J., Garrison, L. P., Ward-Geiger, L. I., & Baumstark, R. D. (2008). Bayesian hierarchichal model for evaluating the risk of vessel strikes on north atlantic right whales in the SE united states. *Endangered Species Research*.

Good, C. P. (2008). Spatial ecology of the north atlantic right whale (eubalaena glacialis).

Gremillet, D., Lewis, S., Drapeau, L., Der Lingen, C. D. van, Huggett, J. A., Coetzee, J. C., … Ryan, P. G. (2008). Spatial match-mismatch in the benguela upwelling zone: should we expect chlorophyll and sea-surface temperature to predict marine predator distributions? *Journal of Applied Ecology*, *45*(2), 610–621. doi:[doi:10.1111/j.1365-2664.2007.01447.x](http://dx.doi.org/doi:10.1111/j.1365-2664.2007.01447.x)

Guisan, A., & Thuiller, W. (2005). Predicting species distribution: offering more than simple habitat models. *Ecology Letters*, *8*(9), 993–1009. doi:[10.1111/j.1461-0248.2005.00792.x](http://dx.doi.org/10.1111/j.1461-0248.2005.00792.x)

Hall, K., <span>MacLeod</span>, C. D., Mandleberg, L., Schweder-Goad, C. M., Bannon, S. M., & Pierce, G. J. (2010). Do abundance-occupancy relationships exist in cetaceans? *Journal of the Marine Biological Association of the UK*, *First View*, 1–11. doi:[10.1017/S0025315410000263](http://dx.doi.org/10.1017/S0025315410000263)

Halpern, B. S., <span>McLeod</span>, K. L., Rosenberg, A. A., & Crowder, L. B. (2008a). Managing for cumulative impacts in ecosystem-based management through ocean zoning. *Ocean & Coastal Management*, *51*(3), 203–211. doi:[10.1016/j.ocecoaman.2007.08.002](http://dx.doi.org/10.1016/j.ocecoaman.2007.08.002)

Halpern, B. S., Walbridge, S., Selkoe, K. A., Kappel, C. V., Micheli, F., D’Agrosa, C., … Watson, R. (2008b). A global map of human impact on marine ecosystems. *Science*, *319*(5865), 948–952. doi:[10.1126/science.1149345](http://dx.doi.org/10.1126/science.1149345)

Hein<span>ä</span>nen, S., & Numers, M. von. (2009). Modelling species distribution in complex environments: an evaluation of predictive ability and reliability in five shorebird species. *Diversity and Distributions*, *15*(2), 266–279. doi:[10.1111/j.1472-4642.2008.00532.x](http://dx.doi.org/10.1111/j.1472-4642.2008.00532.x)

Hobday, A. J., & Hartmann, K. (2006). Near real-time spatial management based on habitat predictions for a longline bycatch species. *Fisheries Management and Ecology*, *13*(6), 365–380. doi:[10.1111/j.1365-2400.2006.00515.x](http://dx.doi.org/10.1111/j.1365-2400.2006.00515.x)

Howell, E. A., Kobayashi, D. R., Parker, D. M., Balazs, G. H., & Polovina, J. J. (2008). TurtleWatch: a tool to aid in the bycatch reduction of loggerhead turtles caretta caretta in the hawaii-based pelagic longline fishery. *Endangered Species Research*, *5*(2-3), 267–278.

Hyrenbach, K. D., Forney, K. A., & Dayton, P. K. (2000). Marine protected areas and ocean basin management. *Aquatic Conservation: Marine and Freshwater Ecosystems*, *10*(6), 437–458. doi:[10.1002/1099-0755(200011/12)10:6\<437::AID-AQC425\>3.0.CO;2-Q](http://dx.doi.org/10.1002/1099-0755(200011/12)10:6<437::AID-AQC425>3.0.CO;2-Q)

Kaschner, K., Watson, R., Trites, A. W., & Pauly, D. (2006). Mapping world-wide distributions of marine mammal species using a relative environmental suitability (RES) model. *Marine Ecology Progress Series*, *316*, 285–310. doi:[10.3354/meps316285](http://dx.doi.org/10.3354/meps316285)

Kearney, M., & Porter, W. (2009). Mechanistic niche modelling: combining physiological and spatial data to predict species’ ranges. *Ecology Letters*, *12*(4), 334–350. doi:[10.1111/j.1461-0248.2008.01277.x](http://dx.doi.org/10.1111/j.1461-0248.2008.01277.x)

Kenney, R. D., Mayo, C. A., & Winn, H. E. (2001). Migration and foraging strategies at varying spatial scales in western north atlantic right whales: a review of hypotheses. *Journal of Cetacean Research and Management*, *2*, 251–260.

Laist, D. W., Knowlton, A. R., Mead, J. G., Collet, A. S., & Podesta, M. (2001). COLLISIONS BETWEEN SHIPS AND WHALES. *Marine Mammal Science*, *17*(1), 35–75. doi:[10.1111/j.1748-7692.2001.tb00980.x](http://dx.doi.org/10.1111/j.1748-7692.2001.tb00980.x)

Learmonth, J., Macleod, C., Santos, M., Pierce, G. J., Crick, H. Q. P., & Robinson, R. A. (2006). POTENTIAL EFFECTS OF CLIMATE CHANGE ON MARINE MAMMALS. *Oceanography And Marine Biology: An Annual Review: Volume 44*, *44*(43), 1–464.

Leathwick, J., Elith, J., & Hastie, T. (2006). Comparative performance of generalized additive models and multivariate adaptive regression splines for statistical modelling of species distributions. *Ecological Modelling*, *199*(2), 188–196. doi:[10.1016/j.ecolmodel.2006.05.022](http://dx.doi.org/10.1016/j.ecolmodel.2006.05.022)

Lubchenco, J., & Sutley, N. (2010). Proposed u.s. policy for ocean, coast, and great lakes stewardship. *Science*, *328*(5985), 1485–1486. Retrieved from <http://www.sciencemag.org/content/328/5985/1485.short>

Margules, C. R., & Sarkar, S. (2007). Systematic conservation planning. *Nature*.

Maxwell, S. M., Hazen, E. L., Bograd, S. J., Halpern, B. S., Breed, G. A., Nickel, B., … Costa, D. P. (2013). Cumulative human impacts on marine predators. *Nature Communications*, *4*. doi:[10.1038/ncomms3688](http://dx.doi.org/10.1038/ncomms3688)

Nally, R. M., Fleishman, E., Thomson, J. R., & Dobkin, D. S. (2008). Use of guilds for modelling avian responses to vegetation in the intermountain west (USA). *Global Ecology and Biogeography*, *17*(6), 758–769. doi:[10.1111/j.1466-8238.2008.00409.x](http://dx.doi.org/10.1111/j.1466-8238.2008.00409.x)

O’Shea, T. J., & Brownell Jr., R. L. (1994). Organochlorine and metal contaminants in baleen whales: a review and evaluation of conservation implications. *Science of The Total Environment*, *154*(2-3), 179–200. doi:[10.1016/0048-9697(94)90087-6](http://dx.doi.org/10.1016/0048-9697(94)90087-6)

Phillips, S. J., Dud<span>í</span>k, M., Elith, J., Graham, C. H., Lehmann, A., Leathwick, J., & Ferrier, S. (2009). Sample selection bias and presence-only distribution models: implications for background and pseudo-absence data. *Ecological Applications*, *19*(1), 181–197. Retrieved from <http://www.esajournals.org/doi/abs/10.1890/07-2153.1>

Pressey, R. L., & Bottrill, M. C. (2009). Approaches to landscape- and seascape-scale conservation planning: Convergence, contrasts and challenges. *Oryx*, *43*(04), 464–475. doi:[10.1017/S0030605309990500](http://dx.doi.org/10.1017/S0030605309990500)

Pressey, R. L., Cabeza, M., Watts, M. E., Cowling, R. M., & Wilson, K. A. (2007). Conservation planning in a changing world. *Trends in Ecology & Evolution*, *22*(11), 583–592. doi:[10.1016/j.tree.2007.10.001](http://dx.doi.org/10.1016/j.tree.2007.10.001)

Read, A. J. (2008). The looming crisis: interactions between marine mammals and fisheries. *Journal of Mammalogy*, *89*(3), 541–548. doi:[10.1644/07-MAMM-S-315R1.1](http://dx.doi.org/10.1644/07-MAMM-S-315R1.1)

Ready, J., Kaschner, K., South, A. B., Eastwood, P. D., Rees, T., Rius, J., … Froese, R. (2010). Predicting the distributions of marine organisms at the global scale. *Ecological Modelling*, *221*(3), 467–478. doi:[10.1016/j.ecolmodel.2009.10.025](http://dx.doi.org/10.1016/j.ecolmodel.2009.10.025)

Redfern, J. V., Ferguson, M. C., Becker, E. A., Hyrenbach, K. D., Good, C., Barlow, J., … Werner, F. (2006). Techniques for cetaceanhabitat modeling. *Marine Ecology Progress Series*, *310*, 271–295. doi:[10.3354/meps310271](http://dx.doi.org/10.3354/meps310271)

Roberts, J. J., Best, B. D., Dunn, D. C., Treml, E. A., & Halpin, P. N. (2010). Marine geospatial ecology tools: An integrated framework for ecological geoprocessing with ArcGIS, python, r, MATLAB, and c++. *Environmental Modelling & Software*, *25*(10), 1197–1207. doi:[10.1016/j.envsoft.2010.03.029](http://dx.doi.org/10.1016/j.envsoft.2010.03.029)

Robinson, L. M., Elith, J., Hobday, A. J., Pearson, R. G., Kendall, B. E., Possingham, H. P., & Richardson, A. J. (2011). Pushing the limits in marine species distribution modelling: lessons from the land present challenges and opportunities. *Global Ecology and Biogeography*, *20*(6), 789–802. doi:[10.1111/j.1466-8238.2010.00636.x](http://dx.doi.org/10.1111/j.1466-8238.2010.00636.x)

Ross, P. S. (2006). Fireproof killer whales (orcinus orca): flame-retardant chemicals and the conservation imperative in the charismatic icon of british columbia, canada. *Canadian Journal of Fisheries and Aquatic Sciences*, *63*(1), 224–234. doi:[10.1139/f05-244](http://dx.doi.org/10.1139/f05-244)

Russell, B. A., Knowlton, A. R., & Zoodsma, B. (2001). Recommended measures to reduce ship strikes of north atlantic right whales. *National Marine Fisheries Service*.

Schick, R. S., Halpin, P. N., Read, A. J., Slay, C. K., Kraus, S. D., Mate, B. R., … Clark, J. S. (2009). Striking the right balance in right whale conservation. *Canadian Journal of Fisheries and Aquatic Sciences*, *66*(9), 1399–1403. doi:[10.1139/F09-115](http://dx.doi.org/10.1139/F09-115)

Schick, R. S., Loarie, S. R., Colchero, F., Best, B. D., Boustany, A., Conde, D. A., … Clark, J. S. (2008). Understanding movement data and movement processes: current and emerging directions. *Ecology Letters*, *11*(12), 1338–1350. doi:[10.1111/j.1461-0248.2008.01249.x](http://dx.doi.org/10.1111/j.1461-0248.2008.01249.x)

Schipper, J., Chanson, J. S., Chiozza, F., Cox, N. A., Hoffmann, M., Katariya, V., … Young, B. E. (2008). The status of the world’s land and marine mammals: Diversity, threat, and knowledge. *Science*, *322*(5899), 225–230. doi:[10.1126/science.1165115](http://dx.doi.org/10.1126/science.1165115)

Sheldon, D., Elmohamed, M. A., & Kozen, D. (2007). Collective inference on markov models for modeling bird migration. *Advances in Neural Information Processing Systems*, *20*, 1321–1328.

Shrader-Frechette, K. S., & <span>McCoy</span>, E. (1993). *Method in ecology: Strategies for conservation*. Cambridge, UK: Cambridge University Press. Retrieved from [http://www.sidalc.net/cgi-bin/wxis.exe/?IsisScript=UACHBC.xis\\&method=post\\&formato=2\\&cantidad=1\\&expresion=mfn=045014](http://www.sidalc.net/cgi-bin/wxis.exe/?IsisScript=UACHBC.xis\&method=post\&formato=2\&cantidad=1\&expresion=mfn=045014)

Taylor, B. L., Wade, P. R., Stehn, R. A., & Cochrane, J. F. (1996). A bayesian approach to classification criteria for spectacled eiders. *Ecological Applications*, *6*(4), 1077–1089.

Tew Kai, E., Rossi, V., Sudre, J., Weimerskirch, H., Lopez, C., Hernandez-Garcia, E., … Gar<span>ç</span>on, V. (2009). Top marine predators track lagrangian coherent structures. *Proceedings of the National Academy of Sciences*, *106*(20), 8245–8250. doi:[10.1073/pnas.0811034106](http://dx.doi.org/10.1073/pnas.0811034106)

Treml, E. A., Halpin, P. N., Urban, D. L., & Pratson, L. F. (2008). Modeling population connectivity by ocean currents, a graph-theoretic approach for marine conservation. *Landscape Ecology*, *23*, 19–36.

Urban, D. L., Minor, E. S., Treml, E. A., & Schick, R. S. (2009). Graph models of habitat mosaics. *Ecology Letters*, *12*(3), 260–273. doi:[10.1111/j.1461-0248.2008.01271.x](http://dx.doi.org/10.1111/j.1461-0248.2008.01271.x)

Urban, D., & Keitt, T. (2001). Landscape connectivity: a graph-theoretic perspective. *Ecology*, *82*(5), 1205–1218. doi:[10.1890/0012-9658(2001)082[1205:LCAGTP]2.0.CO;2](http://dx.doi.org/10.1890/0012-9658(2001)082[1205:LCAGTP]2.0.CO;2)

US Commission on Ocean Policy. (2004). *An ocean blueprint for the 21st century, final report*.

Vanderlaan, A. S., & Taggart, C. T. (2007). Vessel collisions with whales: the probability of lethal injury based on vessel speed. *Marine Mammal Science*, *23*(1), 144–156.

Vanderlaan, A. S., & Taggart, C. T. (2009). Efficacy of a voluntary area to be avoided to reduce risk of lethal vessel strikes to endangered whales. *Conservation Biology*, *23*(6), 1467–1474.

Vanderlaan, A. S., Taggart, C. T., Serdynska, A. R., Kenney, R. D., & Brown, M. W. (2008). Reducing the risk of lethal encounters: vessels and right whales in the bay of fundy and on the scotian shelf. *Endangered Species Research*, *4*(3), 283.

Vanderlaan, A., Corbett, J., Green, S., Callahan, J., Wang, C., Kenney, R., … Firestone, J. (2009). Probability and mitigation of vessel encounters with north atlantic right whales. *Endangered Species Research*, *6*, 273–285. doi:[10.3354/esr00176](http://dx.doi.org/10.3354/esr00176)

Wade, P. R. (2000). Bayesian methods in conservation biology. *Conservation Biology*, *14*(5), 1308–1316. Retrieved from <http://onlinelibrary.wiley.com/doi/10.1046/j.1523-1739.2000.99415.x/full>

Ward-Geiger, L. I., Silber, G. K., Baumstark, R. D., & Pulfer, T. L. (2005). Characterization of ship traffic in right whale critical habitat. *Coastal Management*, *33*(3), 263–278.

Weilgart, L. (2007). The impacts of anthropogenic ocean noise on cetaceans and implications for management. *Canadian Journal of Zoology*, *85*(11), 1091–1116.

Wiens, J. A. (1989). Spatial scaling in ecology. *Functional Ecology*, *3*(4), 385–397. Retrieved from <http://www.jstor.org/stable/2389612>

Wiley, D. N., Thompson, M., Pace <span>III</span>, R. M., & Levenson, J. (2011). Modeling speed restrictions to mitigate lethal collisions between ships and whales in the stellwagen bank national marine sanctuary, USA. *Biological Conservation*, *144*(9), 2377–2381. doi:[10.1016/j.biocon.2011.05.007](http://dx.doi.org/10.1016/j.biocon.2011.05.007)

Wood, L., & Dragicevic, S. (2007). GIS-based multicriteria evaluation and fuzzy sets to identify priority sites for marine protection. *Biodiversity and Conservation*, *16*(9), 2539–2558. doi:[10.1007/s10531-006-9035-8](http://dx.doi.org/10.1007/s10531-006-9035-8)

Worm, B., Barbier, E. B., Beaumont, N., Duffy, J. E., Folke, C., Halpern, B. S., … Watson, R. (2006). Impacts of biodiversity loss on ocean ecosystem services. *Science*, *314*(5800), 787–790. doi:[10.1126/science.1132294](http://dx.doi.org/10.1126/science.1132294)

Worm, B., Hilborn, R., Baum, J. K., Branch, T. A., Collie, J. S., Costello, C., … Zeller, D. (2009). Rebuilding global fisheries. *Science*, *325*(5940), 578–585. doi:[10.1126/science.1173146](http://dx.doi.org/10.1126/science.1173146)

[1] <http://seamap.env.duke.edu/search/?app=serdp>

[2] <http://www.code.env.duke.edu/projects/mget>

[3] <http://www.pifsc.noaa.gov/eod/turtlewatch.php>

[4] <http://www.nefsc.noaa.gov/psb/surveys/SAS.html>

[5] <http://www.gobi.org>

[6] <http://seamap.env.duke.edu>

[7] <http://groms.gbif.org>
