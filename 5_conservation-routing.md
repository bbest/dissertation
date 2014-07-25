4. Conservation Routing
=======================

Vessel traffic poses the threat of ship strike and spill of oil or other
toxins in the cargo. In Boston harbor where the critically endangered
right whales are of concern, shipping lanes were redrawn around a simple
right whale density of historical opportunistic sightings (Ward-Geiger
et al. 2005). This ad-hoc method doesn’t account for variability (which
may be currently infeasible for management) or observational bias or
other analytical rigor. Methods for incorporating multiple species in
such a routing analysis are untested to my knowledge. Studies have
worked on risk of ship strike vs. cost of vessel rerouting based on
pre-defined track (Ward-Geiger et al. 2005; Vanderlaan and Taggart 2007;
Fonnesbeck et al. 2008; Vanderlaan et al. 2008; Schick et al. 2009).

To avoid encounters with marine mammals, relative hotspots of expected
encounter are to be avoided, and routed around. Least-cost algorithms,
such as Djikstra’s algorithm, are commonly used with the prevalence of
online driving directions and many other route-optimization
applications. These graph-theoretic algorithms have also been playing an
increasing role in routing corridors of habitat and testing connectivity
of habitat patches (Chetkiewicz et al. 2006) for both terrestrial (Urban
and Keitt 2001) and marine applications (Treml et al. 2008). Density
surface model outputs will be assembled into a marine mammal composite
risk map, or cost surface. Each density surface was normalized in order
to highlight areas of high density relative to its average. The unitless
standard score, or z-value (zi), per pixel (i) is calculated as the
pixel’s marine mammal density estimate (xi) subtracted from the mean of
all density estimates for the strata (μ), divided by the standard
deviation of those density estimates (σ) and finally multiplied by the
species weight (w).

An inverse weighting scheme based on species conservation status will be
applied to favor representation of more endangered species (Wood and
Dragicevic 2007). These rankings were obtained from the Provincial
listing status at British Columbia’s Endangered Species and Ecosystems
website . Elephant seal is listed as SNA, species “not applicable”,
presumably because of its semi-migratory status in BC waters. Given that
it’s status is S4 in California and Alaska to the south and north of BC,
this status was used to conform with the scheme. The values on the
y-axis indicate the relativised weight used in the analysis. The cost
surface from the composite risk map provides the biological hotspot
surface around which to route. The routing will be performed with Python
scripts using ESRI’s ArcGIS ArcInfo version 9.3 with the Spatial Analyst
toolbox. The CostPath function was used with input cost distance and
back-directional raster grids generated from the CostDistance function.
The 5km original density surface grids will be resampled to a 1km
resolution for use as the resistance cost surface to provide finer
spatial resolution and routing within the inlets. An alternative raster
grid in which all cells would be assigned a cost value of 1 serves as
the Euclidean linear distance optimal spatial route providing a
comparison of direct routing.

Oil tanker routes were proposed for the inside waters of BC to Port
Kittimat. This figure will be digitized and endpoints for north and
south approaches used with the exercise to test the framework moving in
and out of Kitimat. Routes between all navigation points, originally
including other ports (Prince Rupert and Port Hardy), will also be
calculated. Existing routes may have preference for other factors than
efficiency, such as scenic beauty or protection against inclement
weather. Given that existing routes are generally preferred, a cost can
be associated with movement away from these preferred routes. Here we
take the case of cruise routes reported online . Euclidean distance from
existing cruise route was relativized by the maximum within the study
area and multiplied by the maximum cost surface value. The two surfaces
will be added to obtain the final cost surface for routing, providing an
example of equal weighting to conservation and routing goals.

The relative weights of these layers could be gleaned from the past
precedent of re-routing shipping lanes in Boston Harbor based on overlap
with a density of right whale observations. A similar spatial
decision-making process could then be applied globally as thought
experiment using the global shipping layer from (Halpern, Walbridge, et
al. 2008).

References
----------
