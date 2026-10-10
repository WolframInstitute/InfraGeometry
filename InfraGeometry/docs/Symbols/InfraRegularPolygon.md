---
Template: Symbol
Name: InfraRegularPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraRegularPolygon
---

## Usage

`InfraRegularPolygon[As, n]` is the family of regular n-gons whose k-th diagonals satisfy As[[k]]; RandomInfraRegularPolygon is the search and InfraRegularPolygonQ the test. The polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1].

## Details & Options

The bare RandomInfraRegularPolygon form returns directed Graph legs; the InfraRegularPolygon token form returns an ordered vertex sequence. The legacy InfraPolygon token has the same regular-family meaning. No corner-polygon filling is introduced.
