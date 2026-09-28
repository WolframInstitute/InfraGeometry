---
Template: Paclet
ResourceType: Paclet
Name: WolframInstitute/InfraGeometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
Description: Axiomatic geometry on graphs and hypergraphs
ContributedBy: Pavel Hajek, Wolfram Institute
Keywords: [geometry, graph, geodesic, Euclidean geometry, synthetic geometry, Riemannian geometry, Tarski, infrageometry]
MainGuide: Documentation/English/Guides/EuclideanGeometryGuide.nb
License: MIT
WolframVersion: 14.3+
Categories: [Higher Mathematical Computation]
SourceControlURL: https://github.com/WolframInstitute/InfraGeometry
---

## Basic Description

Euclidean geometry rebuilt inside a graph. The graph is all there is: no ambient space, no coordinates. Each Euclidean notion is redefined using graph properties alone, and the shortest-path metric is the layer these definitions sit on. A construction returns a set of admissible answers rather than one, and some objects fail to exist at all; both are results, not defects.

## Details & Options

- The paclet has three branches. The synthetic branch constructs: points, segments, walks, lines, rays, circles, ellipses, shells, balls, polygons, planes, quadrics, and the Tarski and projective axioms over them. The Riemannian branch measures: volume growth, the dimension and curvature estimators read off it, coordinatization, the metric tensor. The symplectic branch is declared and empty.
- Install with <code>PacletInstall[ResourceObject["https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraGeometry"], ForceVersionInstall -> True]</code>, then load with <code>Needs["WolframInstitute\`InfraGeometry\`"]</code>.
- Substrates come from `InfraSubstrate` in the sister paclet WolframInstitute/DiscreteGeometry, so an example is one line and the reader never sees setup code.
- The [EuclideanGeometryGuide]() is the landing page; every symbol it lists has a reference page.
