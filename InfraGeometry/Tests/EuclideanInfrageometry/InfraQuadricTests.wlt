BeginTestSection["InfraQuadric"]

(* PathGraph 1-2-3-4-5; foci {1, 3}: d(1,v)+d(3,v) = {2, 2, 2, 4, 6} *)

(* ===== Scalar c: the solid { v : sum d <= c } ===== *)

VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 3 }, # ], "VertexDensity" ] & /@ { 2, 3, 4, 6 },
  { { 1, 2, 3 }, { 1, 2, 3 }, { 1, 2, 3, 4 }, { 1, 2, 3, 4, 5 } },
  TestID -> "InfraQuadric-PathGraph-ellipse-solids"
]

(* ===== Band c = {lo, hi}; {c, c} is the elliptic shell ===== *)

VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 3 }, # ], "VertexDensity" ] & /@ { { 4, 6 }, { 2, 2 }, { 4, 4 }, { 6, 6 } },
  { { 4, 5 }, { 1, 2, 3 }, { 4 }, { 5 } },
  TestID -> "InfraQuadric-PathGraph-bands-and-elliptic-shells"
]

(* on the path the band {d(p, q), d(p, q)} is the interval I(p, q) *)
VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 9 ] ], InfraQuadric[ { 3, 7 }, { 4, 4 } ], "VertexDensity" ],
  Range[ 3, 7 ],
  TestID -> "InfraQuadric-PathGraph-interval-band"
]

(* GridGraph[{4,4}], foci 2 and 15: the sum is 4 on the 2-column inner strip *)
VerificationTest[
  Keys @ InfraMeasurement[ GridGraph[ { 4, 4 } ], InfraQuadric[ { 2, 15 }, { 4, 4 } ], "VertexDensity" ],
  { 2, 3, 6, 7, 10, 11, 14, 15 },
  TestID -> "InfraQuadric-Grid4x4-elliptic-shell-inner-strip"
]

(* GridGraph[{4,4}], foci at opposite corners: the sum is 6 everywhere *)
VerificationTest[
  Length @ InfraMeasurement[ GridGraph[ { 4, 4 } ], InfraQuadric[ { 1, 16 }, 6 ], "VertexDensity" ],
  16,
  TestID -> "InfraQuadric-Grid4x4-corner-corner-solid"
]

(* ===== Weights ===== *)

VerificationTest[
  InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 3 }, 2, { 1, 1 } ], "VertexDensity" ] ===
    InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 3 }, 2 ], "VertexDensity" ],
  True,
  TestID -> "InfraQuadric-explicit-unit-weights"
]

(* d(1,v) - d(5,v) on PathGraph 1..5 = { -4, -2, 0, 2, 4 } *)
VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 5 }, #, { 1, -1 } ], "VertexDensity" ] & /@ { 0, { -1, 1 }, { -2, 2 } },
  { { 1, 2, 3 }, { 3 }, { 2, 3, 4 } },
  TestID -> "InfraQuadric-PathGraph-signed-sum"
]

(* the 7 x 7 grid, foci (2, 4) and (6, 4): d(p, v) - d(q, v) = |x - 2| - |x - 6|, so the band {2, 2} is the hyperbola branch x = 5, a column,
   and the solid <= 2 the half-plane x <= 5 *)
VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { Keys @ InfraMeasurement[ g, InfraQuadric[ { 11, 39 }, { 2, 2 }, { 1, -1 } ], "VertexDensity" ],
      Length @ InfraMeasurement[ g, InfraQuadric[ { 11, 39 }, 2, { 1, -1 } ], "VertexDensity" ] } ],
  { Range[ 29, 35 ], 35 },
  TestID -> "InfraQuadric-Grid7x7-hyperbola-branch"
]

(* a weight list of the wrong length is a non-match *)
VerificationTest[
  MatchQ[ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 3 }, 2, { 1 } ], "VertexDensity" ], _InfraMeasurement ],
  True,
  TestID -> "InfraQuadric-wrong-weight-length-unevaluated"
]

(* ===== Three foci =====
   PathGraph 1..5, foci {1, 3, 5}: the sums are { 6, 5, 4, 5, 6 } *)

VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { 1, 3, 5 }, # ], "VertexDensity" ] & /@ { 4, 5 },
  { { 3 }, { 2, 3, 4 } },
  TestID -> "InfraQuadric-PathGraph-three-foci"
]

(* ===== One focus is the ball, its band the shell ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ] },
    { InfraMeasurement[ g, InfraQuadric[ { 25 }, 2 ], "VertexDensity" ] === InfraMeasurement[ g, InfraBall[ 25, 2 ], "VertexDensity" ],
      InfraMeasurement[ g, InfraQuadric[ { 25 }, { 2, 2 } ], "VertexDensity" ] === InfraMeasurement[ g, InfraShell[ 25, 2 ], "VertexDensity" ] } ],
  { True, True },
  TestID -> "InfraQuadric-one-focus-ball-and-shell"
]

