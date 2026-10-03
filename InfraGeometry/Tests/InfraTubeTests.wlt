BeginTestSection["InfraTube"]

(* ===== InfraTube ===== *)

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    Table[ InfraMeasurement[g, InfraTube[13, s], "VertexDensity"] === InfraMeasurement[g, InfraBall[13, s], "VertexDensity"], { s, 0, 4 } ] ],
  ConstantArray[True, 5],
  TestID -> "InfraTube-of-a-vertex-is-the-ball"
]

VerificationTest[
  With[ { g = GridGraph[{7, 7}], core = {9, 10, 11} },
    Table[ FindInfraRepresentative[g, InfraTube[core, {s, s}]] === FindInfraRepresentative[g, InfraShell[core, s]], { s, 0, 4 } ] ],
  ConstantArray[True, 5],
  TestID -> "InfraTube-band-r-r-is-the-shell"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraTube[{1, 2, 3}, 1]], FindInfraRepresentative[g, InfraTube[{1, 2, 3}, {1, 2}]] } ],
  { {1, 2, 3, 4, 6, 7, 8}, {4, 5, 6, 7, 8, 9, 11, 12, 13} },
  TestID -> "InfraTube-of-a-vertex-list-and-its-band"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraTube[<| 1 -> 2, 25 -> 1 |>, 1]], FindInfraRepresentative[g, InfraTube[FindInfraSegment[g, 1, 3], 1]] } ],
  { {1, 2, 6, 20, 24, 25}, {1, 2, 3, 4, 6, 7, 8} },
  TestID -> "InfraTube-of-a-density-and-of-a-walk"
]

(* the tube of a segment head is the tube of the metric interval I(p, q) *)
VerificationTest[
  Table[
    With[ { g = InfraSubstrate[name, "Small"] },
      { p = InfraCenter[g] },
      { q = SelectFirst[ VertexList[g], v |-> GraphDistance[g, p, v] == 3 && Length @ FindInfraSegment[g, p, v, All] > 1 ] },
      { near = Min /@ Transpose[ GraphDistance[g, #] & /@ MetricInterval[g, p, q] ] },
      Table[ InfraMeasurement[g, InfraTube[InfraSegment[p, q], s], "CountingMeasure"], { s, 0, 3 } ] ===
        Table[ Count[ near, d_ /; d <= s ], { s, 0, 3 } ] ],
    { name, { "SquareTilingGraph", "TriangularTilingGraph" } } ],
  { True, True },
  TestID -> "InfraTube-of-a-segment-counts-the-neighbourhood-of-the-interval"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraTube[{}, 2]], FindInfraRepresentative[g, InfraTube[{1, 2}, {3, 2}]],
      FindInfraRepresentative[g, InfraTube[1, {9, 10}]], FindInfraRepresentative[g, InfraTube[1, Infinity]] } ],
  { {}, {}, {}, Range[25] },
  TestID -> "InfraTube-empty-core-reversed-band-past-eccentricity"
]

VerificationTest[
  Keys @ InfraMeasurement[GridGraph[{5, 5}], InfraTube[{12, 13, 14}, 1], All],
  { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" },
  TestID -> "InfraTube-All-seven-properties"
]

VerificationTest[
  With[ { g = PathGraph[Range[7]] },
    { InfraMeasurement[g, InfraTube[{3, 4}, 1], { "VertexDensity", "EdgeDensity", "Cardinality", "Faithful", "CountingMeasure", "RiemannianMeasure" }],
      InfraMeasurement[g, InfraTube[{3, 4}, 1], "Length"] } ],
  { <| "VertexDensity" -> <| 2 -> 1, 3 -> 1, 4 -> 1, 5 -> 1 |>,
       "EdgeDensity" -> <| UndirectedEdge[2, 3] -> 1, UndirectedEdge[3, 4] -> 1, UndirectedEdge[4, 5] -> 1 |>,
       "Cardinality" -> 1, "Faithful" -> True, "CountingMeasure" -> 4, "RiemannianMeasure" -> 2 |>,
    InfraMeasurement[PathGraph[Range[7]], InfraTube[{3, 4}, 1], "Length"] },
  TestID -> "InfraTube-small-clauses-and-no-Length"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraTube[13, 1], All], FindInfraRepresentative[g, InfraTube[13, 1], 2],
      FindInfraRepresentative[g, InfraTube[13, 1], "RandomChoice"] } ],
  { {{8, 12, 13, 14, 18}}, {}, {8, 12, 13, 14, 18} },
  TestID -> "InfraTube-one-member-under-every-count"
]

