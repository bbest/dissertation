




# Marine Conservation Routing: Transparently Deciding Tradeoffs between Risk to Species and Cost to Industry

## Abstract

Human activities such as shipping and cruising can harm endangered marine mammals through ship strike, acoustic noise and pollution. In the case of right whales in the Gulf of Maine, shipping lanes have been routed around observational hotspots of right whales. Voluntary avoidance areas have been designated elsewhere. Rerouting to date has been handled in an ad-hoc individual basis. Instead, I propose a tradeoff analysis that weights cost to industry versus risk to species. The cost to industry can be tailored to industry profiles based on extra commute distance deviating from the least cost Euclidean path. The risk to species is aggregated from species distribution models based on weights of extinction risk and sensitivities to the industry chosen profile. The final species risk surface acts as the resistance surface by which least-cost routing is implemented. Transformations are applied to this surface for providing a series of routes offering a range of tradeoffs between conservation and industry. Tradeoffs from past decisions can be mapped into this framework for providing consistent decision making elsewhere in a systematic manner. Where species distributions are available seasonally or forecast given present or future environmental conditions, routes can be dynamically generated. Realtime feedback through an interactive online application facilitates transparent decision making by industry professionals and governmental policy makers.

## Introduction

Vessel traffic poses the threat of ship strike, acoustic noise and spill of oil or other cargo pollutants. Reducing risk to endangered wildlife while maintaining human activities and maritime operations requires objective assessment of species habitats and human uses in both space and time. In order to better assess management options for separating endangered species and potentially harmful interactions we need to develop a synthetic, composite valuation of our marine species and then apply explicit optimization methods. Here we build a cost surface based on species distributions that are then applied to optimize the routing of vessels in the region to potentially reduce the risk of adverse interactions.

In Boston harbor where the critically endangered right whales are of concern, shipping lanes were redrawn around a simple right whale density of historical opportunistic sightings [@ward-geiger_characterization_2005]. This ad-hoc method doesn’t account for variability in species distribution, observational bias or other analytical rigor for easily applying elsewhere. Methods for incorporating multiple species in such a routing analysis are untested. Studies have worked on risk of ship strike vs. cost of vessel rerouting based on a pre-defined track [@ward-geiger_characterization_2005; @vanderlaan_vessel_2007; @vanderlaan_probability_2009; @vanderlaan_efficacy_2009; @vanderlaan_reducing_2008; @fonnesbeck_bayesian_2008; @schick_striking_2009], but have yet to be suggested in a prescriptive manner.

To avoid encounters with marine mammals, hotspots of expected encounters are to be avoided, and routed around. Least-cost path algorithms, such as Djikstra’s, are commonly used in online driving directions and many other route-optimization applications. These graph-theoretic algorithms have also been playing an increasing role in routing corridors of habitat and testing connectivity of habitat patches [@chetkiewicz_corridors_2006] for both terrestrial [@urban_landscape_2001; @urban_graph_2009] and marine applications [@treml_modeling_2008]. The algorithm minimizes the total cost of travel between two points traversing over a resistance surface. For the sake of this conservation routing problem, the resistance surface represents the risk of species encounter.

To create this synthetic cost surface, individual species density surfaces were first relativized, and then weighted by conservation score before adding them up into a single cost surface layer. The cost surface was then used to determine alternate navigation routes for ships, which have the potential for striking animals or fouling habitat from potential spills. These methods employ least-cost path algorithms as a means to develop vessel paths that follow the most economical path through the environment while avoiding areas of high environmental risk.

In our case study area of British Columbia, an oil pipeline has been routed to Port Kittimat and oil tankers are being routed from the points of entry north and south of the Haida Gwaii islands (FIGURE XX).