(* ===== Foci read like the ball's centre ===== *)

(* a density focus is the distance to its vertices: d(v, {1, 4}) + d(v, 3) = { 2, 2, 1, 1, 3 } *)
VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 5 ] ], InfraQuadric[ { <| 1 -> 1, 4 -> 1 |>, 3 }, 2 ], "VertexDensity" ],
  { 1, 2, 3, 4 },
  TestID -> "InfraQuadric-density-focus"
]

(* on a list-labelled substrate a focus is a vertex, not a set *)
VerificationTest[
  With[ { g = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ 3 ], 2 ] ] ] },
    Keys @ InfraMeasurement[ g, InfraQuadric[ { { 1, 1 }, { 1, 3 } }, { 2, 2 } ], "VertexDensity" ] ],
  { { 1, 1 }, { 1, 2 }, { 1, 3 } },
  TestID -> "InfraQuadric-list-labelled-substrate"
]

(* ===== Readings ===== *)

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], q = InfraQuadric[ { 2, 15 }, { 4, 4 } ] },
    { InfraMeasurement[ g, q, "Cardinality" ], InfraMeasurement[ g, q, "Faithful" ], InfraMeasurement[ g, q, "CountingMeasure" ],
      Sort @ Keys @ InfraMeasurement[ g, q, "EdgeDensity" ] === Sort @ EdgeList @ Subgraph[ g, { 2, 3, 6, 7, 10, 11, 14, 15 } ],
      Keys @ InfraMeasurement[ g, q, All ] } ],
  { 1, True, 8, True,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } },
  TestID -> "InfraQuadric-readings"
]

VerificationTest[
  With[ { g = PathGraph[ Range[ 5 ] ], q = InfraQuadric[ { 1, 3 }, 2 ] },
    { Replace[ q, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ], Replace[ q, { token_InfraPoint :> RandomInfraPoint[ g, token, All ], token_InfraSegment :> RandomInfraSegment[ g, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraCircle :> RandomInfraCircle[ g, token, All ], token_InfraArc :> RandomInfraArc[ g, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token, All ], token_InfraPlane :> RandomInfraPlane[ g, token, All ], token_InfraBall :> RandomInfraBall[ g, token, All ], token_InfraShell :> RandomInfraShell[ g, token, All ], token_InfraSphere :> RandomInfraSphere[ g, token, All ], token_InfraTube :> RandomInfraTube[ g, token, All ], token_InfraCylinder :> RandomInfraCylinder[ g, token, All ], token_InfraCone :> RandomInfraCone[ g, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token, All ], token_InfraBallHull :> RandomInfraBallHull[ g, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token, All ], token_InfraQuadric :> RandomInfraQuadric[ g, token, All ], token_InfraWalk :> RandomInfraWalk[ g, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token, All ], token_InfraEllipse :> RandomInfraEllipse[ g, token, All ], token_InfraIntersection :> RandomInfraIntersection[ g, token, All ], token_InfraUnion :> RandomInfraUnion[ g, token, All ], token_InfraRay :> RandomInfraHalfLine[ g, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ g, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token, All ] } ],
      InfraMemberQ[ g, q, { 3, 2, 1 } ], InfraMemberQ[ g, q, { 1, 2 } ] } ],
  { { 1, 2, 3 }, { { 1, 2, 3 } }, True, False },
  TestID -> "InfraQuadric-representative-and-member"
]

(* a List with a quadric is read head by head *)
VerificationTest[
  Keys /@ InfraMeasurement[ PathGraph[ Range[ 5 ] ], { InfraQuadric[ { 1, 3 }, 2 ], InfraBall[ 1, 1 ] }, "VertexDensity" ],
  { { 1, 2, 3 }, { 1, 2 } },
  TestID -> "InfraQuadric-in-a-List"
]

(* ===== Scene ===== *)

VerificationTest[
  RandomInfraInstance[ InfraScene[ { e }, { e == InfraQuadric[ { 2, 15 }, { 4, 4 } ] } ], GridGraph[ { 4, 4 } ], All ][[ 1, 1 ]],
  <| e -> { 2, 3, 6, 7, 10, 11, 14, 15 } |>,
  TestID -> "InfraQuadric-scene-constructor"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[ GridGraph[ { 4, 4 } ], { InfraQuadric[ { 2, 15 }, { 4, 4 } ] } ],
  Graph,
  TestID -> "InfraQuadric-highlight-draws"
]

EndTestSection[]