(* ===== InfraCylinder ===== *)

VerificationTest[
  With[ { g = PathGraph[Range[9]], axis = {3, 4, 5, 6, 7} },
    { FindInfraRepresentative[g, InfraCylinder[axis, 0]], FindInfraRepresentative[g, InfraCylinder[axis, 1]],
      FindInfraRepresentative[g, InfraCylinder[axis, {1, 2}]] } ],
  { {3, 4, 5, 6, 7}, {2, 3, 4, 5, 6, 7, 8}, {1, 2, 8, 9} },
  TestID -> "InfraCylinder-PathGraph-axis-tube-band"
]

VerificationTest[
  With[ { g = GridGraph[{6, 6}], axis = {1, 2, 3, 4, 5, 6} },
    Table[ InfraMeasurement[g, InfraCylinder[axis, r], All] === InfraMeasurement[g, InfraTube[axis, r], All] &&
      FindInfraRepresentative[g, InfraCylinder[axis, r]] === FindInfraRevolution[g, axis, r, Method -> "Balls"], { r, 0, 3 } ] ],
  ConstantArray[True, 4],
  TestID -> "InfraCylinder-is-the-tube-and-the-Balls-revolution"
]

(* ===== InfraCone ===== *)

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { FindInfraRepresentative[g, InfraCone[{1, 2, 3, 4, 5}, 0]], FindInfraRepresentative[g, InfraCone[{21, 17, 13, 9, 5}, 0]] } ],
  { {1, 2, 3, 4, 5}, {5, 9, 13, 17, 21} },
  TestID -> "InfraCone-slope-0-is-the-axis"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}], axis = {1, 2, 3, 4, 5} },
    { FindInfraRepresentative[g, InfraCone[axis, 1]] === FindInfraRevolution[g, axis, Range[0, 4], Method -> "Balls"],
      FindInfraRepresentative[g, InfraCone[Reverse @ axis, 1]] === FindInfraRevolution[g, axis, Range[4, 0, -1], Method -> "Balls"] } ],
  { True, True },
  TestID -> "InfraCone-slope-1-is-the-linear-profile-either-apex"
]

(* d(v, a_i) <= slope (i - 1): radii 0, 0, 1, 1, 2 at slope 1/2 *)
VerificationTest[
  With[ { g = PathGraph[Range[9]] },
    { FindInfraRepresentative[g, InfraCone[{1, 2, 3, 4, 5}, 1/2]], FindInfraRepresentative[g, InfraCone[{5, 6, 7, 8, 9}, 1/2]] } ],
  { {1, 2, 3, 4, 5, 6, 7}, {5, 6, 7, 8, 9} },
  TestID -> "InfraCone-half-slope-on-a-path"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { Keys @ InfraMeasurement[g, InfraCone[{1, 2, 3}, 1], All], InfraMeasurement[g, InfraCone[{}, 1], "CountingMeasure"] } ],
  { { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" }, 0 },
  TestID -> "InfraCone-All-seven-properties-and-the-empty-axis"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    Head @ InfraSubstrateHighlight[g, { InfraTube[InfraSegment[1, 13], 1], InfraCylinder[{1, 2, 3}, 1], InfraCone[{21, 22, 23, 24, 25}, 1] }] ],
  Graph,
  TestID -> "InfraTube-InfraCylinder-InfraCone-draw"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    InfraMeasurement[g, { InfraTube[13, 1], InfraCylinder[{1, 2}, 1], InfraCone[{1, 2, 3}, 1] }, #] & /@
      { "CountingMeasure", "RiemannianMeasure" } ],
  { { 5, 5, 9 }, { 1, 2, 4 } },
  TestID -> "InfraTube-InfraCylinder-InfraCone-measures-in-one-call"
]

VerificationTest[
  With[ { g = GridGraph[{4, 4}] },
    Map[ inst |-> inst[[ 1 ]][ t ],
      FindInfraScene[ InfraScene[ { t }, { t == # } ], g ] & /@ { InfraTube[{1, 2}, 1], InfraCylinder[{1, 2}, 1], InfraCone[{1, 2}, 1] }, { 2 } ] ],
  { { {1, 2, 3, 5, 6} }, { {1, 2, 3, 5, 6} }, { {1, 2, 3, 6} } },
  TestID -> "InfraTube-InfraCylinder-InfraCone-are-scene-constructors"
]

EndTestSection[]
