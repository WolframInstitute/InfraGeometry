BeginTestSection["InfraConvexHull"]

(* InfraConvexHull[S, k] is the k-th round of the interval closure: round 0 is S, round i + 1 adds MetricInterval[g, u, v] for every
   pair u, v of round i; InfraConvexHull[S] is the fixed point, the geodesic convex hull *)

VerificationTest[
  With[ { g = PetersenGraph[ ], s = { 1, 2, 8 } },
    Table[
      Keys @ InfraMeasurement[ g, InfraConvexHull[ s, k ], "VertexDensity" ] ===
        Sort @ Nest[ t |-> Union[ t, Catenate[ MetricInterval[ g, ##1 ] & @@@ Subsets[ t, { 2 } ] ] ], s, k ],
      { k, 0, 4 } ] ],
  { True, True, True, True, True },
  TestID -> "InfraConvexHull-rounds-equal-iterated-intervals"
]

VerificationTest[
  Length @ InfraMeasurement[ PetersenGraph[ ], InfraConvexHull[ { 1, 2, 8 }, # ], "VertexDensity" ] & /@ { 0, 1, 2, 3, 4, Infinity },
  { 3, 6, 9, 10, 10, 10 },
  TestID -> "InfraConvexHull-Petersen-three-strict-rounds"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] },
    InfraMeasurement[ g, InfraConvexHull[ { 1, 22 } ], "VertexDensity" ] ===
      InfraMeasurement[ g, InfraConvexHull[ { 1, 22 }, Infinity ], "VertexDensity" ] ],
  True,
  TestID -> "InfraConvexHull-omitted-round-is-infinity"
]

(* geometry: on a rhombic patch of the triangular lattice the first round of the corners of the equilateral triangle of side 3
   is its three sides, the second the solid triangle, which is the hull *)

VerificationTest[
  With[ { g = Graph[ Flatten[ Table[ Select[ { { i, j } <-> { i + 1, j }, { i, j } <-> { i, j + 1 }, { i + 1, j } <-> { i, j + 1 } },
      AllTrue[ Flatten[ List @@ # ], # <= 4 & ] & ], { i, 0, 4 }, { j, 0, 4 } ], 2 ] ], s = { { 0, 0 }, { 0, 3 }, { 3, 0 } } },
    { Keys @ InfraMeasurement[ g, InfraConvexHull[ s, 0 ], "VertexDensity" ] === Sort @ s,
      Keys @ InfraMeasurement[ g, InfraConvexHull[ s, 1 ], "VertexDensity" ] ===
        Sort @ Select[ VertexList @ g, Total[ # ] == 3 || Min[ # ] == 0 && Total[ # ] <= 3 & ],
      Keys @ InfraMeasurement[ g, InfraConvexHull[ s, 2 ], "VertexDensity" ] === Sort @ Select[ VertexList @ g, Total[ # ] <= 3 & ],
      Keys @ InfraMeasurement[ g, InfraConvexHull[ s ], "VertexDensity" ] === Sort @ Select[ VertexList @ g, Total[ # ] <= 3 & ] } ],
  { True, True, True, True },
  TestID -> "InfraConvexHull-triangular-lattice-sides-then-triangle"
]

(* the hulls of the former FindSegmentHull fixtures *)

VerificationTest[
  Keys @ InfraMeasurement[ #1, InfraConvexHull[ #2 ], "VertexDensity" ] & @@@ {
    { PathGraph @ Range[ 5 ], { 1, 5 } },
    { PathGraph @ Range[ 5 ], { 2, 4 } },
    { PathGraph @ Range[ 5 ], { 3 } },
    { PathGraph @ Range[ 5 ], { } },
    { CycleGraph[ 4 ], { 1, 3 } },
    { GridGraph[ { 3, 3 } ], { 1, 9 } },
    { GridGraph[ { 3, 3 } ], { 1, 3 } },
    { CompleteGraph[ 5 ], { 1, 2 } } },
  { { 1, 2, 3, 4, 5 }, { 2, 3, 4 }, { 3 }, { }, { 1, 2, 3, 4 }, Range[ 9 ], { 1, 2, 3 }, { 1, 2 } },
  TestID -> "InfraConvexHull-fixtures"
]

(* a set is geodesically convex iff it is its own hull: a path interval, a whole cycle, a grid row and any set of a complete graph
   are; two path endpoints, two antipodes of C4 and an arc of C6 with two geodesics between its ends are not *)

VerificationTest[
  ( Keys @ InfraMeasurement[ #1, InfraConvexHull[ #2 ], "VertexDensity" ] === #2 ) & @@@ {
    { PathGraph @ Range[ 5 ], { 2, 3, 4 } },
    { CycleGraph[ 4 ], { 1, 2, 3, 4 } },
    { GridGraph[ { 3, 3 } ], { 1, 2, 3 } },
    { CompleteGraph[ 5 ], { 1, 3, 5 } },
    { PathGraph @ Range[ 5 ], { 1, 5 } },
    { CycleGraph[ 4 ], { 1, 3 } },
    { CycleGraph[ 6 ], { 1, 2, 3, 4 } } },
  { True, True, True, True, False, False, False },
  TestID -> "InfraConvexHull-convex-iff-own-hull"
]

VerificationTest[
  With[ { g = Graph[ { 1, 2, 3, 4 }, { 1 <-> 2, 3 <-> 4 } ] },
    Keys @ InfraMeasurement[ g, InfraConvexHull[ # ], "VertexDensity" ] & /@ { { 1, 3 }, { 1, 2, 3 } } ],
  { { 1, 3 }, { 1, 2, 3 } },
  TestID -> "InfraConvexHull-no-interval-across-components"
]

(* S is read as InfraTube reads its core *)

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ] },
    { SameQ[
        InfraMeasurement[ g, InfraConvexHull[ { 1, 23 } ], "VertexDensity" ],
        InfraMeasurement[ g, InfraConvexHull[ <| 1 -> 1, 23 -> 3 |> ], "VertexDensity" ],
        InfraMeasurement[ g, InfraConvexHull[ Subgraph[ g, { 1, 23 } ] ], "VertexDensity" ],
        InfraMeasurement[ g, InfraConvexHull[ InfraSegment[ 1, 23 ] ], "VertexDensity" ] ],
      Keys @ InfraMeasurement[ g, InfraConvexHull[ 7 ], "VertexDensity" ] } ],
  { True, { 7 } },
  TestID -> "InfraConvexHull-seed-forms"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], hull = InfraConvexHull[ { 2, 9, 17 }, 1 ] },
    { support = Keys @ InfraMeasurement[ g, hull, "VertexDensity" ] },
    { InfraMeasurement[ g, hull, "Cardinality" ],
      InfraMeasurement[ g, hull, "Faithful" ],
      FindInfraRepresentative[ g, hull ] === support,
      Sort @ Keys @ InfraMeasurement[ g, hull, "EdgeDensity" ] === Sort @ EdgeList @ Subgraph[ g, support ],
      InfraMeasurement[ g, hull, "CountingMeasure" ] === Length @ support,
      Keys @ InfraMeasurement[ g, hull, All ],
      GraphQ @ InfraSubstrateHighlight[ g, { hull, { 2, 9, 17 } } ] } ],
  { 1, True, True, True, True,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" }, True },
  TestID -> "InfraConvexHull-readings"
]

EndTestSection[]
