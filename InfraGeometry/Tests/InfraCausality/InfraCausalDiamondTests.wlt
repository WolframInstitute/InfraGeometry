BeginTestSection["InfraCausalDiamond"]

Needs[ "WolframInstitute`InfraGeometry`" ]

$twoSource = Graph[ { 1 -> 3, 2 -> 4, 3 -> 4, 4 -> 5 } ];

$diamond = Graph[ Flatten @ Table[
  Select[ { { i, j } -> { i + 1, j }, { i, j } -> { i, j + 1 } }, Max @ Last @ # <= 3 & ],
  { i, 0, 3 }, { j, 0, 3 } ] ];

$cylinder = Graph[ Flatten @ Table[
  { { k, t } -> { k, t + 1 }, { k, t } -> { Mod[ k + 1, 3 ], t + 1 } },
  { k, 0, 2 }, { t, 0, 2 } ] ];

$fixtures = <| "TwoSource" -> $twoSource, "Diamond" -> $diamond, "Cylinder" -> $cylinder |>;

$comparablePairs = g |-> Select[ Tuples[ VertexList @ g, 2 ], pair |-> MemberQ[ VertexOutComponent[ g, { First @ pair } ], Last @ pair ] ];

$between = { g, u, w } |-> Intersection[ VertexOutComponent[ g, { u } ], VertexInComponent[ g, { w } ] ];

$convexQ = g |-> AllTrue[ $comparablePairs @ g, pair |->
  With[ { diamond = Keys @ InfraMeasurement[ g, InfraCausalDiamond[ First @ pair, Last @ pair ], "VertexDensity" ] },
    AllTrue[ Tuples[ diamond, 2 ], uw |-> SubsetQ[ diamond, $between[ g, First @ uw, Last @ uw ] ] ] ] ];

$intersectionQ = g |-> AllTrue[ Tuples[ VertexList @ g, 2 ], pair |->
  Keys @ InfraMeasurement[ g, InfraCausalDiamond[ First @ pair, Last @ pair ], "VertexDensity" ] ===
    Intersection[ Keys @ InfraMeasurement[ g, InfraCausalFuture[ First @ pair ], "VertexDensity" ], Keys @ InfraMeasurement[ g, InfraCausalPast[ Last @ pair ], "VertexDensity" ] ] ];

$diamondQAcceptsQ = g |-> AllTrue[ $comparablePairs @ g, pair |-> InfraCausalDiamondQ[ g, Keys @ InfraMeasurement[ g, InfraCausalDiamond[ First @ pair, Last @ pair ], "VertexDensity" ] ] ];

$chainHullQ = { g, p, q } |-> AllTrue[ FindPath[ g, p, q, Infinity, All ], chain |->
  InfraMeasurement[ g, InfraCausalDiamond[ chain ], "VertexDensity" ] === InfraMeasurement[ g, InfraCausalDiamond[ p, q ], "VertexDensity" ] ];

VerificationTest[ $convexQ[ $twoSource ], True, TestID -> "InfraCausalDiamond-TwoSource-convex" ]

VerificationTest[ $convexQ[ $diamond ], True, TestID -> "InfraCausalDiamond-Diamond-convex" ]

VerificationTest[ $convexQ[ $cylinder ], True, TestID -> "InfraCausalDiamond-Cylinder-convex" ]

VerificationTest[ $intersectionQ[ $twoSource ], True, TestID -> "InfraCausalDiamond-TwoSource-intersection-of-cones" ]

VerificationTest[ $intersectionQ[ $diamond ], True, TestID -> "InfraCausalDiamond-Diamond-intersection-of-cones" ]

VerificationTest[ $intersectionQ[ $cylinder ], True, TestID -> "InfraCausalDiamond-Cylinder-intersection-of-cones" ]

VerificationTest[
  AllTrue[ Tuples[ Tuples[ { Range[ 0, 3 ], Range[ 0, 3 ] } ], 2 ], pair |->
    With[ { span = Last @ pair - First @ pair },
      InfraMeasurement[ $diamond, InfraCausalDiamond @@ pair, "CountingMeasure" ] ==
        If[ AllTrue[ span, NonNegative ], Times @@ ( span + 1 ), 0 ] ] ],
  True,
  TestID -> "InfraCausalDiamond-Diamond-volume-is-rectangle"
]

VerificationTest[ AllTrue[ $fixtures, $diamondQAcceptsQ ], True, TestID -> "InfraCausalDiamondQ-All-accepts-sampled-diamonds" ]

VerificationTest[ InfraCausalDiamondQ[ $diamond, { { 0, 0 }, { 3, 3 } } ], False, TestID -> "InfraCausalDiamondQ-Diamond-hollow-pair-rejected" ]

VerificationTest[ InfraCausalDiamondQ[ $twoSource, { 1, 2, 4 } ], False, TestID -> "InfraCausalDiamondQ-TwoSource-two-minima-rejected" ]

VerificationTest[ $chainHullQ[ $diamond, { 0, 0 }, { 3, 3 } ], True, TestID -> "InfraCausalDiamond-Diamond-worldline-hull-is-endpoint-diamond" ]

VerificationTest[ $chainHullQ[ $cylinder, { 0, 0 }, { 0, 3 } ], True, TestID -> "InfraCausalDiamond-Cylinder-worldline-hull-is-endpoint-diamond" ]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $comparablePairs @ g, pair |->
    With[ { diamond = InfraCausalDiamond @@ pair },
      InfraMemberQ[ g, diamond, Reverse @ Keys @ InfraMeasurement[ g, diamond, "VertexDensity" ] ] &&
        InfraMeasurement[ g, diamond, "Cardinality" ] == 1 ] ] ],
  True,
  TestID -> "InfraCausalDiamond-All-single-member-is-the-support"
]

VerificationTest[
  AllTrue[ $fixtures, g |-> AllTrue[ $comparablePairs @ g, pair |->
    With[ { support = Keys @ InfraMeasurement[ g, InfraCausalDiamond @@ pair, "VertexDensity" ] },
      { points = RandomInfraPoint[ g, InfraCausalDiamond @@ pair, Min[ 3, Length @ support ] ] },
      Length @ points == Min[ 3, Length @ support ] && DuplicateFreeQ @ points && SubsetQ[ support, points ] ] ] ],
  True,
  TestID -> "InfraCausalDiamond-All-random-points-are-distinct-events-of-the-support"
]

EndTestSection[]
