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
    Table[ Keys @ InfraMeasurement[ g, InfraTube[core, {s, s}], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraShell[core, s], "VertexDensity" ], { s, 0, 4 } ] ],
  ConstantArray[True, 5],
  TestID -> "InfraTube-band-r-r-is-the-shell"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { Keys @ InfraMeasurement[ g, InfraTube[{1, 2, 3}, 1], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraTube[{1, 2, 3}, {1, 2}], "VertexDensity" ] } ],
  { {1, 2, 3, 4, 6, 7, 8}, {4, 5, 6, 7, 8, 9, 11, 12, 13} },
  TestID -> "InfraTube-of-a-vertex-list-and-its-band"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { Keys @ InfraMeasurement[ g, InfraTube[<| 1 -> 2, 25 -> 1 |>, 1], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraTube[RandomInfraSegment[g, 1, 3], 1], "VertexDensity" ] } ],
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
    { Keys @ InfraMeasurement[ g, InfraTube[{}, 2], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraTube[{1, 2}, {3, 2}], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraTube[1, {9, 10}], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraTube[1, Infinity], "VertexDensity" ] } ],
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
  With[ { g = GridGraph[{9, 9}] },
    Table[ Keys @ InfraMeasurement[ g, InfraTube[c, p], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraTube[c, p, Method -> "Balls"], "VertexDensity" ],
      { c, { 41, {1, 2, 3}, <| 1 -> 2, 81 -> 1 |>, InfraSegment[1, 41], RandomInfraSegment[g, 1, 41], {} } },
      { p, { 0, 1, 3, {1, 2}, {2, 2}, {3, 1}, Infinity } } ] ],
  ConstantArray[True, { 6, 7 }],
  TestID -> "InfraTube-Balls-is-the-default-method"
]

