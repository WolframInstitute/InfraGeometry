---
Template: Symbol
Name: FindInfraPolylineSubdivision
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraPolylineSubdivision
---

## Usage

`FindInfraPolylineSubdivision[graph, path]` returns the legs, one directed path graph each: the fewest geodesic legs whose knots are path-vertices, each leg a shortest path since the previous knot. Their knots are the corners of the polyline InfraSegment[p1, ..., pk].

## Details & Options

Option: "MaxLength" (Infinity (default) | numeric L) caps every leg's graph-length at L.
