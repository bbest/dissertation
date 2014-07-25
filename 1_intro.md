Introduction
============

Modern conservation of marine megafauna is dependent upon prioritizing
areas within the context of a changing climate and increasing array of
human activities. Concurrent with a rise in conflicting human uses has
been a rapid decline in overall marine biodiversity and ecosystem
services (Worm et al. 2006, 2009, Halpern et al. 2008b, Butchart et al.
2010). In response, recent calls for holistic management practices, such
as ecosystem-based management and marine spatial planning, are
encouraging multi-species, multi-sector approaches (Ocean Policy 2004,
Crowder et al. 2006, Halpern et al. 2008a, Crowder and Norse 2008,
Douvere 2008, Dahl et al. 2009, Lubchenco and Sutley 2010, Foley et al.
2010). For these applications I’ll be focusing on marine spatial
planning of cetaceans, but methods will be transferable to other marine
megafauna. In the US, marine mammals are legally protected through the
Marine Mammal Protection Act and 22 are listed as threatened or
endangered so are covered by The Endangered Species Act. Human
activities that pose threats include: fishing bycatch or prey depletion
(Laist et al. 2001), ship strikes (Weilgart 2007), anthropogenic noise
(O’Shea and Brownell Jr. 1994; Aguilar et al. 2002), pollution of oil or
bioaccumulating contaminants (Learmonth et al. 2006; Alter et al. 2010),
and global climate change (Dolman et al. 2009). Relocating potentially
harmful human activities away from known cetacean distributions is
generally the safest and simplest way to minimize risk (Redfern et al.
2006).

![Example of complex management from Crowder et al.
(2006)](fig/MSP-SoCal_Crowder2006-Science.png)

The current state of marine spatial planning begs several broad
questions of decision makers and decision support scientists. How do you
optimize use of ocean resources to provide long-term ecosystem services
in a sustainable manner while minimizing impacts on endangered species?
How much risk are you willing to accept? What are the tradeoffs between
conservation value and economic impact? How do you handle poor data
availability within marine systems? How do you manage the dynamic nature
of the environment with species distributions? How do you handle
uncertainty while making spatial decisions? Which human uses require
custom applications?

While much work has been done already to support description of species
distributions for planning purposes (Margules and Sarkar 2007; Pressey
et al. 2007; Elith and Leathwick 2009; Pressey and Bottrill 2009), there
is room for improvement in answering the questions above for adopting a
marine operational framework.

Over the next 5 chapters I propose methods for addressing these
questions within two study areas, British Columbia and US Atlantic. 1) I
start with pooling boat and plane datasets in order to incorporate more
data into the species distribution models (SDMs). A variety of SDMs will
be compared for their requirements, outputs and performance.
Improvements in the SDMs will include novel environmental predictors,
addressing scale and exploring lags in space and time. 2) Decision
Mapping provides a framework for incorporating uncertainty into decision
making spatially. 3) Seasonal Migrations explicitly includes
time-varying habitats in SDMs. 4) Probabilistic Range Maps combine range
maps and occurrence through a Bayesian environmental model. 5) In
Conservation Routing layers of species data are combined into a single
cost surface for routing ships using least cost paths. These tools
should enable a more transparent, operational and robust set of methods
for incorporating cetacean species distribution models into the marine
spatial planning process.

References
----------

Butchart, S. H. M., M. Walpole, B. Collen, A. van Strien, J. P. W.
Scharlemann, R. E. A. Almond, J. E. M. Baillie, B. Bomhard, C. Brown, J.
Bruno, K. E. Carpenter, G. M. Carr, J. Chanson, A. M. Chenery, J.
Csirke, N. C. Davidson, F. Dentener, M. Foster, A. Galli, J. N.
Galloway, P. Genovesi, R. D. Gregory, M. Hockings, V. Kapos, J.-F.
Lamarque, F. Leverington, J. Loh, M. A. McGeoch, L. McRae, A. Minasyan,
M. H. Morcillo, T. E. E. Oldfield, D. Pauly, S. Quader, C. Revenga, J.
R. Sauer, B. Skolnik, D. Spear, D. Stanwell-Smith, S. N. Stuart, A.
Symes, M. Tierney, T. D. Tyrrell, J.-C. Vie, and R. Watson. 2010. Global
biodiversity: Indicators of recent declines. Science 328:1164–1168.

Crowder, L. B., G. Osherenko, O. R. Young, S. Airame, E. A. Norse, N.
Baron, J. C. Day, F. Douvere, C. N. Ehler, B. S. Halpern, S. J. Langdon,
K. L. McLeod, J. C. Ogden, R. E. Peach, A. A. Rosenberg, and J. A.
Wilson. 2006. Resolving mismatches in u.s. ocean governance. Science
313:617–618.

Crowder, L., and E. Norse. 2008. Essential ecological insights for
marine ecosystem-based management and marine spatial planning. Marine
Policy 32:772–778.

Dahl, R., C. Ehler, and F. Douvere. 2009. Marine spatial planning, a
step-by-step approach toward ecosystem-based management. IOC Manuals and
Guides 53.

Douvere, F. 2008. The importance of marine spatial planning in advancing
ecosystem-based sea use management. Marine Policy 32:762–771.

Foley, M. M., B. S. Halpern, F. Micheli, M. H. Armsby, M. R. Caldwell,
C. M. Crain, E. Prahler, N. Rohr, D. Sivas, M. W. Beck, M. H. Carr, L.
B. Crowder, J. Emmett Duffy, S. D. Hacker, K. L. McLeod, S. R. Palumbi,
C. H. Peterson, H. M. Regan, M. H. Ruckelshaus, P. A. Sandifer, and R.
S. Steneck. 2010. Guiding ecological principles for marine spatial
planning. Marine Policy 34:955–966.

Halpern, B. S., K. L. McLeod, A. A. Rosenberg, and L. B. Crowder. 2008a.
Managing for cumulative impacts in ecosystem-based management through
ocean zoning. Ocean & Coastal Management 51:203–211.

Halpern, B. S., S. Walbridge, K. A. Selkoe, C. V. Kappel, F. Micheli, C.
D’Agrosa, J. F. Bruno, K. S. Casey, C. Ebert, H. E. Fox, R. Fujita, D.
Heinemann, H. S. Lenihan, E. M. P. Madin, M. T. Perry, E. R. Selig, M.
Spalding, R. Steneck, and R. Watson. 2008b. A global map of human impact
on marine ecosystems. Science 319:948–952.

Lubchenco, J., and N. Sutley. 2010. Proposed u.s. policy for ocean,
coast, and great lakes stewardship. Science 328:1485–1486.

Ocean Policy, U. C. on. 2004. An ocean blueprint for the 21st century,
final report.

Worm, B., E. B. Barbier, N. Beaumont, J. E. Duffy, C. Folke, B. S.
Halpern, J. B. C. Jackson, H. K. Lotze, F. Micheli, S. R. Palumbi, E.
Sala, K. A. Selkoe, J. J. Stachowicz, and R. Watson. 2006. Impacts of
biodiversity loss on ocean ecosystem services. Science 314:787–790.

Worm, B., R. Hilborn, J. K. Baum, T. A. Branch, J. S. Collie, C.
Costello, M. J. Fogarty, E. A. Fulton, J. A. Hutchings, S. Jennings, O.
P. Jensen, H. K. Lotze, P. M. Mace, T. R. McClanahan, C. Minto, S. R.
Palumbi, A. M. Parma, D. Ricard, A. A. Rosenberg, R. Watson, and D.
Zeller. 2009. Rebuilding global fisheries. Science 325:578–585.
