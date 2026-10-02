BeginTestSection["InfraBall"]

(* ===== InfraBall: the representative of a ball is its sorted vertex list ===== *)

VerificationTest[
  FindInfraRepresentative[PathGraph[Range[5]], InfraBall[3, 1]],
  {2, 3, 4},
  TestID -> "InfraBall-PathGraph-interior-r1"
]

VerificationTest[
  FindInfraRepresentative[PathGraph[Range[5]], InfraBall[1, 2]],
  {1, 2, 3},
  TestID -> "InfraBall-PathGraph-endpoint-r2"
]

VerificationTest[
  FindInfraRepresentative[CycleGraph[6], InfraBall[1, 1]],
  {1, 2, 6},
  TestID -> "InfraBall-CycleGraph6-r1"
]

VerificationTest[
  FindInfraRepresentative[CompleteGraph[4], InfraBall[1, 1]],
  {1, 2, 3, 4},
  TestID -> "InfraBall-CompleteGraph4-r1"
]

VerificationTest[
  FindInfraRepresentative[StarGraph[5], InfraBall[1, 1]],
  {1, 2, 3, 4, 5},
  TestID -> "InfraBall-StarGraph5-hub"
]

VerificationTest[
  FindInfraRepresentative[StarGraph[5], InfraBall[2, 1]],
  {1, 2},
  TestID -> "InfraBall-StarGraph5-leaf"
]

VerificationTest[
  FindInfraRepresentative[PathGraph[Range[5]], InfraBall[3, 0]],
  {3},
  TestID -> "InfraBall-r0-singleton"
]

(* an anchor of several vertices weights one carrier: the ball of a set is its closed r-neighbourhood, the union of the balls around its members *)
VerificationTest[
  FindInfraRepresentative[PathGraph[Range[5]], InfraBall[<| 1 -> 1, 5 -> 1 |>, 1]],
  {1, 2, 4, 5},
  TestID -> "InfraBall-multi-anchor"
]

VerificationTest[
  FindInfraRepresentative[PathGraph[Range[5]], InfraBall[{1, 5}, 1]],
  {1, 2, 4, 5},
  TestID -> "InfraBall-multi-anchor-vertex-list"
]

(* the ball of a walk is the tube around it *)
VerificationTest[
  FindInfraRepresentative[GridGraph[{3, 3}], InfraBall[FindInfraSegment[GridGraph[{3, 3}], 1, 3], 1]],
  {1, 2, 3, 4, 5, 6},
  TestID -> "InfraBall-walk-anchor-is-the-tube"
]

(* a ball is a legal HighlightGraph argument *)
VerificationTest[
  Head @ HighlightGraph[PathGraph[Range[5]], FindInfraRepresentative[PathGraph[Range[5]], InfraBall[3, 1]]],
  Graph,
  TestID -> "InfraBall-is-a-HighlightGraph-argument"
]

(* ===== InfraBall: the measured region ===== *)

VerificationTest[
  InfraMeasurement[GridGraph[{5, 5}], InfraBall[13, 1], All],
  <| "Faithful" -> True, "Cardinality" -> 1, "VertexDensity" -> <| 8 -> 1, 12 -> 1, 13 -> 1, 14 -> 1, 18 -> 1 |>,
     "EdgeDensity" -> <| UndirectedEdge[8, 13] -> 1, UndirectedEdge[12, 13] -> 1, UndirectedEdge[13, 14] -> 1, UndirectedEdge[13, 18] -> 1 |>,
     "Subgraph" -> Subgraph[GridGraph[{5, 5}], {8, 12, 13, 14, 18}],
     "Volume" -> 5, "BoundaryVolume" -> 4, "InteriorVolume" -> 1, "HalfBoundaryVolume" -> 3 |>,
  TestID -> "InfraBall-All-nine-properties"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { InfraMeasurement[g, InfraBall[13, 1], "Length"], InfraMeasurement[g, InfraBall[13, 1], "Graph"] } ],
  { InfraMeasurement[GridGraph[{5, 5}], InfraBall[13, 1], "Length"], InfraMeasurement[GridGraph[{5, 5}], InfraBall[13, 1], "Graph"] },
  TestID -> "InfraBall-no-Length-no-Graph-stays-unevaluated"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraBall[13, 1], All], FindInfraRepresentative[g, InfraBall[13, 1], UpTo[3]],
      FindInfraRepresentative[g, InfraBall[13, 1], 2], FindInfraRepresentative[g, InfraBall[13, 1], "RandomChoice"] } ],
  { {{8, 12, 13, 14, 18}}, {{8, 12, 13, 14, 18}}, {}, {8, 12, 13, 14, 18} },
  TestID -> "InfraBall-one-member-under-every-count"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraBall[13, Infinity]], FindInfraRepresentative[g, InfraBall[13, 3/2]] } ],
  { Range[25], {8, 12, 13, 14, 18} },
  TestID -> "InfraBall-radius-infinite-and-fractional"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    FindInfraRepresentative[g, InfraBall[13, {1, 2}]] === FindInfraRepresentative[g, InfraShell[13, {1, 2}]] ],
  True,
  TestID -> "InfraBall-band-is-the-shell"
]

