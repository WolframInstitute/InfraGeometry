---
Template: Paclet
ResourceType: Paclet
Name: WolframInstitute/InfraGeometry
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
Description: Geometry as an effective description of large graphs
ContributedBy: Pavel Hajek, Wolfram Institute
Keywords: [infrageometry, geometry, graph, hypergraph, graph limit, observer, scale, geodesic, Euclidean geometry, synthetic geometry, Riemannian geometry, emergence]
MainGuide: Documentation/English/Guides/EuclideanInfrageometry.nb
License: MIT
WolframVersion: 14.3+
Categories: [Higher Mathematical Computation]
SourceControlURL: https://github.com/WolframInstitute/InfraGeometry
---

## Basic Description

This repository contains experimental code and a developing language for geometry emerging as an effective description of large graphs at a large observer scale, aligned with the vision of [Stephen Wolfram](https://writings.stephenwolfram.com/).

Our goal is to demonstrate how **Euclidean, Riemannian, and symplectic geometry** emerge in limits of graphs. We view a graph as a webbing of paths and seek the essence of geometry in this webbing. An essential element is an observer who determines properties of the observed geometry.

The eventual goal of infrageometry is to explain the emergence of space in hypergraph rewriting models of the universe, as described in the [Wolfram Physics Project technical introduction](https://www.wolframphysics.org/technical-introduction/). Note that hyperedges are not needed to recover the classical geometries.

## Hero Image

```wl
With[
  {image = ImageResize[
    Import @ SelectFirst[
      {
        FileNameJoin[ {Quiet @ Check[ NotebookDirectory[], "" ], "..", "..", "assets", "emergent-triangle.png"} ],
        FileNameJoin[ {Directory[], "InfraGeometry", "assets", "emergent-triangle.png"} ],
        FileNameJoin[ {DirectoryName @ DirectoryName @ $InputFileName, "InfraGeometry", "assets", "emergent-triangle.png"} ]
      },
      FileExistsQ],
    {1500, Automatic}]},
  ImagePad[ image, {{0, 0}, {135, 135}}, Transparent]]
```

## Details & Options

- Infrageometry asks which geometric objects and measurements can be defined intrinsically on a graph for a given observer, and when they converge to their classical counterparts along sequences of graphs. Dimension, curvature and symmetry are aggregated properties of the substrate that are measured rather than assumed.
- Everything is computable at every level, so the framework is code. Where classical geometry prizes uniqueness and well-definedness, infrageometry enumerates every case, keeps the branching, aggregates robust observables and does statistics over them.
- Install with <code>PacletInstall[ResourceObject["https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraGeometry"], ForceVersionInstall -> True]</code>, then load with <code>Needs["WolframInstitute\`InfraGeometry\`"]</code>.

## Author Notes

Reviewed by Pavel Hajek on 18 October 2026.