(* a profile along the core is the union of the balls B(a_i, r_i); a list and a function of the position say the same *)
VerificationTest[
  With[ { g = GridGraph[{7, 7}], axis = {9, 10, 11, 12, 13} },
    { Keys @ InfraMeasurement[ g, InfraTube[axis, {0, 1, 2, 1, 0}], "VertexDensity" ] ===
        Union @@ MapThread[ Keys @ InfraMeasurement[ g, InfraBall[#1, #2], "VertexDensity" ] &, { axis, {0, 1, 2, 1, 0} } ],
      Keys @ InfraMeasurement[ g, InfraTube[axis, Range[0, 4]], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraTube[axis, # - 1 &], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, Range[0, 4]], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, # - 1 &], "VertexDensity" ] } ],
  { True, True, True },
  TestID -> "InfraTube-profile-is-the-union-of-balls"
]

(* a band profile {r_i, r_i} is the level set min_i ( d(a_i, v) - r_i ) == 0 *)
VerificationTest[
  With[ { g = GridGraph[{7, 7}], axis = {9, 10, 11, 12, 13}, radii = {0, 1, 2, 1, 0} },
    Keys @ InfraMeasurement[ g, InfraTube[axis, { #, # } & /@ radii], "VertexDensity" ] ===
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
    { Keys @ InfraMeasurement[ g, InfraCylinder[axis, 2], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCylinder[axis, 2, Method -> "Balls"], "VertexDensity" ] } ===
      { Sort @ Flatten @ Table[ at[x, y], { x, 3, 7 }, { y, 3, 7 } ],
        Select[ VertexList @ g, v |-> Min[ GraphDistance[g, #, v] & /@ axis ] <= 2 ] } ],
  True,
  TestID -> "InfraCylinder-grid-row-flat-and-rounded-ends"
]

(* on a path graph the perpendicular slab of an axis vertex is the vertex itself *)
VerificationTest[
  With[ { g = PathGraph[Range[9]], axis = {3, 4, 5, 6, 7} },
    { Keys @ InfraMeasurement[ g, InfraCylinder[axis, 0], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCylinder[axis, 1], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraCylinder[axis, {1, 2}], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCylinder[axis, 1, Method -> "Balls"], "VertexDensity" ] } ],
  { {3, 4, 5, 6, 7}, {3, 4, 5, 6, 7}, {}, {2, 3, 4, 5, 6, 7, 8} },
  TestID -> "InfraCylinder-PathGraph-is-the-axis"
]

(* a closed axis has no ends, so the slicing cuts nothing and a constant radius gives the tube *)
VerificationTest[
  With[ { g = GridGraph[{9, 9}], at = { x, y } |-> 9 ( x - 1 ) + y },
    { loop = at @@@ Join[ Table[ {3, y}, { y, 3, 6 } ], Table[ {x, 7}, { x, 3, 6 } ], Table[ {7, y}, { y, 7, 4, -1 } ],
        Table[ {x, 3}, { x, 7, 3, -1 } ] ] },
    Table[ Keys @ InfraMeasurement[ g, InfraCylinder[loop, r], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraTube[loop, r], "VertexDensity" ], { r, 0, 3 } ] ],
  ConstantArray[True, 4],
  TestID -> "InfraCylinder-closed-axis-has-no-ends"
]

VerificationTest[
  With[ { g = GridGraph[{6, 6}], axis = {1, 2, 3, 4, 5, 6} },
    Table[
      { InfraMeasurement[g, InfraCylinder[axis, r, Method -> "Balls"], All] === InfraMeasurement[g, InfraTube[axis, r], All],
        Keys @ InfraMeasurement[ g, InfraCylinder[{15}, r], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraBall[15, r], "VertexDensity" ],
        Keys @ InfraMeasurement[ g, InfraCylinder[axis, {1, r}], "VertexDensity" ] ===
          Complement[ Keys @ InfraMeasurement[ g, InfraCylinder[axis, r], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCylinder[axis, 0], "VertexDensity" ] ] },
      { r, 1, 3 } ] ],
  ConstantArray[True, { 3, 3 }],
  TestID -> "InfraCylinder-balls-method-one-vertex-axis-and-band"
]

(* ===== InfraCone ===== *)

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    { Keys @ InfraMeasurement[ g, InfraCone[{1, 2, 3, 4, 5}, 0], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCone[{21, 17, 13, 9, 5}, 0], "VertexDensity" ] } ],
  { {1, 2, 3, 4, 5}, {5, 9, 13, 17, 21} },
  TestID -> "InfraCone-slope-0-is-the-axis"
]

(* the row of axis vertex i holds 2 (i - 1) + 1 vertices, the base row included *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}] },
    KeySort @ Counts[ Mod[ Keys @ InfraMeasurement[ g, InfraCone[11 * 5 + Range[2, 7], 1], "VertexDensity" ] - 1, 11 ] + 1 ] ],
  <| 2 -> 1, 3 -> 3, 4 -> 5, 5 -> 7, 6 -> 9, 7 -> 11 |>,
  TestID -> "InfraCone-slices-grow-by-the-slope"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}], axis = {6, 7, 8, 9, 10} },
    { Keys @ InfraMeasurement[ g, InfraCone[axis, 1], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, Range[0, 4]], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraCone[Reverse @ axis, 1], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, Range[4, 0, -1]], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraCone[axis, 1, Method -> "Balls"], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraTube[axis, Range[0, 4]], "VertexDensity" ] } ],
  { True, True, True },
  TestID -> "InfraCone-is-the-linear-profile-either-apex"
]

(* d(v, a_i) <= slope (i - 1): radii 0, 0, 1, 1, 2 at slope 1/2; sliced on a path, the axis *)
VerificationTest[
  With[ { g = PathGraph[Range[9]] },
    { Keys @ InfraMeasurement[ g, InfraCone[{1, 2, 3, 4, 5}, 1/2], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCone[{1, 2, 3, 4, 5}, 1/2, Method -> "Balls"], "VertexDensity" ],
      Keys @ InfraMeasurement[ g, InfraCone[{5, 6, 7, 8, 9}, 1/2, Method -> "Balls"], "VertexDensity" ] } ],
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
    Table[ Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, r], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraCylinder[axis, r], "VertexDensity" ],
      { r, { 0, 1, 2, {1, 2}, {2, 2} } } ] ],
  ConstantArray[True, 5],
  TestID -> "InfraSolidOfRevolution-constant-profile-is-the-cylinder"
]

