BeginTestSection[ "RectilinearCoordinates" ]

VerificationTest[
  FindInfraCoordinateAxes[ GridGraph[ { 3, 3 } ], { 5, 6, 8 } ],
  { { 4, 5, 6 }, { 2, 5, 8 } },
  TestID -> "FindInfraCoordinateAxes-square-grid-straight-axes"
]

VerificationTest[
  FindInfraCoordinateAxes[ GridGraph[ { 3, 3, 3 } ], { 14, 15, 17, 23 } ],
  { { 13, 14, 15 }, { 11, 14, 17 }, { 5, 14, 23 } },
  TestID -> "FindInfraCoordinateAxes-cubic-grid-straight-axes"
]

VerificationTest[
  With[ { graph = GridGraph[ { 5, 5 } ] },
    { coordinates = RectilinearCoordinates[ graph, { 13, 14, 18 } ] },
    { Keys[ coordinates ] === VertexList[ graph ], coordinates[ 13 ], coordinates[ 1 ], coordinates[ 25 ],
      Sort[ Values[ coordinates ] ] === Tuples[ Range[ -2, 2 ], 2 ] } ],
  { True, { 0, 0 }, { -2, -2 }, { 2, 2 }, True },
  TestID -> "RectilinearCoordinates-square-grid-integer-chart"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3, 3 } ] },
    { coordinates = RectilinearCoordinates[ graph, { 14, 15, 17, 23 } ] },
    { coordinates[ 14 ], coordinates[ 27 ], Sort[ Values[ coordinates ] ] === Tuples[ Range[ -1, 1 ], 3 ],
      IsomorphicGraphQ[ InfraBaseSpace[ InfraFiberedGraph[ graph, coordinates ] ], graph ] } ],
  { { 0, 0, 0 }, { 1, 1, 1 }, True, True },
  TestID -> "RectilinearCoordinates-cubic-grid-image"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3, 3 } ] },
    { fibered = InfraFiberedGraph[ graph, RectilinearCoordinates[ graph, { 14, 15, 17 } ] ] },
    { VertexCount[ InfraBaseSpace[ fibered ] ], Union[ VertexCount /@ Values[ InfraFibers[ fibered ] ] ],
      AllTrue[ Values[ InfraFibers[ fibered ] ], IsomorphicGraphQ[ #, PathGraph[ Range[ 3 ] ] ] & ] } ],
  { 9, { 3 }, True },
  TestID -> "RectilinearCoordinates-two-axes-cubic-fibers"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ], axes = { { 4, 5, 6 }, { 1, 2, 5, 8, 9 } } },
    { coordinates = RectilinearCoordinates[ graph, { 5, 6, 8 }, "Axes" -> axes ] },
    { coordinates[ 5 ], coordinates[ 1 ], coordinates[ 4 ], DuplicateFreeQ[ Values[ coordinates ] ] } ],
  { { 0, 0 }, { -1, -2 }, { -1, -2 }, False },
  TestID -> "RectilinearCoordinates-nonorthogonal-axes-can-collapse"
]

VerificationTest[
  With[ { graph = GridGraph[ { 5, 5 } ] },
    { coordinates = RectilinearCoordinates[ graph, { 13, 14, 18 }, "Axes" -> { { 12, 13, 14 }, { 8, 13, 18 } } ] },
    { coordinates[ 1 ], coordinates[ 25 ], Length[ DeleteDuplicates[ Values[ coordinates ] ] ] } ],
  { { -1, -1 }, { 1, 1 }, 9 },
  TestID -> "RectilinearCoordinates-short-axes-clip"
]

VerificationTest[
  Table[
    RectilinearCoordinates[ CycleGraph[ 4 ], { 1, 4 }, "Axes" -> { { 2, 1, 4 } }, "SelectCoordinate" -> selector ][ 3 ],
    { selector, { Min, Max, First, Last } } ],
  { { -1 }, { 1 }, { -1 }, { 1 } },
  TestID -> "RectilinearCoordinates-ties-select-integer-axis-positions"
]

VerificationTest[
  With[ { graph = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ -1, 1 ], 2 ] ] ] },
    { coordinates = RectilinearCoordinates[ graph, { { 0, 0 }, { 0, 1 }, { 1, 0 } } ] },
    { Length[ coordinates ], coordinates[ { 0, 0 } ], coordinates[ { 1, -1 } ] } ],
  { 9, { 0, 0 }, { -1, 1 } },
  TestID -> "RectilinearCoordinates-tuple-vertex-labels"
]

VerificationTest[
  FindInfraCoordinateAxes[ GridGraph[ { 3, 3 } ], { 5, 9 } ],
  { { 5, 6, 9 } },
  TestID -> "FindInfraCoordinateAxes-branching-germ-stops-at-excess-bound"
]

