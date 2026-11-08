BeginTestSection["InfraCausalFuture"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$fixtures = <| "TwoSource" -> $twoSource, "Diamond" -> $diamond, "Cylinder" -> $cylinder |>;

$tau = { g, v, e } |-> Max[ Length /@ FindPath[ g, v, e, Infinity, All ] ] - 1;

$upSetQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { cone = Keys @ InfraMeasurement[ g, InfraCausalFuture[ v ], "VertexDensity" ] },
    MemberQ[ cone, v ] && SubsetQ[ cone, Catenate[ VertexOutComponent[ g, { # }, 1 ] & /@ cone ] ] ] ];

$downSetQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { cone = Keys @ InfraMeasurement[ g, InfraCausalPast[ v ], "VertexDensity" ] },
    MemberQ[ cone, v ] && SubsetQ[ cone, Catenate[ VertexInComponent[ g, { # }, 1 ] & /@ cone ] ] ] ];

$futureCutQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { future = VertexOutComponent[ g, { v } ] },
    AllTrue[ Range[ 0, VertexCount @ g ], t |->
      Keys @ InfraMeasurement[ g, InfraCausalFuture[ v, t ], "VertexDensity" ] ===
        Sort @ Select[ future, e |-> $tau[ g, v, e ] <= t ] ] ] ];

$pastCutQ = g |-> AllTrue[ VertexList @ g, v |->
  With[ { past = VertexInComponent[ g, { v } ] },
    AllTrue[ Range[ 0, VertexCount @ g ], t |->
      Keys @ InfraMeasurement[ g, InfraCausalPast[ v, t ], "VertexDensity" ] ===
        Sort @ Select[ past, e |-> $tau[ g, e, v ] <= t ] ] ] ];

$subgraphQ = g |-> AllTrue[ VertexList @ g, v |->
  IsomorphicGraphQ[ InfraMeasurement[ g, InfraCausalFuture[ v ], "Subgraph" ], VertexOutComponentGraph[ g, { v } ] ] &&
    InfraMeasurement[ g, InfraCausalFuture[ v ], "CountingMeasure" ] == VertexCount @ VertexOutComponentGraph[ g, { v } ] ];

$randomPointsQ = { g, head } |-> With[ { support = Keys @ InfraMeasurement[ g, head, "VertexDensity" ] },
  { points = RandomInfraPoint[ g, head, Min[ 3, Length @ support ] ] },
  Length @ points == Min[ 3, Length @ support ] && DuplicateFreeQ @ points && SubsetQ[ support, points ] &&
    InfraMeasurement[ g, head, "Cardinality" ] == 1 ];

VerificationTest[ $upSetQ[ $twoSource ], True, TestID -> "InfraCausalFuture-TwoSource-up-set-containing-v" ]

VerificationTest[ $upSetQ[ $diamond ], True, TestID -> "InfraCausalFuture-Diamond-up-set-containing-v" ]

VerificationTest[ $upSetQ[ $cylinder ], True, TestID -> "InfraCausalFuture-Cylinder-up-set-containing-v" ]

VerificationTest[ $downSetQ[ $twoSource ], True, TestID -> "InfraCausalPast-TwoSource-down-set-containing-v" ]

VerificationTest[ $downSetQ[ $diamond ], True, TestID -> "InfraCausalPast-Diamond-down-set-containing-v" ]

VerificationTest[ $downSetQ[ $cylinder ], True, TestID -> "InfraCausalPast-Cylinder-down-set-containing-v" ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |-> InfraCausalFutureQ[ g, Keys @ InfraMeasurement[ g, InfraCausalFuture[ v ], "VertexDensity" ] ] ] ],
  True,
  TestID -> "InfraCausalFutureQ-All-accepts-sampled-futures"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |-> InfraCausalPastQ[ g, Keys @ InfraMeasurement[ g, InfraCausalPast[ v ], "VertexDensity" ] ] ] ],
  True,
  TestID -> "InfraCausalPastQ-All-accepts-sampled-pasts"
]

VerificationTest[ InfraCausalFutureQ[ $twoSource, { 1, 2 } ], False, TestID -> "InfraCausalFutureQ-TwoSource-two-sources-rejected" ]

VerificationTest[ InfraCausalPastQ[ $twoSource, { 1, 2 } ], False, TestID -> "InfraCausalPastQ-TwoSource-two-sources-rejected" ]

VerificationTest[
  Keys @ InfraMeasurement[ $twoSource, InfraCausalFuture[ { 1, 2 } ], "VertexDensity" ] === Union[ VertexOutComponent[ $twoSource, { 1 } ], VertexOutComponent[ $twoSource, { 2 } ] ],
  True,
  TestID -> "InfraCausalFuture-TwoSource-set-anchor-is-union"
]

VerificationTest[ $futureCutQ[ $twoSource ], True, TestID -> "InfraCausalFuture-TwoSource-proper-time-cut" ]

VerificationTest[ $futureCutQ[ $diamond ], True, TestID -> "InfraCausalFuture-Diamond-proper-time-cut" ]

VerificationTest[ $futureCutQ[ $cylinder ], True, TestID -> "InfraCausalFuture-Cylinder-proper-time-cut" ]

VerificationTest[ $pastCutQ[ $diamond ], True, TestID -> "InfraCausalPast-Diamond-proper-time-cut" ]

VerificationTest[
  AllTrue[ VertexList @ $diamond, v |->
    AllTrue[ Range[ 0, 6 ], t |->
      AllTrue[ Keys @ InfraMeasurement[ $diamond, InfraCausalFuture[ v, t ], "VertexDensity" ],
        e |-> CausalHeight[ InfraMeasurement[ $diamond, InfraCausalFuture[ v ], "Subgraph" ] ][ e ] <= t ] ] ],
  True,
  TestID -> "InfraCausalFuture-Diamond-cut-causal-height-bounded"
]

VerificationTest[
  AllTrue[ Tuples[ { Range[ 0, 3 ], Range[ 0, 3 ] } ], v |-> Length @ Keys @ InfraMeasurement[ $diamond, InfraCausalFuture[ v ], "VertexDensity" ] == ( 4 - First @ v ) ( 4 - Last @ v ) ],
  True,
  TestID -> "InfraCausalFuture-Diamond-volume-is-rectangle"
]

VerificationTest[ $subgraphQ[ $twoSource ], True, TestID -> "InfraCausalFuture-TwoSource-subgraph-and-counting-measure" ]

VerificationTest[ $subgraphQ[ $diamond ], True, TestID -> "InfraCausalFuture-Diamond-subgraph-and-counting-measure" ]

VerificationTest[ $subgraphQ[ $cylinder ], True, TestID -> "InfraCausalFuture-Cylinder-subgraph-and-counting-measure" ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |->
    InfraMemberQ[ g, InfraCausalFuture[ v ], Reverse @ Keys @ InfraMeasurement[ g, InfraCausalFuture[ v ], "VertexDensity" ] ] &&
      ! InfraMemberQ[ g, InfraCausalFuture[ v ], Most @ Keys @ InfraMeasurement[ g, InfraCausalFuture[ v ], "VertexDensity" ] ] ] ],
  True,
  TestID -> "InfraCausalFuture-All-member-is-the-support"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |-> $randomPointsQ[ g, InfraCausalFuture[ v ] ] ] ],
  True,
  TestID -> "InfraCausalFuture-All-random-points-are-distinct-events-of-the-support"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ VertexList @ g, v |-> $randomPointsQ[ g, InfraCausalPast[ v ] ] ] ],
  True,
  TestID -> "InfraCausalPast-All-random-points-are-distinct-events-of-the-support"
]

VerificationTest[
  AllTrue[ VertexList @ $diamond, v |->
    With[ { reading = InfraMeasurement[ $diamond, InfraCausalFuture[ v ], All ] },
      reading[ "CountingMeasure" ] == Total @ reading[ "VertexDensity" ] &&
        Sort @ Keys @ reading[ "EdgeDensity" ] === Sort @ EdgeList @ reading[ "Subgraph" ] ] ],
  True,
  TestID -> "InfraCausalFuture-Diamond-readings-agree"
]

EndTestSection[]
