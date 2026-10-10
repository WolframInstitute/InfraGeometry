---
Template: TechNote
Name: NamedConstructionSamplers
Title: Named Construction Samplers
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/tutorial/NamedConstructionSamplers
Keywords: [sampling, construction, migration, representatives]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry]
---

Synthetic constructions now have separate named samplers.
The former public generic representative sampler is removed, with no compatibility alias.

A token call preserves its declared carrier and sampling law.
A bare half-line or infinite-line call retains its original traversal law; its token call samples the shortest-path DAG family.
A bare regular polygon returns directed Graph legs; its token returns an ordered vertex sequence.
A bare geodesic returns a position-spelled Graph; its token returns an ordered sequence.

```wolfram
With[ { graph = PathGraph[ Range[ 5 ] ] },
  RandomInfraHalfLine[ graph, InfraHalfLine[ 2, 3 ], All ] ]
```

```wolfram
With[ { graph = PathGraph[ Range[ 5 ] ] },
  RandomInfraBall[ graph, InfraBall[ 3, 1 ], All ] ]
```

The old inert Ray, Line and Polygon spellings remain supported for this release.
Their canonical names are InfraHalfLine, InfraInfiniteLine and InfraRegularPolygon.
The old named ray and line samplers and predicates forward without drawing extra random numbers.

Omitted or Automatic count selects one representative.
An integer requests exactly that many distinct representatives, UpTo gives at most that many, and All enumerates the complete pool.
Negative counts and unsupported options stay unevaluated.
Default All and Identity do not advance random state.
An explicit legacy stochastic selector retains its original action.

Ball, Shell, Tube, Cylinder, Cone, SolidOfRevolution, BallHull, ConvexHull and Quadric each have one set representative, including an empty set.
Intersection and Union sample points from complete operand supports.
Point labels that are Lists remain intact.

The named functions are RandomInfraPoint, RandomInfraSegment, RandomInfraHalfLine, RandomInfraInfiniteLine, RandomInfraCircle, RandomInfraArc, RandomInfraRegularPolygon, RandomInfraPlane, RandomInfraBall, RandomInfraShell, RandomInfraSphere, RandomInfraTube, RandomInfraCylinder, RandomInfraCone, RandomInfraSolidOfRevolution, RandomInfraBallHull, RandomInfraConvexHull, RandomInfraQuadric, RandomInfraWalk, RandomInfraGeodesic, RandomInfraEllipse, RandomInfraIntersection, RandomInfraUnion, RandomInfraMidpoint, RandomInfraPerpendicularBisector and RandomInfraRegionNearest.

Exact Midpoint, PerpendicularBisector and RegionNearest are point families on finite simple undirected unweighted graphs.
Their complete pools contain distinct raw vertices in graph order. Exact midpoint can be empty; equidistance does not imply separation; nearest support retains all ties.
See [Synthetic geometry migration](paclet:WolframInstitute/InfraGeometry/tutorial/SyntheticGeometryMigration) for compatibility and the segment middle-layer distinction.

```wl
SeedRandom[ 71 ]; With[ { graph = CycleGraph[ 4 ] },
  InfraSubstrateHighlight[ graph, { InfraMidpoint[ 1, 3 ], 1, 3 } ] ]
```