While a wide variety of industries are increasingly active in the coastal waters of British Columbia, many environmental groups (PNCIMA, BCMCA, LOS) are seeking conservation-minded solutions for safely locating activities. The current ecological data layers in widest use are based on an expert feedback approach delineating important areas. Several large oil and gas projects that are currently underway are likely to increase heavy shipping into Kitimat [@enviroemergconsultingservices_major_2008], making this a useful example of the approach. One map ([[Figure  3](#Figure_3)](#bc_routes_proposed)) depicts the areas in the latest draft PNCIMA Atlas, originally provided by [@clarke_identification_2006]. The maps in these atlases identify areas of importance as polygons. These polygon areas are then overlaid and summed to create an index of potential importance and environmental sensitivity.  In the absence of observational data, this qualitative approach is the best available science. Given the availability of Raincoast surveys [@best_updated_2015], the density surfaces of each species can be combined to provide a more quantitative layer for planning purposes.

Existing routes may have preference for other factors than efficiency, such as scenic beauty or protection against inclement weather. Given that existing routes are generally preferred, a cost can be associated with movement away from these preferred routes. Here we take the case of cruise routes reported online. Euclidean distance from existing cruise route was relativized by the maximum within the study area and multiplied by the maximum cost surface value. The two surfaces can be added to obtain the final cost surface for routing, providing an example of equal weighting to conservation and routing goals.

The relative weights of these layers could be gleaned from the past precedent of re-routing shipping lanes in Boston Harbor based on overlap with a density of right whale observations. A similar spatial decision-making process could then be applied globally as thought experiment using the global shipping layer from [@halpern_global_2008]. The ability to operationally provide a framework for minimizing impacts on marine animals is especially appealing. For example, ship traffic lanes have been re-routed in Boston Harbor to reduce likelihood of striking right whales [@russell_recommended_2001; @ward-geiger_characterization_2005; @fonnesbeck_bayesian_2008]. Global data layers on human impacts in marine systems are being actively developed, including vessel traffic density [@halpern_global_2008]. Here we provide a simple framework for proposing alternative shipping routes to minimize impacts on marine animals. In this framework competing priorities, such as cost of additional travel distance and time versus risk of striking a marine mammal can be more objectively assessed.

## Methods

### Species Distributions

See [@best_updated_2015].

For harbour seals and stellar sea lions, the in and out of water densities were added to produce the single species density estimates. The standard errors were also added using the delta method (Seber Ref).

### Cumulative Risk Surface

Density surface model outputs were assembled into a marine mammal composite risk map, or cost surface. Each species density surface was normalized in order to highlight areas of high density relative to its average. The unitless standard score, or z-value ($z$), per species ($s$) and pixel ($i$) is calculated as the pixel’s marine mammal density estimate ($x_{i,s}$) subtracted from the mean of all density estimates for the species ($\mu_s$), divided by the standard deviation of those density estimates ($\sigma$). The final conservation score per pixel ($Z_i$) represents the sum of all species scores ($z_{i,s}$) weighted by the extinction risk ($w_s$).

$$
z_{i,s} = \frac{ x_{i,s} - \mu_s }{ \sigma_s }
$$
$$
Z_i = \frac{ \sum_{s=1}^{n} z_{i,s} w_s }{ n }
$$

**ALTERNATIVE**. Rank density into:

1. 0, or negligibly present.
1. 1 = low
1. 2 = below average
1. 3 = average
1. 4 = above average
1. 5 = high

<!---
TODO:
Is $\sigma$ per pixel or for entire DSM?
How does uncertainty play into this decision making?
--->

An inverse weighting scheme based on species extinction risk ([Figure  4](#Figure_4)) was applied to favor representation of more endangered species [@wood_gis_2007]. These rankings were obtained from the Provincial listing status at British Columbia’s Endangered Species and Ecosystems website (http://www.env.gov.bc.ca/atrisk). Elephant seal is listed as SNA, species “not applicable”, presumably because of its semi-migratory status in BC waters. Given that its status is S4 in California and Alaska to the south and north of BC, this status was used to conform with the scheme. The values on the y-axis indicate the relativised weight used in the analysis.

From supplemental in [@maxwell_cumulative_2013]...

> _**Methods**_
> The vulnerability weight of each stressor was determined through ranking of six measures: (1) stressor frequency, (2) if the impact was direct or indirect, (3) resistance of the species to the stressor, (4) recovery time of an individual from the impact, (5) relative impact on reproduction and (6) relative impact on the population (detailed description in Supplementary Table S4). All vulnerability measures were normalized (scaled between 0 and 1) and summed to obtain a weight for each stressor for each species (Supplementary Table S2; Supplementary Note 1 for summary of each impact).

> **Supplementary Table S4**. Summary of vulnerability measures used to determine the weightings for impact scores across species.

> 1. **Frequency** (0 - 4): What is the frequency of the impact?
> 1. **Direct/Indirect impact** (0 - 3): What’s the mechanism by which it is affecting the _individual_?
> 1. **Resistance (Likelihood of mortality)** (0 - 3): How likely is that impact to affect the individual?
> 1. **Recovery time of individual (years)** (0 - 4): How long does it take the individual to recover from exposure to the impact?
> 1. **Reproductive Impacts** (0 - 3): What is the level of impact on reproduction of an individual?
> 1. **Population Effects** (0 - 3): How are the impact distributed across the population?

[TODO: get original summaries of these for described spp. Max possible: 20]

> _**Ocean-Based Pollution**_
> Ocean-based pollution in the form of discharge from ships or large-scale oil spills can impact all predator species but has perhaps the greatest impacts on seabirds111-113. Oiled birds can lose flight capability in addition to wasting fat and muscle tissues, abnormal conditions in the lungs, kidneys and other organs from even small amounts of exposure to oil slicks97,114,115.
  
  
> _**Shipping**_
> Impacts on marine mammals and sea turtles from shipping occur in the form of ship strikes128,129. Though rare for most species, this impact is of particular concern to even the largest whales that are killed as a result of ship strikes130-132. Studies in the North Atlantic have shown that over 40% of right whale mortalities are attributable to ship strikes133. Seabirds are attracted to ship lights at night and are killed or injured when they strike parts of the ship134, though this has not been well studied in the California Current region.

### Vessel Routing

The routing will be performed with Python scripts using ESRI’s ArcGIS ArcInfo version 9.3 with the Spatial Analyst toolbox. The CostPath function was used with input cost distance and back-directional raster grids generated from the CostDistance function. The 5km original density surface grids will be resampled to a 1km resolution for use as the resistance cost surface to provide finer spatial resolution and routing within the inlets. An alternative raster grid in which all cells would be assigned a cost value of 1 serves as the Euclidean linear distance optimal spatial route providing a comparison of direct routing.

The cost surface from the composite risk map provides the biological hotspot surface around which to route. The routing was performed with Python scripts using ESRI’s ArcGIS ArcInfo version 9.3 with the Spatial Analyst toolbox. The CostPath function was used with input cost distance and back-directional raster grids generated from the CostDistance function. The 5km original density surface grids were resampled to a 1km resolution for use as the resistance cost surface to provide finer spatial resolution and routing within the inlets. An alternative raster grid in which all cells were assigned a cost value of 1 served as the Euclidean linear distance optimal spatial route providing a comparison of direct routing.

The proposed routes from Figure 10 were digitized and endpoints for north and south approaches used with the exercise to test the framework moving in and out of Kitimat. Routes between all navigation points, originally including other ports (Prince Rupert and Port Hardy), were also calculated. Existing routes may have preference for other factors than efficiency, such as scenic beauty or protection against inclement weather. Given that existing routes are generally preferred, a cost can be associated with movement away from these preferred routes. Here we take the case of cruise routes reported online . Euclidean distance from existing cruise route was relativized by the maximum within the study area and multiplied by the maximum cost surface value. The two surfaces were added to obtain the final cost surface for routing, providing an example of equal weighting to conservation and routing goals.

## Results

The composite risk map for all marine mammals (Figure 12) is very similarly distributed as just the large whales (Figure 13) composed of killer, humpback, fin and minke whale. Consistent with [@clarke_identification_2006], Hecate Strait was found to be relatively important, along with the Dixon entrance. The highest value hotspot is in Gwaii Hanas Reserve, already under some level of protection. The high levels in stratum 3 Johnstone  Strait (see zoom view) may be an anomaly of the environmental conditions there, since few sightings were made by comparison.

The routes do differ markedly (Figure 14). It is not clear whether Grenville Channel is deep and wide enough to support the kind of tanker traffic envisioned. Besides being closer to the northern approach, as evidenced by that inlet choice with the Euclidean path, Grenville Channel exhibits a lower level of potential marine mammal interaction as predicted by the composite marine mammal densities than through the Principe Channel as proposed. By routing through the Grenville Channel the potential interactions in the Hecate Strait could also be avoided. The proposed Southern approach exhibits relatively lower potential interactions with the least-cost route even dipping south around the Gwaii Haanas Reserve.

The existing ship routes pass through both the Principe and Grenville Channels. Models developed to conduct least-cost path analysis use raster grid cells. For modeling purposes these cells provide eight possible directions at each step (i.e. 4 side and 4 diagonal directions). These models create uneven turns when compared to the smoother Euclidean route or with the proposed routes (Figure 15). Although the Euclidean path should be the shortest, the existing industry route up the Principe Channel is the shortest ([Table  2](#Table_2)).

TODO: describe [Table  1](#Table_1).

## Discussion



## Tables

| Species        | Oil Tanker | Shipping Tanker | Cruise Ship |
|----------------|------------|-----------------|-------------|
| fin whale      |        100 |             100 |         100 |
| humpback whale |         70 |              70 |          70 |
| killer whale   |        100 |                 |             |
| ...            |            |                 |         ... |

  : <a name="Table_1"}></a>Table  1: Impact scores [0 to 100] on species by human activity.


| Route | Euclidean | Industry | Least-Cost |
|-------|-----------|----------|------------|
| Kitimat to N. Approach (Conservation) | 391 | 410 | 425 |
| Kitimat to S. Approach (Conservation) | 304 | 319 | 336 |
| S. to N. Cruise Route (Conservation + Distance to Route) | 470 | 450 | 504 |

  : <a name="Table_2"}></a>Table  2: Distances of routes in km. For the oil transportation example in and out of the Kitimat port only the conservation surface is used for generating the least-cost route, compared to the industry-proposed route and Euclidean path. The cruise ship industry path comes from existing routes, the distance from which is summed with the conservation surface to provide the total cost surface with which to route the least-cost path. Since the cruise ship route splits, the distance for the one going up Principe Channel is shown.

## Figures

![<a name="Figure_1"}></a>Figure  1: The process of conservation routing starts with gathering species densities (1a) created from species distribution models that correlate the environment with the observations. Industries (1b) can have differential impacts on species and costs associated with routing.](fig/routing_process.png)

![<a name="Figure_2"}></a>Figure  2: Interactive routing application with chart (left) of cost to industry versus risk to species in which the selected tradeoff (blue point) corresponds to the route (blue line) displayed within the interactive map (right) of the study area. Available online at [http://bdbest.shinyapps.io/consmap](http://bdbest.shinyapps.io/consmap).](fig/routing_app_tradeoff-map.png)

![<a name="Figure_3"}></a>Figure  3: On the left, polygons of important areas for gray, humpback, and sperm whales derived from expert opinion in the PNCIMA Atlas (Draft 2009). On the right, proposed tanker vessel route for servicing the forthcoming Kitimat oil and gas projects (EnviroEmerg Consulting Services 2008).](fig/bc_routes_proposed.png)

![<a name="Figure_4"}></a>Figure  4: Weighting by BC conservation status for fin whale (FW), Steller sea lion (SSL), harbour porpoise (HP), humpback whale (HW), killer whale (KW), Elephant seal (ES), minke whale (MW), Dall’s porpoise (DP), Pacific white-sided dolphin, and harbour seal (HS).](fig/bc_species_weights.png)

![<a name="Figure_5"}></a>Figure  5: Conservation-weighted composite map of all marine mammal z-scored densities.](fig/bc_composite_risk_map.png)

![<a name="Figure_6"}></a>Figure  6: Proposed, linear (Euclidean), and least-cost routes for oil tankers to Port Kitimat. The least-cost route uses the conservation weighted cost surface.](fig/bc_route_oil_tankers.png)

![<a name="Figure_7"}></a>Figure  7: Existing, Euclidean and least-cost routes for cruise ships along the BC coast. The least-cost route uses a cost surface which is the sum of the conservation risk surface and a surface of distance from existing routes scaled to the equivalent range. The least cost-path is chosen which thus avoids biological hotspots while being equally attracted to existing routes.](fig/bc_route_cruise_ships.png)

![<a name="Figure_8"}></a>Figure  8: Ships were rerouted in Boston Harbor around hotspots of right whale observations, but in ad-hoc fashion without quantitifying the tradeoff between cost to industry and conservation gain. Source: [@ward-geiger_characterization_2005].](fig/routing_boston_harbor.png)

![<a name="Figure_9"}></a>Figure  9: Given this spatial decision framework, routes to all ports globally could be similarly proposed. [@halpern_global_2008].](fig/routing-global-traffic_sized.png)

## Notes

TODO:
- add figure: tradeoff points + route map, color coded
    - optimal least-cost on outside
    - less optimal, linearized for IMO shipping lane standards
- handle speed reductions in given areas (see Schick 2008; Vanderwaal), which accumulate lower risk
- compliance: Vanderwaal, elsewhere
- industry routing: weather, other considerations?
- TIME:
  - show routes over time with same decision point
- APP:
    - do real time routing
- feedback from Raincoast, Mersk, Shaun on actual application. How could this relate to insurance incentivizing program?
- research issues with SB Channel in trying to get rerouting accomplished

## References
