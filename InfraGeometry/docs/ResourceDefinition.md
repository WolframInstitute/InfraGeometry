---
Template: Paclet
ResourceType: Paclet
Name: WolframInstitute/InfraGeometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
Description: Geometry as the effective description of graph limits, observed at a scale
ContributedBy: Pavel Hajek, Wolfram Institute
Keywords: [infrageometry, geometry, graph, hypergraph, graph limit, observer, scale, geodesic, Euclidean geometry, synthetic geometry, Riemannian geometry, emergence]
MainGuide: Documentation/English/Guides/EuclideanInfrageometry.nb
License: MIT
WolframVersion: 14.3+
Categories: [Higher Mathematical Computation]
SourceControlURL: https://github.com/WolframInstitute/InfraGeometry
---

## Basic Description

Infrageometry is geometry on graphs and hypergraphs in which ordinary geometry, Euclidean, Riemannian or projective, emerges as an effective description of a limit of graphs, as seen by an observer at a given scale. The graph is all there is: no ambient space, no coordinates. An observer scale, the number of steps the observer inspects at once, comes before every object and every measurement. A construction returns every admissible answer rather than one, and some objects fail to exist at all; both are results, not defects. Infinitesimals are replaced by sequences of growing graphs: a notion is geometric when its densities converge along such a sequence.

## Details & Options

- The question is not which graph represents a given manifold, but which geometric theory a computationally bounded observer builds about the discrete substrate it inhabits: which notions make sense at its scale, and which properties they satisfy. Ordinary geometry is then the idealization of macro-experience by macro-observers, and infrageometry the proto-geometry it is a limit of. Dimension, curvature and the symmetries of space are measured, not assumed.
- Everything is computable at every level, so the framework is code. Where classical geometry prizes uniqueness and well-definedness, infrageometry enumerates every case, keeps the branching, aggregates robust observables and does statistics over them.
- The paclet has three branches. The synthetic branch constructs: points, segments, walks, lines, rays, circles, ellipses, shells, balls, polygons, planes, quadrics, and the Tarski and projective axioms over them. The Riemannian branch measures: volume growth, the dimension and curvature estimators read off it, coordinatization, the metric tensor. The symplectic branch is declared and empty.
- Install with <code>PacletInstall[ResourceObject["https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraGeometry"], ForceVersionInstall -> True]</code>, then load with <code>Needs["WolframInstitute\`InfraGeometry\`"]</code>.
- `InfraSubstrate` lives in this paclet, in the Riemannian branch (`Kernel/InfraSubstrate.wl`); the Euclidean Infrageometry guide lists it under Substrates and Drawing because every construction needs a substrate; the Infra Substrates guide covers it with the tessellation graphs. An example is one line and the reader never sees setup code.
- The Euclidean Infrageometry guide, [EuclideanInfrageometry](), is the landing page; every symbol it lists has a reference page.
