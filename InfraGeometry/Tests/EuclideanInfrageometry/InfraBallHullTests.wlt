BeginTestSection["InfraBallHull"]

(* InfraBallHull[S, r] is the intersection of the closed balls of radius at most r containing S, the whole graph when no such ball exists;
   InfraBallHull[S, {r}] takes the balls of radius exactly r, InfraBallHull[S, {r, s}] those between r and s, and InfraBallHull[S] every radius,
   the Mazur hull.  The brute-force intersections below enumerate the balls B_rho(c) themselves *)

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

(* the radius grammar of InfraBall: r the balls of radius at most r, {r} exactly r, {r, s} between r and s *)

VerificationTest[
  With[ { g = PetersenGraph[ ], s = { 1, 7 } },
    { hull = band |-> Sort @ Fold[ Intersection, VertexList @ g,
        Select[
          Catenate @ Table[ Select[ VertexList @ g, GraphDistance[ g, c, # ] <= rho & ], { c, VertexList @ g }, { rho, First @ band, Last @ band } ],
          SubsetQ[ #, s ] & ] ] },
    { Table[ Keys @ InfraMeasurement[ g, InfraBallHull[ s, { r } ], "VertexDensity" ] === hull @ { r, r }, { r, 0, 3 } ],
      Table[ Keys @ InfraMeasurement[ g, InfraBallHull[ s, { r, t } ], "VertexDensity" ] === hull @ { r, t }, { r, 0, 3 }, { t, r, 3 } ] } ],
  { { True, True, True, True }, { { True, True, True, True }, { True, True, True }, { True, True }, { True } } },
  TestID -> "InfraBallHull-exact-and-band-equal-intersection-of-balls"
]

VerificationTest[
  With[ { g = GridGraph[ { 6, 4 } ], s = { 1, 6, 22 } },
    And @@ Table[
      SameQ[ InfraMeasurement[ g, InfraBallHull[ s, r ], "VertexDensity" ], InfraMeasurement[ g, InfraBallHull[ s, { 0, r } ], "VertexDensity" ] ] &&
        SameQ[ InfraMeasurement[ g, InfraBallHull[ s, { r } ], "VertexDensity" ],
          InfraMeasurement[ g, InfraBallHull[ s, { r, r } ], "VertexDensity" ] ],
      { r, 0, 9 } ] ],
  True,
  TestID -> "InfraBallHull-radius-forms-are-bands"
]

(* where the readings differ: on the 7x7 grid the two points 2 and 6 of the bottom row at distance 4 have the half-diamond, the ball of radius 2
   about their midpoint, as their hull at every radius bound from 2 on; the balls of radius exactly r give it up to r = 5, then grow, and at the
   diameter 12 every ball is the whole grid.  On the cycle C8 every ball of radius 4 is the whole cycle, while B_0, or the three balls B_1 about
   the point and its neighbours, cut the hull of a point to it *)

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { halfDiamond = Keys @ InfraMeasurement[ g, InfraBall[ 4, 2 ], "VertexDensity" ] },
    { Keys @ InfraMeasurement[ g, InfraBallHull[ { 2, 6 }, 5 ], "VertexDensity" ] === halfDiamond,
      Keys @ InfraMeasurement[ g, InfraBallHull[ { 2, 6 }, { 5 } ], "VertexDensity" ] === halfDiamond,
      Length @ InfraMeasurement[ g, InfraBallHull[ { 2, 6 }, # ], "VertexDensity" ] & /@ Range[ 0, 12 ],
      Length @ InfraMeasurement[ g, InfraBallHull[ { 2, 6 }, { # } ], "VertexDensity" ] & /@ Range[ 0, 12 ] } ],
  { True, True, { 49, 49, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9 }, { 49, 49, 9, 9, 9, 9, 14, 21, 28, 35, 41, 45, 49 } },
  TestID -> "InfraBallHull-square-grid-exact-radius-grows"
]

VerificationTest[
  With[ { g = CycleGraph[ 8 ] },
    Keys @ InfraMeasurement[ g, InfraBallHull[ { 1 }, # ], "VertexDensity" ] & /@ { 4, { 4 }, { 0, 4 }, { 1, 4 }, { 4, 6 } } ],
  { { 1 }, Range[ 8 ], { 1 }, { 1 }, Range[ 8 ] },
  TestID -> "InfraBallHull-cycle-exact-radius-is-everything"
]

(* a ball of radius past the diameter of its component is the component, not the graph *)

VerificationTest[
  Keys @ InfraMeasurement[ Graph[ { 1 <-> 2, 2 <-> 3, 4 <-> 5 } ], InfraBallHull[ { 1 }, # ], "VertexDensity" ] & /@ { { 1 }, { 5 }, { 2, 9 } },
  { { 1, 2 }, { 1, 2, 3 }, { 1, 2, 3 } },
  TestID -> "InfraBallHull-exact-radius-stays-in-the-component"
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
      Replace[ hull, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ] === support,
      Replace[ hull, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ] === { support },
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
