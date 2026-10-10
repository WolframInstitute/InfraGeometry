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
    Table[ RandomInfraTube[ g, InfraTube[core, {s, s}] ] === RandomInfraShell[ g, InfraShell[core, s] ], { s, 0, 4 } ] ],
  ConstantArray[True, 5],
  TestID -> "InfraTube-band-r-r-is-the-shell"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { RandomInfraTube[ g, InfraTube[{1, 2, 3}, 1] ], RandomInfraTube[ g, InfraTube[{1, 2, 3}, {1, 2}] ] } ],
  { {1, 2, 3, 4, 6, 7, 8}, {4, 5, 6, 7, 8, 9, 11, 12, 13} },
  TestID -> "InfraTube-of-a-vertex-list-and-its-band"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { RandomInfraTube[ g, InfraTube[<| 1 -> 2, 25 -> 1 |>, 1] ], RandomInfraTube[ g, InfraTube[RandomInfraSegment[g, 1, 3], 1] ] } ],
  { {1, 2, 6, 20, 24, 25}, {1, 2, 3, 4, 6, 7, 8} },
  TestID -> "InfraTube-of-a-density-and-of-a-walk"
]

(* the tube of a segment head is the tube of the metric interval I(p, q) *)
VerificationTest[
  Table[
    With[ { g = InfraSubstrate[name, "Small"] },
      { p = First @ GraphCenter[g] },
      { q = SelectFirst[ VertexList[g], v |-> GraphDistance[g, p, v] == 3 && Length @ RandomInfraSegment[g, p, v, All] > 1 ] },
      { near = Min /@ Transpose[ GraphDistance[g, #] & /@ MetricInterval[g, p, q] ] },
      Table[ InfraMeasurement[g, InfraTube[InfraSegment[p, q], s], "CountingMeasure"], { s, 0, 3 } ] ===
        Table[ Count[ near, d_ /; d <= s ], { s, 0, 3 } ] ],
    { name, { "SquareTilingGraph", "TriangularTilingGraph" } } ],
  { True, True },
  TestID -> "InfraTube-of-a-segment-counts-the-neighbourhood-of-the-interval"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { RandomInfraTube[ g, InfraTube[{}, 2] ], RandomInfraTube[ g, InfraTube[{1, 2}, {3, 2}] ],
      RandomInfraTube[ g, InfraTube[1, {9, 10}] ], RandomInfraTube[ g, InfraTube[1, Infinity] ] } ],
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
    { RandomInfraTube[ g, InfraTube[13, 1], All ], RandomInfraTube[ g, InfraTube[13, 1], 2 ],
      RandomInfraTube[ g, InfraTube[13, 1], "NextVertexFunction" -> RandomChoice ] } ],
  { {{8, 12, 13, 14, 18}}, {}, {8, 12, 13, 14, 18} },
  TestID -> "InfraTube-one-member-under-every-count"
]

VerificationTest[
  With[ { g = GridGraph[{9, 9}] },
    Table[ RandomInfraTube[ g, InfraTube[c, p] ] === RandomInfraTube[ g, InfraTube[c, p, Method -> "Balls"] ],
      { c, { 41, {1, 2, 3}, <| 1 -> 2, 81 -> 1 |>, InfraSegment[1, 41], RandomInfraSegment[g, 1, 41], {} } },
      { p, { 0, 1, 3, {1, 2}, {2, 2}, {3, 1}, Infinity } } ] ],
  ConstantArray[True, { 6, 7 }],
  TestID -> "InfraTube-Balls-is-the-default-method"
]

(* a profile along the core is the union of the balls B(a_i, r_i); a list and a function of the position say the same *)
VerificationTest[
  With[ { g = GridGraph[{7, 7}], axis = {9, 10, 11, 12, 13} },
    { RandomInfraTube[ g, InfraTube[axis, {0, 1, 2, 1, 0}] ] ===
        Union @@ MapThread[ RandomInfraBall[ g, InfraBall[#1, #2] ] &, { axis, {0, 1, 2, 1, 0} } ],
      RandomInfraTube[ g, InfraTube[axis, Range[0, 4]] ] === RandomInfraTube[ g, InfraTube[axis, # - 1 &] ],
      RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, Range[0, 4]] ] === RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, # - 1 &] ] } ],
  { True, True, True },
  TestID -> "InfraTube-profile-is-the-union-of-balls"
]

(* a band profile {r_i, r_i} is the level set min_i ( d(a_i, v) - r_i ) == 0 *)
VerificationTest[
  With[ { g = GridGraph[{7, 7}], axis = {9, 10, 11, 12, 13}, radii = {0, 1, 2, 1, 0} },
    RandomInfraTube[ g, InfraTube[axis, { #, # } & /@ radii] ] ===
      Select[ VertexList @ g, v |-> Min[ MapThread[ GraphDistance[g, #1, v] - #2 &, { axis, radii } ] ] == 0 ] ],
  True,
  TestID -> "InfraTube-band-profile-is-the-level-set"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    Head /@ { InfraMeasurement[g, InfraTube[<| 1 -> 1 |>, 1, Method -> "Sliced"], "VertexDensity"],
      InfraMeasurement[g, InfraTube[InfraSegment[1, 5], 1, Method -> "Sliced"], "VertexDensity"],
      InfraMeasurement[g, InfraTube[{1, 2}, 1, Method -> "Rounded"], "VertexDensity"] } ],
  { InfraMeasurement, InfraMeasurement, InfraMeasurement },
  TestID -> "InfraTube-Sliced-needs-a-walk-and-an-unknown-method-stays-unevaluated"
]

(* ===== InfraCylinder ===== *)

(* Along a row of the square grid the sliced cylinder is the rectangle of half-width r over the axis, with flat ends; the balls method adds
   the rounded ends.  The axis is prolonged straight on, so the end slices are full rows *)
VerificationTest[
  With[ { g = GridGraph[{9, 9}], at = { x, y } |-> 9 ( x - 1 ) + y },
    { axis = at[5, #] & /@ Range[3, 7] },
    { RandomInfraCylinder[ g, InfraCylinder[axis, 2] ], RandomInfraCylinder[ g, InfraCylinder[axis, 2, Method -> "Balls"] ] } ===
      { Sort @ Flatten @ Table[ at[x, y], { x, 3, 7 }, { y, 3, 7 } ],
        Select[ VertexList @ g, v |-> Min[ GraphDistance[g, #, v] & /@ axis ] <= 2 ] } ],
  True,
  TestID -> "InfraCylinder-grid-row-flat-and-rounded-ends"
]

(* on a path graph the perpendicular slab of an axis vertex is the vertex itself *)
VerificationTest[
  With[ { g = PathGraph[Range[9]], axis = {3, 4, 5, 6, 7} },
    { RandomInfraCylinder[ g, InfraCylinder[axis, 0] ], RandomInfraCylinder[ g, InfraCylinder[axis, 1] ],
      RandomInfraCylinder[ g, InfraCylinder[axis, {1, 2}] ], RandomInfraCylinder[ g, InfraCylinder[axis, 1, Method -> "Balls"] ] } ],
  { {3, 4, 5, 6, 7}, {3, 4, 5, 6, 7}, {}, {2, 3, 4, 5, 6, 7, 8} },
  TestID -> "InfraCylinder-PathGraph-is-the-axis"
]

(* a closed axis has no ends, so the slicing cuts nothing and a constant radius gives the tube *)
VerificationTest[
  With[ { g = GridGraph[{9, 9}], at = { x, y } |-> 9 ( x - 1 ) + y },
    { loop = at @@@ Join[ Table[ {3, y}, { y, 3, 6 } ], Table[ {x, 7}, { x, 3, 6 } ], Table[ {7, y}, { y, 7, 4, -1 } ],
        Table[ {x, 3}, { x, 7, 3, -1 } ] ] },
    Table[ RandomInfraCylinder[ g, InfraCylinder[loop, r] ] === RandomInfraTube[ g, InfraTube[loop, r] ], { r, 0, 3 } ] ],
  ConstantArray[True, 4],
  TestID -> "InfraCylinder-closed-axis-has-no-ends"
]

VerificationTest[
  With[ { g = GridGraph[{6, 6}], axis = {1, 2, 3, 4, 5, 6} },
    Table[
      { InfraMeasurement[g, InfraCylinder[axis, r, Method -> "Balls"], All] === InfraMeasurement[g, InfraTube[axis, r], All],
        RandomInfraCylinder[ g, InfraCylinder[{15}, r] ] === RandomInfraBall[ g, InfraBall[15, r] ],
        RandomInfraCylinder[ g, InfraCylinder[axis, {1, r}] ] ===
          Complement[ RandomInfraCylinder[ g, InfraCylinder[axis, r] ], RandomInfraCylinder[ g, InfraCylinder[axis, 0] ] ] },
      { r, 1, 3 } ] ],
  ConstantArray[True, { 3, 3 }],
  TestID -> "InfraCylinder-balls-method-one-vertex-axis-and-band"
]

(* ===== InfraCone ===== *)

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { RandomInfraCone[ g, InfraCone[{1, 2, 3, 4, 5}, 0] ], RandomInfraCone[ g, InfraCone[{21, 17, 13, 9, 5}, 0] ] } ],
  { {1, 2, 3, 4, 5}, {5, 9, 13, 17, 21} },
  TestID -> "InfraCone-slope-0-is-the-axis"
]

(* the row of axis vertex i holds 2 (i - 1) + 1 vertices, the base row included *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}] },
    KeySort @ Counts[ Mod[ RandomInfraCone[ g, InfraCone[11 * 5 + Range[2, 7], 1] ] - 1, 11 ] + 1 ] ],
  <| 2 -> 1, 3 -> 3, 4 -> 5, 5 -> 7, 6 -> 9, 7 -> 11 |>,
  TestID -> "InfraCone-slices-grow-by-the-slope"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}], axis = {6, 7, 8, 9, 10} },
    { RandomInfraCone[ g, InfraCone[axis, 1] ] === RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, Range[0, 4]] ],
      RandomInfraCone[ g, InfraCone[Reverse @ axis, 1] ] === RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, Range[4, 0, -1]] ],
      RandomInfraCone[ g, InfraCone[axis, 1, Method -> "Balls"] ] === RandomInfraTube[ g, InfraTube[axis, Range[0, 4]] ] } ],
  { True, True, True },
  TestID -> "InfraCone-is-the-linear-profile-either-apex"
]

(* d(v, a_i) <= slope (i - 1): radii 0, 0, 1, 1, 2 at slope 1/2; sliced on a path, the axis *)
VerificationTest[
  With[ { g = PathGraph[Range[9]] },
    { RandomInfraCone[ g, InfraCone[{1, 2, 3, 4, 5}, 1/2] ], RandomInfraCone[ g, InfraCone[{1, 2, 3, 4, 5}, 1/2, Method -> "Balls"] ],
      RandomInfraCone[ g, InfraCone[{5, 6, 7, 8, 9}, 1/2, Method -> "Balls"] ] } ],
  { {1, 2, 3, 4, 5}, {1, 2, 3, 4, 5, 6, 7}, {5, 6, 7, 8, 9} },
  TestID -> "InfraCone-half-slope-on-a-path"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { Keys @ InfraMeasurement[g, InfraCone[{1, 2, 3}, 1], All], InfraMeasurement[g, InfraCone[{}, 1], "CountingMeasure"] } ],
  { { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" }, 0 },
  TestID -> "InfraCone-All-seven-properties-and-the-empty-axis"
]

(* ===== InfraSolidOfRevolution ===== *)

VerificationTest[
  With[ { g = GridGraph[{7, 7}], axis = {9, 10, 11, 12, 13} },
    Table[ RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, r] ] === RandomInfraCylinder[ g, InfraCylinder[axis, r] ],
      { r, { 0, 1, 2, {1, 2}, {2, 2} } } ] ],
  ConstantArray[True, 5],
  TestID -> "InfraSolidOfRevolution-constant-profile-is-the-cylinder"
]

(* the profile is read at the foot of the perpendicular, so a jump is a sharp step; the balls spread it to the neighbouring rows *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}], axis = 11 * 5 + Range[2, 8], profile = {1, 1, 1, 3, 1, 1, 1} },
    KeySort @ Counts[ Mod[ Replace[ #, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ] - 1, 11 ] + 1 ] & /@
      { InfraSolidOfRevolution[axis, profile], InfraSolidOfRevolution[axis, profile, Method -> "Balls"] } ],
  { <| 2 -> 3, 3 -> 3, 4 -> 3, 5 -> 7, 6 -> 3, 7 -> 3, 8 -> 3 |>, <| 1 -> 1, 2 -> 3, 3 -> 3, 4 -> 5, 5 -> 7, 6 -> 5, 7 -> 3, 8 -> 3, 9 -> 1 |> },
  TestID -> "InfraSolidOfRevolution-profile-read-at-the-foot"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}], axis = {1, 2, 3, 4, 5}, profile = {0, 1, 2, 1, 0} },
    { solid = RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, profile] ] },
    { SubsetQ[ solid, RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, { #, # } & /@ profile] ] ],
      solid === Union @@ Table[
        RandomInfraSolidOfRevolution[ g, InfraSolidOfRevolution[axis, { #, # } & /@ ( Min[ #, k ] & /@ profile )] ], { k, 0, 2 } ] } ],
  { True, True },
  TestID -> "InfraSolidOfRevolution-solid-is-the-union-of-its-surfaces"
]

VerificationTest[
  { RandomInfraSolidOfRevolution[ PetersenGraph[], InfraSolidOfRevolution[{1}, {2, 2}] ] === RandomInfraShell[ PetersenGraph[], InfraShell[1, 2] ],
    RandomInfraSolidOfRevolution[ PathGraph[Range[5]], InfraSolidOfRevolution[{3}, 100] ],
    RandomInfraSolidOfRevolution[ PathGraph[Range[5]], InfraSolidOfRevolution[{3}, {100, 100}] ] },
  { True, {1, 2, 3, 4, 5}, {} },
  TestID -> "InfraSolidOfRevolution-one-vertex-axis-and-past-the-diameter"
]

(* ===== the solids together ===== *)

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    Table[ { InfraMemberQ[g, s, Replace[ s, { token_InfraPoint :> RandomInfraPoint[ g, token ], token_InfraSegment :> RandomInfraSegment[ g, token ], token_InfraHalfLine :> RandomInfraHalfLine[ g, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ g, token ], token_InfraCircle :> RandomInfraCircle[ g, token ], token_InfraArc :> RandomInfraArc[ g, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ g, token ], token_InfraPlane :> RandomInfraPlane[ g, token ], token_InfraBall :> RandomInfraBall[ g, token ], token_InfraShell :> RandomInfraShell[ g, token ], token_InfraSphere :> RandomInfraSphere[ g, token ], token_InfraTube :> RandomInfraTube[ g, token ], token_InfraCylinder :> RandomInfraCylinder[ g, token ], token_InfraCone :> RandomInfraCone[ g, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ g, token ], token_InfraBallHull :> RandomInfraBallHull[ g, token ], token_InfraConvexHull :> RandomInfraConvexHull[ g, token ], token_InfraQuadric :> RandomInfraQuadric[ g, token ], token_InfraWalk :> RandomInfraWalk[ g, token ], token_InfraGeodesic :> RandomInfraGeodesic[ g, token ], token_InfraEllipse :> RandomInfraEllipse[ g, token ], token_InfraIntersection :> RandomInfraIntersection[ g, token ], token_InfraUnion :> RandomInfraUnion[ g, token ], token_InfraRay :> RandomInfraHalfLine[ g, token ], token_InfraLine :> RandomInfraInfiniteLine[ g, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ g, token ] } ]], InfraMemberQ[g, s, {1, 2}] },
      { s, { InfraTube[{1, 2}, 1], InfraCylinder[{6, 7, 8}, 1], InfraCone[{6, 7, 8}, 1], InfraSolidOfRevolution[{6, 7, 8}, {1, 2, 1}] } } ] ],
  ConstantArray[{ True, False }, 4],
  TestID -> "InfraMemberQ-on-the-solids"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    Head @ InfraSubstrateHighlight[g, { InfraTube[InfraSegment[1, 13], 1], InfraCylinder[{1, 2, 3}, 1], InfraCone[{21, 22, 23, 24, 25}, 1],
      InfraSolidOfRevolution[{11, 12, 13}, {1, 2, 1}] }] ],
  Graph,
  TestID -> "InfraTube-InfraCylinder-InfraCone-InfraSolidOfRevolution-draw"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    InfraMeasurement[g, { InfraTube[13, 1], InfraCylinder[{1, 2}, 1], InfraCone[{1, 2, 3}, 1] }, #] & /@
      { "CountingMeasure", "RiemannianMeasure" } ],
  { { 5, 4, 6 }, { 1, 1, 1 } },
  TestID -> "InfraTube-InfraCylinder-InfraCone-measures-in-one-call"
]

VerificationTest[
  With[ { g = GridGraph[{4, 4}] },
    Map[ inst |-> inst[[ 1 ]][ t ],
      RandomInfraInstance[ InfraScene[ { t }, { t == # } ], g, All ] & /@
        { InfraTube[{1, 2}, 1], InfraCylinder[{1, 2}, 1], InfraCone[{1, 2}, 1], InfraSolidOfRevolution[{5, 6, 7, 8}, {0, 1, 1, 0}] }, { 2 } ] ],
  { { {1, 2, 3, 5, 6} }, { {1, 2, 5, 6} }, { {1, 2, 6} }, { {2, 3, 5, 6, 7, 8, 10, 11} } },
  TestID -> "InfraTube-InfraCylinder-InfraCone-InfraSolidOfRevolution-are-scene-constructors"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ],
      objects = { InfraBall[ 3, 1 ], InfraShell[ 3, 1 ], InfraTube[ { 2, 3, 4 }, 0 ],
        InfraCylinder[ { 2, 3, 4 }, 0 ], InfraCone[ { 2, 3, 4 }, 0 ], InfraSolidOfRevolution[ { 2, 3, 4 }, 0 ] } },
    AllTrue[ objects, object |-> With[ { support = Keys @ InfraMeasurement[ graph, object, "VertexDensity" ] },
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token ], token_InfraSegment :> RandomInfraSegment[ graph, token ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token ], token_InfraCircle :> RandomInfraCircle[ graph, token ], token_InfraArc :> RandomInfraArc[ graph, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token ], token_InfraPlane :> RandomInfraPlane[ graph, token ], token_InfraBall :> RandomInfraBall[ graph, token ], token_InfraShell :> RandomInfraShell[ graph, token ], token_InfraSphere :> RandomInfraSphere[ graph, token ], token_InfraTube :> RandomInfraTube[ graph, token ], token_InfraCylinder :> RandomInfraCylinder[ graph, token ], token_InfraCone :> RandomInfraCone[ graph, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token ], token_InfraBallHull :> RandomInfraBallHull[ graph, token ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token ], token_InfraQuadric :> RandomInfraQuadric[ graph, token ], token_InfraWalk :> RandomInfraWalk[ graph, token ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token ], token_InfraEllipse :> RandomInfraEllipse[ graph, token ], token_InfraIntersection :> RandomInfraIntersection[ graph, token ], token_InfraUnion :> RandomInfraUnion[ graph, token ], token_InfraRay :> RandomInfraHalfLine[ graph, token ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token ] } ] === support &&
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, "NextVertexFunction" -> Identity ], token_InfraSegment :> RandomInfraSegment[ graph, token, "NextVertexFunction" -> Identity ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, "NextVertexFunction" -> Identity ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, "NextVertexFunction" -> Identity ], token_InfraCircle :> RandomInfraCircle[ graph, token, "NextVertexFunction" -> Identity ], token_InfraArc :> RandomInfraArc[ graph, token, "NextVertexFunction" -> Identity ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, "NextVertexFunction" -> Identity ], token_InfraPlane :> RandomInfraPlane[ graph, token, "NextVertexFunction" -> Identity ], token_InfraBall :> RandomInfraBall[ graph, token, "NextVertexFunction" -> Identity ], token_InfraShell :> RandomInfraShell[ graph, token, "NextVertexFunction" -> Identity ], token_InfraSphere :> RandomInfraSphere[ graph, token, "NextVertexFunction" -> Identity ], token_InfraTube :> RandomInfraTube[ graph, token, "NextVertexFunction" -> Identity ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, "NextVertexFunction" -> Identity ], token_InfraCone :> RandomInfraCone[ graph, token, "NextVertexFunction" -> Identity ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, "NextVertexFunction" -> Identity ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, "NextVertexFunction" -> Identity ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, "NextVertexFunction" -> Identity ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, "NextVertexFunction" -> Identity ], token_InfraWalk :> RandomInfraWalk[ graph, token, "NextVertexFunction" -> Identity ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, "NextVertexFunction" -> Identity ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, "NextVertexFunction" -> Identity ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, "NextVertexFunction" -> Identity ], token_InfraUnion :> RandomInfraUnion[ graph, token, "NextVertexFunction" -> Identity ], token_InfraRay :> RandomInfraHalfLine[ graph, token, "NextVertexFunction" -> Identity ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, "NextVertexFunction" -> Identity ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, "NextVertexFunction" -> Identity ] } ] === support &&
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, All ], token_InfraSegment :> RandomInfraSegment[ graph, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, All ], token_InfraCircle :> RandomInfraCircle[ graph, token, All ], token_InfraArc :> RandomInfraArc[ graph, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, All ], token_InfraPlane :> RandomInfraPlane[ graph, token, All ], token_InfraBall :> RandomInfraBall[ graph, token, All ], token_InfraShell :> RandomInfraShell[ graph, token, All ], token_InfraSphere :> RandomInfraSphere[ graph, token, All ], token_InfraTube :> RandomInfraTube[ graph, token, All ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, All ], token_InfraCone :> RandomInfraCone[ graph, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, All ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, All ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, All ], token_InfraWalk :> RandomInfraWalk[ graph, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, All ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, All ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, All ], token_InfraUnion :> RandomInfraUnion[ graph, token, All ], token_InfraRay :> RandomInfraHalfLine[ graph, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, All ] } ] === { support } &&
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, 1 ], token_InfraSegment :> RandomInfraSegment[ graph, token, 1 ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, 1 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, 1 ], token_InfraCircle :> RandomInfraCircle[ graph, token, 1 ], token_InfraArc :> RandomInfraArc[ graph, token, 1 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, 1 ], token_InfraPlane :> RandomInfraPlane[ graph, token, 1 ], token_InfraBall :> RandomInfraBall[ graph, token, 1 ], token_InfraShell :> RandomInfraShell[ graph, token, 1 ], token_InfraSphere :> RandomInfraSphere[ graph, token, 1 ], token_InfraTube :> RandomInfraTube[ graph, token, 1 ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, 1 ], token_InfraCone :> RandomInfraCone[ graph, token, 1 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, 1 ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, 1 ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, 1 ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, 1 ], token_InfraWalk :> RandomInfraWalk[ graph, token, 1 ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, 1 ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, 1 ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, 1 ], token_InfraUnion :> RandomInfraUnion[ graph, token, 1 ], token_InfraRay :> RandomInfraHalfLine[ graph, token, 1 ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, 1 ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, 1 ] } ] === { support } &&
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, 2 ], token_InfraSegment :> RandomInfraSegment[ graph, token, 2 ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, 2 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, 2 ], token_InfraCircle :> RandomInfraCircle[ graph, token, 2 ], token_InfraArc :> RandomInfraArc[ graph, token, 2 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, 2 ], token_InfraPlane :> RandomInfraPlane[ graph, token, 2 ], token_InfraBall :> RandomInfraBall[ graph, token, 2 ], token_InfraShell :> RandomInfraShell[ graph, token, 2 ], token_InfraSphere :> RandomInfraSphere[ graph, token, 2 ], token_InfraTube :> RandomInfraTube[ graph, token, 2 ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, 2 ], token_InfraCone :> RandomInfraCone[ graph, token, 2 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, 2 ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, 2 ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, 2 ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, 2 ], token_InfraWalk :> RandomInfraWalk[ graph, token, 2 ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, 2 ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, 2 ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, 2 ], token_InfraUnion :> RandomInfraUnion[ graph, token, 2 ], token_InfraRay :> RandomInfraHalfLine[ graph, token, 2 ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, 2 ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, 2 ] } ] === { } &&
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, UpTo[ 2 ] ], token_InfraSegment :> RandomInfraSegment[ graph, token, UpTo[ 2 ] ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, UpTo[ 2 ] ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, UpTo[ 2 ] ], token_InfraCircle :> RandomInfraCircle[ graph, token, UpTo[ 2 ] ], token_InfraArc :> RandomInfraArc[ graph, token, UpTo[ 2 ] ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, UpTo[ 2 ] ], token_InfraPlane :> RandomInfraPlane[ graph, token, UpTo[ 2 ] ], token_InfraBall :> RandomInfraBall[ graph, token, UpTo[ 2 ] ], token_InfraShell :> RandomInfraShell[ graph, token, UpTo[ 2 ] ], token_InfraSphere :> RandomInfraSphere[ graph, token, UpTo[ 2 ] ], token_InfraTube :> RandomInfraTube[ graph, token, UpTo[ 2 ] ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, UpTo[ 2 ] ], token_InfraCone :> RandomInfraCone[ graph, token, UpTo[ 2 ] ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, UpTo[ 2 ] ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, UpTo[ 2 ] ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, UpTo[ 2 ] ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, UpTo[ 2 ] ], token_InfraWalk :> RandomInfraWalk[ graph, token, UpTo[ 2 ] ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, UpTo[ 2 ] ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, UpTo[ 2 ] ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, UpTo[ 2 ] ], token_InfraUnion :> RandomInfraUnion[ graph, token, UpTo[ 2 ] ], token_InfraRay :> RandomInfraHalfLine[ graph, token, UpTo[ 2 ] ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, UpTo[ 2 ] ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, UpTo[ 2 ] ] } ] === { support } &&
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, 0 ], token_InfraSegment :> RandomInfraSegment[ graph, token, 0 ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, 0 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, 0 ], token_InfraCircle :> RandomInfraCircle[ graph, token, 0 ], token_InfraArc :> RandomInfraArc[ graph, token, 0 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, 0 ], token_InfraPlane :> RandomInfraPlane[ graph, token, 0 ], token_InfraBall :> RandomInfraBall[ graph, token, 0 ], token_InfraShell :> RandomInfraShell[ graph, token, 0 ], token_InfraSphere :> RandomInfraSphere[ graph, token, 0 ], token_InfraTube :> RandomInfraTube[ graph, token, 0 ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, 0 ], token_InfraCone :> RandomInfraCone[ graph, token, 0 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, 0 ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, 0 ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, 0 ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, 0 ], token_InfraWalk :> RandomInfraWalk[ graph, token, 0 ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, 0 ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, 0 ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, 0 ], token_InfraUnion :> RandomInfraUnion[ graph, token, 0 ], token_InfraRay :> RandomInfraHalfLine[ graph, token, 0 ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, 0 ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, 0 ] } ] === { } ] ] ],
  True,
  TestID -> "set-heads-count-representatives-rather-than-support-vertices"
]

