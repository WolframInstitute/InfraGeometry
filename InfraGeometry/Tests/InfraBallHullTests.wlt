BeginTestSection["InfraBallHull"]

(* InfraBallHull[S, r] is the intersection of the closed balls of radius at most r containing S, the whole graph when no such ball exists;
   InfraBallHull[S] takes every radius, the Mazur hull.  The brute-force intersections below enumerate the balls B_rho(c) themselves *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], s = { 1, 6, 22 } },
    Keys @ InfraMeasurement[ g, InfraBallHull[ s ], "VertexDensity" ] ===
      Sort @ Fold[ Intersection, VertexList @ g,
        Table[ With[ { r = Max[ GraphDistance[ g, c, # ] & /@ s ] },
            Select[ VertexList @ g, GraphDistance[ g, c, # ] <= r & ] ], { c, VertexList @ g } ] ] ],
  True,
  TestID -> "InfraBallHull-equals-intersection-of-enclosing-balls"
]

VerificationTest[
  With[ { g = PetersenGraph[ ], s = { 1, 7 } },
    Table[
      Keys @ InfraMeasurement[ g, InfraBallHull[ s, r ], "VertexDensity" ] ===
        Sort @ Fold[ Intersection, VertexList @ g,
          Select[
            Catenate @ Table[ Select[ VertexList @ g, GraphDistance[ g, c, # ] <= rho & ], { c, VertexList @ g }, { rho, 0, r } ],
            SubsetQ[ #, s ] & ] ],
      { r, 0, 3 } ] ],
  { True, True, True, True },
  TestID -> "InfraBallHull-radius-equals-intersection-of-small-balls"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] },
    InfraMeasurement[ g, InfraBallHull[ { 1, 6, 22 } ], "VertexDensity" ] ===
      InfraMeasurement[ g, InfraBallHull[ { 1, 6, 22 }, Infinity ], "VertexDensity" ] ],
  True,
  TestID -> "InfraBallHull-omitted-radius-is-infinity"
]

(* a closure: the hull contains S and is its own hull; a set is ball-convex iff it is its own hull *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], s = { 1, 6, 22 } },
    { h = Keys @ InfraMeasurement[ g, InfraBallHull[ s ], "VertexDensity" ] },
    { SubsetQ[ h, s ], Keys @ InfraMeasurement[ g, InfraBallHull[ h ], "VertexDensity" ] === h } ],
  { True, True },
  TestID -> "InfraBallHull-extensive-idempotent"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ] },
    { ball = Keys @ InfraMeasurement[ g, InfraBall[ 13, 2 ], "VertexDensity" ] },
    { Keys @ InfraMeasurement[ g, InfraBallHull[ { 13 } ], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraBallHull[ ball ], "VertexDensity" ] === ball } ],
  { { 13 }, True },
  TestID -> "InfraBallHull-point-and-ball-are-their-own-hull"
]

VerificationTest[
  Keys @ InfraMeasurement[ PathGraph @ Range[ 5 ], InfraBallHull[ { 1, 5 } ], "VertexDensity" ],
  { 1, 2, 3, 4, 5 },
  TestID -> "InfraBallHull-path-endpoints-fill"
]

(* the radius filtration: fewer balls at a smaller radius, so the hull shrinks as r grows; below the least radius of a ball
   containing S there is no ball, and the hull is the whole graph *)

VerificationTest[
  With[ { g = PathGraph @ Range[ 10 ] },
    Keys @ InfraMeasurement[ g, InfraBallHull[ { 3, 7 }, # ], "VertexDensity" ] & /@ { 0, 1, 2, 5, Infinity } ],
  { Range[ 10 ], Range[ 10 ], Range[ 3, 7 ], Range[ 3, 7 ], Range[ 3, 7 ] },
  TestID -> "InfraBallHull-path-radius-below-half-distance-is-everything"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], s = { 1, 6, 22 } },
    { hulls = Keys @ InfraMeasurement[ g, InfraBallHull[ s, # ], "VertexDensity" ] & /@ Range[ 0, 10 ] },
    And @@ ( SubsetQ @@@ Partition[ hulls, 2, 1 ] ) && Last @ hulls === Keys @ InfraMeasurement[ g, InfraBallHull[ s ], "VertexDensity" ] ],
  True,
  TestID -> "InfraBallHull-decreasing-in-the-radius"
]

(* geometry: on the square grid the ball hull of two points of a row at distance 4 is the diamond, the ball of radius 2 at
   their midpoint; on a rhombic patch of the triangular lattice the corners of the equilateral triangle of side 3 at its
   corner give the whole patch at radius 1, the solid triangle with one more row beyond its inner side at radius 2, and the
   solid triangle from radius 3 on *)

VerificationTest[
  With[ { g = Graph[ Flatten[ Table[ Select[ { { i, j } <-> { i + 1, j }, { i, j } <-> { i, j + 1 } },
      AllTrue[ Flatten[ List @@ # ], # <= 6 & ] & ], { i, 0, 6 }, { j, 0, 6 } ], 2 ] ] },
    { Keys @ InfraMeasurement[ g, InfraBallHull[ { { 3, 1 }, { 3, 5 } } ], "VertexDensity" ] ===
        Keys @ InfraMeasurement[ g, InfraBall[ { 3, 3 }, 2 ], "VertexDensity" ],
      Length @ InfraMeasurement[ g, InfraBallHull[ { { 3, 1 }, { 3, 5 } }, 1 ], "VertexDensity" ] } ],
  { True, 49 },
  TestID -> "InfraBallHull-square-grid-diamond"
]

VerificationTest[
  With[ { g = Graph[ Flatten[ Table[ Select[ { { i, j } <-> { i + 1, j }, { i, j } <-> { i, j + 1 }, { i + 1, j } <-> { i, j + 1 } },
      AllTrue[ Flatten[ List @@ # ], # <= 4 & ] & ], { i, 0, 4 }, { j, 0, 4 } ], 2 ] ], s = { { 0, 0 }, { 0, 3 }, { 3, 0 } } },
    { Keys @ InfraMeasurement[ g, InfraBallHull[ s, 1 ], "VertexDensity" ] === Sort @ VertexList @ g,
      Keys @ InfraMeasurement[ g, InfraBallHull[ s, 2 ], "VertexDensity" ] === Sort @ Select[ VertexList @ g, Max[ # ] <= 3 && Total[ # ] <= 4 & ],
      Keys @ InfraMeasurement[ g, InfraBallHull[ s, 3 ], "VertexDensity" ] === Sort @ Select[ VertexList @ g, Total[ # ] <= 3 & ],
      Keys @ InfraMeasurement[ g, InfraBallHull[ s ], "VertexDensity" ] === Sort @ Select[ VertexList @ g, Total[ # ] <= 3 & ] } ],
  { True, True, True, True },
  TestID -> "InfraBallHull-triangular-lattice-radius-filtration"
]

(* S is read as InfraTube reads its core: a vertex, a vertex list, a density, a subgraph, or a Euclidean head through its support *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] },
    { SameQ[
        InfraMeasurement[ g, InfraBallHull[ { 1, 6, 22 } ], "VertexDensity" ],
        InfraMeasurement[ g, InfraBallHull[ <| 1 -> 2, 6 -> 1, 22 -> 1 |> ], "VertexDensity" ],
        InfraMeasurement[ g, InfraBallHull[ Subgraph[ g, { 1, 6, 22 } ] ], "VertexDensity" ] ],
      InfraMeasurement[ g, InfraBallHull[ InfraSegment[ 1, 22 ] ], "VertexDensity" ] ===
        InfraMeasurement[ g, InfraBallHull[ Keys @ InfraMeasurement[ g, InfraSegment[ 1, 22 ], "VertexDensity" ] ], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraBallHull[ 7 ], "VertexDensity" ],
      InfraMeasurement[ g, InfraBallHull[ { } ], "VertexDensity" ] } ],
  { True, True, { 7 }, <| |> },
  TestID -> "InfraBallHull-seed-forms"
]

(* the readings of a region head: one member, faithful, the induced edges, the two measures *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], hull = InfraBallHull[ { 1, 6, 22 } ] },
    { support = Keys @ InfraMeasurement[ g, hull, "VertexDensity" ] },
    { InfraMeasurement[ g, hull, "Cardinality" ],
      InfraMeasurement[ g, hull, "Faithful" ],
      FindInfraRepresentative[ g, hull ] === support,
      FindInfraRepresentative[ g, hull, All ] === { support },
      Sort @ Keys @ InfraMeasurement[ g, hull, "EdgeDensity" ] === Sort @ EdgeList @ Subgraph[ g, support ],
      InfraMeasurement[ g, hull, "CountingMeasure" ] === Length @ support,
      Keys @ InfraMeasurement[ g, hull, All ] } ],
  { 1, True, True, True, True, True,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } },
  TestID -> "InfraBallHull-readings"
]

VerificationTest[
  GraphQ @ InfraSubstrateHighlight[ GridGraph[ { 6, 4 } ], { InfraBallHull[ { 1, 6, 22 }, 4 ], { 1, 6, 22 } } ],
  True,
  TestID -> "InfraBallHull-highlight"
]

EndTestSection[]
