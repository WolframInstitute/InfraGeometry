---
Template: Symbol
Name: InfraPolygon
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/InfraPolygon
---

## Usage

`InfraPolygon[As, n]` is the family of regular n-gons whose k-th diagonals satisfy As[[k]]; RandomInfraRegularPolygon is the search and InfraRegularPolygonQ the test. The polygon through given corners is the closed polyline InfraSegment[p1, ..., pn, p1].

## Details & Options

This is the legacy compatibility spelling. New code uses `InfraRegularPolygon`.

The bare RandomInfraRegularPolygon form returns directed Graph legs; its InfraRegularPolygon or legacy InfraPolygon token form returns an ordered vertex sequence. No new corner-polygon or filling semantics are introduced.