(* |B_r| = 2r^2 + 2r + 1 on the square grid away from the rim *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}] },
    InfraMeasurement[g, InfraBall[61, #], "Volume"] & /@ Range[0, 5] ],
  2 Range[0, 5]^2 + 2 Range[0, 5] + 1,
  TestID -> "InfraBall-square-grid-volume-2r2+2r+1"
]

(* the half-boundary count V - B/2 of the lattice diamond is its area 2r^2 plus one (Pick: A = I + B/2 - 1) *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}] },
    InfraMeasurement[g, InfraBall[61, #], "HalfBoundaryVolume"] & /@ Range[1, 5] ],
  2 Range[1, 5]^2 + 1,
  TestID -> "InfraBall-square-grid-half-boundary-Ehrhart"
]

VerificationTest[
  Table[
    With[ { g = InfraSubstrate[name, "Small"] },
      { c = InfraCenter[g] },
      { profile = BallVolumes[g, c] },
      InfraMeasurement[g, InfraBall[c, #], "Volume"] & /@ Range[0, Length[profile] - 1] === profile ],
    { name, { "SquareTilingGraph", "TriangularTilingGraph" } } ],
  { True, True },
  TestID -> "InfraBall-volume-profile-is-BallVolumes"
]

VerificationTest[
  Head @ InfraSubstrateHighlight[GridGraph[{5, 5}], { InfraBall[13, 1] }],
  Graph,
  TestID -> "InfraBall-draws"
]

(* ===== InfraBallQ ===== *)

VerificationTest[
  InfraBallQ[PathGraph[Range[5]], {2, 3, 4}],
  True,
  TestID -> "InfraBallQ-PathGraph-r1-ball-true"
]

VerificationTest[
  InfraBallQ[PathGraph[Range[5]], {1, 2}],
  True,
  TestID -> "InfraBallQ-PathGraph-endpoint-r1-true"
]

VerificationTest[
  InfraBallQ[PathGraph[Range[5]], {1, 5}],
  False,
  TestID -> "InfraBallQ-PathGraph-endpoints-only-false"
]

VerificationTest[
  InfraBallQ[CompleteGraph[4], {1, 2, 3, 4}],
  True,
  TestID -> "InfraBallQ-CompleteGraph4-full-true"
]

VerificationTest[
  InfraBallQ[CompleteGraph[4], {1, 2}],
  False,
  TestID -> "InfraBallQ-CompleteGraph4-half-false"
]

VerificationTest[
  InfraBallQ[StarGraph[5], {1, 2, 3, 4, 5}],
  True,
  TestID -> "InfraBallQ-StarGraph5-full-true"
]

VerificationTest[
  InfraBallQ[StarGraph[5], {1, 2}],
  True,
  TestID -> "InfraBallQ-StarGraph5-leaf-with-hub-true"
]

VerificationTest[
  InfraBallQ[PathGraph[Range[5]], {}],
  False,
  TestID -> "InfraBallQ-empty-false"
]

(* a family of sets passes iff every member does *)
VerificationTest[
  { InfraBallQ[PathGraph[Range[5]], {{2, 3, 4}, {1, 2}}], InfraBallQ[PathGraph[Range[5]], {{2, 3, 4}, {1, 5}}] },
  { True, False },
  TestID -> "InfraBallQ-family-is-the-conjunction"
]

(* ===== InfraDistance between balls ===== *)

VerificationTest[
  InfraDistance[PathGraph[Range[7]], FindInfraRepresentative[PathGraph[Range[7]], InfraBall[2, 1]], FindInfraRepresentative[PathGraph[Range[7]], InfraBall[7, 1]]],
  3,
  TestID -> "InfraDistance-ball-ball"
]

EndTestSection[]