VerificationTest[
  With[ { graph = VertexReplace[ GridGraph[ { 3, 3 } ], Thread[ Range[ 9 ] -> Tuples[ Range[ -1, 1 ], 2 ] ] ],
      frame = { { 0, 0 }, { 0, 1 }, { 1, 0 } },
      axes = { { { 0, -1 }, { 0, 0 }, { 0, 1 } }, { { -1, 0 }, { 0, 0 }, { 1, 0 } } } },
    RectilinearCoordinates[ graph, frame, "Axes" -> axes ] === RectilinearCoordinates[ graph, frame ] ],
  True,
  TestID -> "RectilinearCoordinates-explicit-axes-with-tuple-vertex-labels"
]

VerificationTest[
  With[ { graph = GridGraph[ { 3, 3 } ] },
    { reordered = Graph[ Reverse[ VertexList[ graph ] ], Reverse[ EdgeList[ graph ] ] ] },
    FindInfraCoordinateAxes[ graph, { 5, 9 } ] === FindInfraCoordinateAxes[ reordered, { 5, 9 } ] ],
  True,
  TestID -> "FindInfraCoordinateAxes-deterministic-under-graph-order"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    { axes = FindInfraCoordinateAxes[ graph, { 3, 4, 5 } ], coordinates = RectilinearCoordinates[ graph, { 3, 4, 5 } ] },
    { axes, coordinates[ 3 ], coordinates[ 5 ] } ],
  { { { 1, 2, 3, 4, 5 }, { 1, 2, 3, 4, 5 } }, { 0, 0 }, { 2, 2 } },
  TestID -> "RectilinearCoordinates-collinear-directions-allowed"
]

VerificationTest[
  With[ { graph = GraphUnion[ PathGraph[ { 1, 2, 3 } ], PathGraph[ { 4, 5 } ] ] },
    Head /@ { FindInfraCoordinateAxes[ graph, { 1, 2 } ], RectilinearCoordinates[ graph, { 1, 2 } ] } ],
  { FindInfraCoordinateAxes, RectilinearCoordinates },
  TestID -> "RectilinearCoordinates-disconnected-input-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    Head /@ { RectilinearCoordinates[ graph, { 1 } ], RectilinearCoordinates[ graph, { 1, 1 } ],
      RectilinearCoordinates[ graph, { 1, 9 } ], FindInfraCoordinateAxes[ graph, { 1, 1 } ] } ],
  { RectilinearCoordinates, RectilinearCoordinates, RectilinearCoordinates, FindInfraCoordinateAxes },
  TestID -> "RectilinearCoordinates-invalid-frames-unevaluated"
]

VerificationTest[
  With[ { graph = PathGraph[ Range[ 5 ] ] },
    Head /@ {
      RectilinearCoordinates[ graph, { 3, 4 }, "Axes" -> { { 5, 4, 3, 2, 1 } } ],
      RectilinearCoordinates[ graph, { 3, 4 }, "Axes" -> { { 1, 3, 4 } } ],
      RectilinearCoordinates[ graph, { 3, 4 }, "Axes" -> { { 2, 3 } } ],
      RectilinearCoordinates[ graph, { 3, 4 }, "Axes" -> { { 2, 3, 4 }, { 2, 3, 4 } } ] } ],
  ConstantArray[ RectilinearCoordinates, 4 ],
  TestID -> "RectilinearCoordinates-invalid-explicit-axes-unevaluated"
]

VerificationTest[
  Head /@ Table[
    RectilinearCoordinates[ CycleGraph[ 4 ], { 1, 4 }, "SelectCoordinate" -> selector ],
    { selector, { Mean, Median, All } } ],
  ConstantArray[ RectilinearCoordinates, 3 ],
  TestID -> "RectilinearCoordinates-unsupported-selectors-unevaluated"
]

VerificationTest[
  Head /@ {
    RectilinearCoordinates[ PathGraph[ Range[ 3 ], DirectedEdges -> True ], { 1, 2 } ],
    RectilinearCoordinates[ PathGraph[ Range[ 3 ], EdgeWeight -> { 1, 1 } ], { 1, 2 } ] },
  { RectilinearCoordinates, RectilinearCoordinates },
  TestID -> "RectilinearCoordinates-directed-weighted-inputs-unevaluated"
]

VerificationTest[
  With[ { graph = Graph[ { UndirectedEdge[ 1, 2, "edge" ] } ] },
    Head /@ { FindInfraCoordinateAxes[ graph, { 1, 2 } ], RectilinearCoordinates[ graph, { 1, 2 } ] } ],
  { FindInfraCoordinateAxes, RectilinearCoordinates },
  TestID -> "RectilinearCoordinates-edge-tagged-inputs-unevaluated"
]

EndTestSection[]
