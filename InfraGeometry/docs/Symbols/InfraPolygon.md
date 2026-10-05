---
Template: Symbol
Name: InfraPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPolygon
---

## Usage

`InfraPolygon[As, n]` is the inert family of regular n-gons whose k-th diagonals satisfy As[[k]]; FindInfraRegularPolygon is the search and InfraRegularPolygonQ the test. The polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1].

## Details & Options

A polygon itself is the List of its sides, one directed path graph each, consecutive sides sharing a corner. Its perimeter is the total edge count of the sides.