VerificationTest[
  With[ { graph = PathGraph[ { { 1, 0 }, { 2, 0 }, { 3, 0 } } ] },
    With[ { object = InfraTube[ { 2, 0 }, 1 ] },
      { Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token ], token_InfraSegment :> RandomInfraSegment[ graph, token ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token ], token_InfraCircle :> RandomInfraCircle[ graph, token ], token_InfraArc :> RandomInfraArc[ graph, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token ], token_InfraPlane :> RandomInfraPlane[ graph, token ], token_InfraBall :> RandomInfraBall[ graph, token ], token_InfraShell :> RandomInfraShell[ graph, token ], token_InfraSphere :> RandomInfraSphere[ graph, token ], token_InfraTube :> RandomInfraTube[ graph, token ], token_InfraCylinder :> RandomInfraCylinder[ graph, token ], token_InfraCone :> RandomInfraCone[ graph, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token ], token_InfraBallHull :> RandomInfraBallHull[ graph, token ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token ], token_InfraQuadric :> RandomInfraQuadric[ graph, token ], token_InfraWalk :> RandomInfraWalk[ graph, token ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token ], token_InfraEllipse :> RandomInfraEllipse[ graph, token ], token_InfraIntersection :> RandomInfraIntersection[ graph, token ], token_InfraUnion :> RandomInfraUnion[ graph, token ], token_InfraRay :> RandomInfraHalfLine[ graph, token ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token ] } ], Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, 1 ], token_InfraSegment :> RandomInfraSegment[ graph, token, 1 ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, 1 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, 1 ], token_InfraCircle :> RandomInfraCircle[ graph, token, 1 ], token_InfraArc :> RandomInfraArc[ graph, token, 1 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, 1 ], token_InfraPlane :> RandomInfraPlane[ graph, token, 1 ], token_InfraBall :> RandomInfraBall[ graph, token, 1 ], token_InfraShell :> RandomInfraShell[ graph, token, 1 ], token_InfraSphere :> RandomInfraSphere[ graph, token, 1 ], token_InfraTube :> RandomInfraTube[ graph, token, 1 ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, 1 ], token_InfraCone :> RandomInfraCone[ graph, token, 1 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, 1 ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, 1 ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, 1 ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, 1 ], token_InfraWalk :> RandomInfraWalk[ graph, token, 1 ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, 1 ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, 1 ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, 1 ], token_InfraUnion :> RandomInfraUnion[ graph, token, 1 ], token_InfraRay :> RandomInfraHalfLine[ graph, token, 1 ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, 1 ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, 1 ] } ] } ] ],
  { { { 1, 0 }, { 2, 0 }, { 3, 0 } }, { { { 1, 0 }, { 2, 0 }, { 3, 0 } } } },
  TestID -> "tube-support-preserves-list-valued-vertex-labels"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 3 ] ], object = InfraTube[ 2, { 10, 10 } ] },
    { Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token ], token_InfraSegment :> RandomInfraSegment[ graph, token ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token ], token_InfraCircle :> RandomInfraCircle[ graph, token ], token_InfraArc :> RandomInfraArc[ graph, token ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token ], token_InfraPlane :> RandomInfraPlane[ graph, token ], token_InfraBall :> RandomInfraBall[ graph, token ], token_InfraShell :> RandomInfraShell[ graph, token ], token_InfraSphere :> RandomInfraSphere[ graph, token ], token_InfraTube :> RandomInfraTube[ graph, token ], token_InfraCylinder :> RandomInfraCylinder[ graph, token ], token_InfraCone :> RandomInfraCone[ graph, token ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token ], token_InfraBallHull :> RandomInfraBallHull[ graph, token ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token ], token_InfraQuadric :> RandomInfraQuadric[ graph, token ], token_InfraWalk :> RandomInfraWalk[ graph, token ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token ], token_InfraEllipse :> RandomInfraEllipse[ graph, token ], token_InfraIntersection :> RandomInfraIntersection[ graph, token ], token_InfraUnion :> RandomInfraUnion[ graph, token ], token_InfraRay :> RandomInfraHalfLine[ graph, token ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token ] } ], Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, All ], token_InfraSegment :> RandomInfraSegment[ graph, token, All ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, All ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, All ], token_InfraCircle :> RandomInfraCircle[ graph, token, All ], token_InfraArc :> RandomInfraArc[ graph, token, All ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, All ], token_InfraPlane :> RandomInfraPlane[ graph, token, All ], token_InfraBall :> RandomInfraBall[ graph, token, All ], token_InfraShell :> RandomInfraShell[ graph, token, All ], token_InfraSphere :> RandomInfraSphere[ graph, token, All ], token_InfraTube :> RandomInfraTube[ graph, token, All ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, All ], token_InfraCone :> RandomInfraCone[ graph, token, All ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, All ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, All ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, All ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, All ], token_InfraWalk :> RandomInfraWalk[ graph, token, All ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, All ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, All ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, All ], token_InfraUnion :> RandomInfraUnion[ graph, token, All ], token_InfraRay :> RandomInfraHalfLine[ graph, token, All ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, All ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, All ] } ],
      Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, 1 ], token_InfraSegment :> RandomInfraSegment[ graph, token, 1 ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, 1 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, 1 ], token_InfraCircle :> RandomInfraCircle[ graph, token, 1 ], token_InfraArc :> RandomInfraArc[ graph, token, 1 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, 1 ], token_InfraPlane :> RandomInfraPlane[ graph, token, 1 ], token_InfraBall :> RandomInfraBall[ graph, token, 1 ], token_InfraShell :> RandomInfraShell[ graph, token, 1 ], token_InfraSphere :> RandomInfraSphere[ graph, token, 1 ], token_InfraTube :> RandomInfraTube[ graph, token, 1 ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, 1 ], token_InfraCone :> RandomInfraCone[ graph, token, 1 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, 1 ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, 1 ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, 1 ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, 1 ], token_InfraWalk :> RandomInfraWalk[ graph, token, 1 ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, 1 ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, 1 ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, 1 ], token_InfraUnion :> RandomInfraUnion[ graph, token, 1 ], token_InfraRay :> RandomInfraHalfLine[ graph, token, 1 ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, 1 ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, 1 ] } ], Replace[ object, { token_InfraPoint :> RandomInfraPoint[ graph, token, 2 ], token_InfraSegment :> RandomInfraSegment[ graph, token, 2 ], token_InfraHalfLine :> RandomInfraHalfLine[ graph, token, 2 ], token_InfraInfiniteLine :> RandomInfraInfiniteLine[ graph, token, 2 ], token_InfraCircle :> RandomInfraCircle[ graph, token, 2 ], token_InfraArc :> RandomInfraArc[ graph, token, 2 ], token_InfraRegularPolygon :> RandomInfraRegularPolygon[ graph, token, 2 ], token_InfraPlane :> RandomInfraPlane[ graph, token, 2 ], token_InfraBall :> RandomInfraBall[ graph, token, 2 ], token_InfraShell :> RandomInfraShell[ graph, token, 2 ], token_InfraSphere :> RandomInfraSphere[ graph, token, 2 ], token_InfraTube :> RandomInfraTube[ graph, token, 2 ], token_InfraCylinder :> RandomInfraCylinder[ graph, token, 2 ], token_InfraCone :> RandomInfraCone[ graph, token, 2 ], token_InfraSolidOfRevolution :> RandomInfraSolidOfRevolution[ graph, token, 2 ], token_InfraBallHull :> RandomInfraBallHull[ graph, token, 2 ], token_InfraConvexHull :> RandomInfraConvexHull[ graph, token, 2 ], token_InfraQuadric :> RandomInfraQuadric[ graph, token, 2 ], token_InfraWalk :> RandomInfraWalk[ graph, token, 2 ], token_InfraGeodesic :> RandomInfraGeodesic[ graph, token, 2 ], token_InfraEllipse :> RandomInfraEllipse[ graph, token, 2 ], token_InfraIntersection :> RandomInfraIntersection[ graph, token, 2 ], token_InfraUnion :> RandomInfraUnion[ graph, token, 2 ], token_InfraRay :> RandomInfraHalfLine[ graph, token, 2 ], token_InfraLine :> RandomInfraInfiniteLine[ graph, token, 2 ], token_InfraPolygon :> RandomInfraRegularPolygon[ graph, token, 2 ] } ] } ],
  { { }, { { } }, { { } }, { } },
  TestID -> "empty-tube-support-remains-one-set-representative"
]

EndTestSection[]
