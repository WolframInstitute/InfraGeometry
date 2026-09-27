---
Template: Symbol
Name: InfraPolyline
Context: WolframInstitute`SyntheticInfrageometry`
ContextPath: [WolframInstitute`Infrageometry`]
Paclet: WolframInstitute/SyntheticInfrageometry
URI: WolframInstitute/SyntheticInfrageometry/ref/InfraPolyline
---

## Usage

`InfraPolyline[{v1, ..., vk}]` inside InfraScene is the open geodesic chain through the given knots.

## Details & Options

A polyline itself is the List of its legs, one directed path graph each, consecutive legs sharing a knot (the last vertex of one leg is the first of the next). FindInfraPolylineSubdivision chunks a walk into such legs, and InfraPolylineQ tests the shape.

Consumed by InfraHighlightGraph, which draws the legs as one chain with the knots on top.
