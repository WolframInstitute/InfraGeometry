---
Template: TechNote
Name: SyntheticGeometryMigration
Title: Synthetic Geometry Migration
Context: WolframInstitute`InfraGeometry`
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/tutorial/SyntheticGeometryMigration
Keywords: [migration, compatibility, synthetic geometry, sampling]
RelatedGuides: [EuclideanInfrageometry, RiemannianInfrageometry]
---

The public generic representative sampler RandomInfraRepresentative is removed, with no compatibility alias.
Choose the named sampler for the construction. The complete list and carrier differences are in [Named construction samplers](paclet:WolframInstitute/InfraGeometry/tutorial/NamedConstructionSamplers).

| Earlier construction | Current construction | Compatibility |
|---|---|---|
| InfraRay[p,q] | InfraHalfLine[p,q] | Old inert head and named sampler/predicate remain accepted for at least this release. |
| InfraLine[p,q] or InfraLine[germ] | InfraInfiniteLine[p,q] or InfraInfiniteLine[germ] | Finite maximal shortest-path meaning and germ overload remain. |
| InfraPolygon[anchors,n] | InfraRegularPolygon[anchors,n] | Existing regular family remains; no corner-polygon overload is added. |

Do not rewrite inside vertex labels.
A bare sampler and its token overload can have different carriers and traversal laws.
In particular, bare regular polygons give directed Graph legs; tokens give ordered vertex sequences.
Bare geodesics give position-spelled Graphs; tokens give ordered sequences.
Bare half-line and infinite-line traversal laws remain distinct from their token DAG-family sampling.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 5 ] ] },
  RandomInfraHalfLine[ graph, InfraHalfLine[ 2, 3 ], All ] ]
```

Counts enumerate representatives, not support vertices.
A singleton region has one representative even when its set is empty.
A decided empty point family has no representatives.
An unsupported call remains unevaluated and must not be interpreted as an empty family.

The exact midpoint family requires equal half-distances and is empty at odd endpoint distance.
The older segment "Midpoint" measurement retains middle-layer density and can contain two layers.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 2 ] ] },
  { RandomInfraMidpoint[ graph, 1, 2, All ],
    InfraMeasurement[ graph, InfraSegment[ 1, 2 ], "Midpoint" ] } ]
```

The exact perpendicular-bisector head is the finite equidistant locus.
It need not be a separating plane or a line.
Nearest-point families retain every finite-distance tie.
Their supported measures inherit existing counting and interior-support laws; no Area or Volume property is added.

```wl
SeedRandom[ 71 ]; With[ { graph = PathGraph[ Range[ 3 ] ] },
  InfraSubstrateHighlight[ graph, { InfraRegionNearest[ { 1, 3 }, 2 ], 2 } ] ]
```

The assertion registry contains Distinct, Member and EqualDistance only.
Finite exploration retains merged states and all incoming events, with explicit incomplete frontiers.
Older scene descriptors lacking ScheduleValidity must be rebuilt from their original syntax before exploration.
A saved viewer reads the saved record without sampling; a literal binding filter changes the view, not the saved fixed inputs.

The 39 official guide entries are a scope inventory, not a fully implemented catalog.
Triangle centers and constructions, angle choices, centroids, corner boundaries and fillings, circles through points, signed distance, conjectures and the scene entity library remain deferred.
Existing graph distance, length, boundary and measure operations retain their own declared meanings.