(* the profile is read at the foot of the perpendicular, so a jump is a sharp step; the balls spread it to the neighbouring rows *)
VerificationTest[
  With[ { g = GridGraph[{11, 11}], axis = 11 * 5 + Range[2, 8], profile = {1, 1, 1, 3, 1, 1, 1} },
    KeySort @ Counts[ Mod[ ( Keys @ InfraMeasurement[ g, #, "VertexDensity" ] ) - 1, 11 ] + 1 ] & /@
      { InfraSolidOfRevolution[axis, profile], InfraSolidOfRevolution[axis, profile, Method -> "Balls"] } ],
  { <| 2 -> 3, 3 -> 3, 4 -> 3, 5 -> 7, 6 -> 3, 7 -> 3, 8 -> 3 |>, <| 1 -> 1, 2 -> 3, 3 -> 3, 4 -> 5, 5 -> 7, 6 -> 5, 7 -> 3, 8 -> 3, 9 -> 1 |> },
  TestID -> "InfraSolidOfRevolution-profile-read-at-the-foot"
]

VerificationTest[
  With[ { g = GridGraph[{5, 5}], axis = {1, 2, 3, 4, 5}, profile = {0, 1, 2, 1, 0} },
    { solid = Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, profile], "VertexDensity" ] },
    { SubsetQ[ solid, Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, { #, # } & /@ profile], "VertexDensity" ] ],
      solid === Union @@ Table[
        Keys @ InfraMeasurement[ g, InfraSolidOfRevolution[axis, { #, # } & /@ ( Min[ #, k ] & /@ profile )], "VertexDensity" ], { k, 0, 2 } ] } ],
  { True, True },
  TestID -> "InfraSolidOfRevolution-solid-is-the-union-of-its-surfaces"
]

VerificationTest[
  { Keys @ InfraMeasurement[ PetersenGraph[], InfraSolidOfRevolution[{1}, {2, 2}], "VertexDensity" ] === Keys @ InfraMeasurement[ PetersenGraph[], InfraShell[1, 2], "VertexDensity" ],
    Keys @ InfraMeasurement[ PathGraph[Range[5]], InfraSolidOfRevolution[{3}, 100], "VertexDensity" ],
    Keys @ InfraMeasurement[ PathGraph[Range[5]], InfraSolidOfRevolution[{3}, {100, 100}], "VertexDensity" ] },
  { True, {1, 2, 3, 4, 5}, {} },
  TestID -> "InfraSolidOfRevolution-one-vertex-axis-and-past-the-diameter"
]

(* ===== the solids together ===== *)

VerificationTest[
  With[ { g = GridGraph[{5, 5}] },
    Table[ { InfraMemberQ[g, s, ( Keys @ InfraMeasurement[ g, s, "VertexDensity" ] )], InfraMemberQ[g, s, {1, 2}] },
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
      RandomInfraSceneInstance[ InfraScene[ { t }, { t == # } ], g, All ] & /@
        { InfraTube[{1, 2}, 1], InfraCylinder[{1, 2}, 1], InfraCone[{1, 2}, 1], InfraSolidOfRevolution[{5, 6, 7, 8}, {0, 1, 1, 0}] }, { 2 } ] ],
  { { {1, 2, 3, 5, 6} }, { {1, 2, 5, 6} }, { {1, 2, 6} }, { {2, 3, 5, 6, 7, 8, 10, 11} } },
  TestID -> "InfraTube-InfraCylinder-InfraCone-InfraSolidOfRevolution-are-scene-constructors"
]



VerificationTest[
  With[ { graph = PathGraph[ { { 1, 0 }, { 2, 0 }, { 3, 0 } } ] },
    Keys @ InfraMeasurement[ graph, InfraTube[ { 2, 0 }, 1 ], "VertexDensity" ] ],
  { { 1, 0 }, { 2, 0 }, { 3, 0 } },
  TestID -> "tube-support-preserves-list-valued-vertex-labels"
]

VerificationTest[
  Keys @ InfraMeasurement[ PathGraph[ Range[ 3 ] ], InfraTube[ 2, { 10, 10 } ], "VertexDensity" ],
  {},
  TestID -> "empty-tube-support"
]

EndTestSection[]
