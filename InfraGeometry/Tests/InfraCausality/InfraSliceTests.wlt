BeginTestSection["InfraSlice"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$fixtures = <| "TwoSource" -> $twoSource, "Diamond" -> $diamond, "Cylinder" -> $cylinder |>;

$heights = g |-> Range[ 0, Max @ CausalHeight @ g ];

$bandIsPastQ = { g, k } |-> Keys @ InfraMeasurement[ g, InfraSlice[ { 0, k } ], "VertexDensity" ] === Keys @ InfraMeasurement[ g, InfraCausalPast[ Keys @ InfraMeasurement[ g, InfraSlice[ k ], "VertexDensity" ] ], "VertexDensity" ];

$everyEventBelowSliceQ = { g, k } |-> With[ { slice = Keys @ InfraMeasurement[ g, InfraSlice[ k ], "VertexDensity" ] },
  AllTrue[ Keys @ InfraMeasurement[ g, InfraSlice[ { 0, k } ], "VertexDensity" ], e |-> IntersectingQ[ VertexOutComponent[ g, { e } ], slice ] ] ];

VerificationTest[
  AllTrue[ $fixtures, g |-> CausalHeightFoliation @ g === ( Keys @ InfraMeasurement[ g, InfraSlice[ # ], "VertexDensity" ] & /@ $heights @ g ) ],
  True,
  TestID -> "InfraSlice-All-slices-are-the-foliation"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> With[ { slice = Keys @ InfraMeasurement[ g, InfraSlice[ k ], "VertexDensity" ] }, InfraAntichainQ[ g, slice ] && InfraSliceQ[ g, slice ] ] ] ],
  True,
  TestID -> "InfraSlice-All-slices-are-antichains-and-level-sets"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> InfraSliceQ[ g, Keys @ InfraMeasurement[ g, InfraSlice[ # ], "VertexDensity" ] & /@ $heights @ g ] ],
  True,
  TestID -> "InfraSliceQ-All-accepts-the-list-of-slices"
]

VerificationTest[
  { InfraSliceQ[ $twoSource, { 1 } ], InfraSliceQ[ $twoSource, { 1, 3 } ], InfraSliceQ[ $twoSource, { } ] },
  { False, False, False },
  TestID -> "InfraSliceQ-TwoSource-rejects-part-of-a-slice-a-chain-and-empty"
]

VerificationTest[
  InfraSliceQ[ $diamond, { { 0, 3 }, { 1, 2 }, { 2, 1 }, { 3, 0 } } ],
  True,
  TestID -> "InfraSliceQ-Diamond-antidiagonal-is-slice-3"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> Keys @ InfraMeasurement[ g, InfraSlice[ { 0, k } ], "VertexDensity" ] === Sort @ Catenate[ Keys @ InfraMeasurement[ g, InfraSlice[ # ], "VertexDensity" ] & /@ Range[ 0, k ] ] ] ],
  True,
  TestID -> "InfraSlice-All-band-is-union-of-slices"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> $bandIsPastQ[ g, k ] === $everyEventBelowSliceQ[ g, k ] ] ],
  True,
  TestID -> "InfraSlice-All-band-is-past-iff-every-event-below-slice"
]

VerificationTest[
  { $bandIsPastQ[ $twoSource, 1 ], $bandIsPastQ[ $twoSource, 2 ] },
  { False, True },
  TestID -> "InfraSlice-TwoSource-band-is-past-only-from-height-2"
]

VerificationTest[
  AllTrue[ { $diamond, $cylinder }, g |-> AllTrue[ $heights @ g, k |-> $bandIsPastQ[ g, k ] ] ],
  True,
  TestID -> "InfraSlice-Lattices-band-is-past-of-slice"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> SubsetQ[ Keys @ InfraMeasurement[ g, InfraSlice[ { 0, k } ], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCausalPast[ Keys @ InfraMeasurement[ g, InfraSlice[ k ], "VertexDensity" ] ], "VertexDensity" ] ] ] ],
  True,
  TestID -> "InfraSlice-All-past-of-slice-lies-in-band"
]

VerificationTest[
  Length @ Keys @ InfraMeasurement[ $diamond, InfraSlice[ # ], "VertexDensity" ] & /@ Range[ 0, 6 ],
  { 1, 2, 3, 4, 3, 2, 1 },
  TestID -> "InfraSlice-Diamond-antidiagonal-sizes"
]

VerificationTest[
  AllTrue[ $heights @ $cylinder, k |-> Keys @ InfraMeasurement[ $cylinder, InfraSlice[ k ], "VertexDensity" ] === Sort @ Table[ { i, k }, { i, 0, 2 } ] ],
  True,
  TestID -> "InfraSlice-Cylinder-slices-are-rows"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> InfraMeasurement[ g, InfraSlice[ k ], "EdgeDensity" ] === <| |> ] ],
  True,
  TestID -> "InfraSlice-All-slice-spans-no-edge"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> With[ { band = InfraSlice[ { 0, Max @ CausalHeight @ g } ] },
    InfraMeasurement[ g, band, "CountingMeasure" ] == VertexCount @ g && Length @ InfraMeasurement[ g, band, "EdgeDensity" ] == EdgeCount @ g ] ],
  True,
  TestID -> "InfraSlice-All-full-band-is-the-graph"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> IsomorphicGraphQ[ InfraMeasurement[ g, InfraSlice[ { 0, k } ], "Subgraph" ], Subgraph[ g, Keys @ InfraMeasurement[ g, InfraSlice[ { 0, k } ], "VertexDensity" ] ] ] ] ],
  True,
  TestID -> "InfraSlice-All-subgraph-is-induced-band"
]

VerificationTest[
  Sort @ Keys @ InfraMeasurement[ $twoSource, InfraSlice[ 1 ], All ],
  Sort @ { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" },
  TestID -> "InfraSlice-TwoSource-all-readings"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> With[ { slice = InfraSlice[ k ] },
    InfraMemberQ[ g, slice, Reverse @ Keys @ InfraMeasurement[ g, slice, "VertexDensity" ] ] &&
      InfraMeasurement[ g, slice, "Cardinality" ] == 1 ] ] ],
  True,
  TestID -> "InfraSlice-All-single-member-is-the-support"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $heights @ g, k |-> With[ { support = Keys @ InfraMeasurement[ g, InfraSlice[ k ], "VertexDensity" ] },
    { points = RandomInfraPoint[ g, InfraSlice[ k ], Min[ 2, Length @ support ] ] },
    Length @ points == Min[ 2, Length @ support ] && DuplicateFreeQ @ points && SubsetQ[ support, points ] ] ] ],
  True,
  TestID -> "InfraSlice-All-random-points-are-distinct-events-of-the-support"
]

VerificationTest[
  Keys @ InfraMeasurement[ $twoSource, InfraSlice[ 7 ], "VertexDensity" ],
  { },
  TestID -> "InfraSlice-TwoSource-slice-above-the-height-is-empty"
]

EndTestSection[]
