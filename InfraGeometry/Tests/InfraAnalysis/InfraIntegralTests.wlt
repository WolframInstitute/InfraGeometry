BeginTestSection["InfraIntegral"]

(* ===== InfraIntegral: a sum over a region, or one sum per member of a family of walks, read as a value density ===== *)

integralGrid = GridGraph[ { 5, 5 } ]

integralF = AssociationThread[ Range[ 25 ], Prime /@ Range[ 25 ] ]

integralDiamond = Graph[ { 1, 2, 3, 4 }, { 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4 } ]

integralLattice = Graph[ Flatten[ Table[ { i, j }, { i, 0, 6 }, { j, 0, 6 } ], 1 ],
  Flatten @ Table[ { If[ i < 6, DirectedEdge[ { i, j }, { i + 1, j } ], Nothing ], If[ j < 6, DirectedEdge[ { i, j }, { i, j + 1 } ], Nothing ] }, { i, 0, 6 }, { j, 0, 6 } ] ]

integralRandomDAGs = ( SeedRandom[ 11 ];
  Table[ With[ { n = RandomInteger[ { 5, 9 } ] },
      Graph[ Range[ n ], DirectedEdge @@@ ( Sort /@ RandomSample[ Subsets[ Range[ n ], { 2 } ], RandomInteger[ { 4, Min[ 16, n ( n - 1 ) / 2 ] } ] ] ) ] ],
    25 ] )

(* a stand-in for a foreign head, such as InfraCausality's InfraWorldline[p, q]: its one reading is a "Graph", the chains of the causal interval *)
integralChains /: InfraMeasurement[ graph_Graph, integralChains[ p_, q_ ], "Graph" ] :=
  TransitiveReductionGraph @ Subgraph[ graph, Intersection[ VertexOutComponent[ graph, { p } ], VertexInComponent[ graph, { q } ] ] ]

(* ===== the fundamental theorem: the integral of df along every member from p to q is f(q) - f(p) ===== *)

VerificationTest[
  InfraMeasurement[ integralGrid, InfraIntegral[ InfraDifferential[ integralF ], InfraSegment[ 1, 19 ] ], "ValueDensity" ],
  <| 65 -> 20 |>,
  TestID -> "InfraIntegral-GridGraph-differential-is-Dirac-on-a-segment"
]

VerificationTest[
  SeedRandom[ 13 ];
  With[ { g = InfraSubstrate[ "SquareTilingGraph", "Small" ] },
    { p = First @ GraphCenter @ g, f = AssociationThread[ VertexList @ g, RandomInteger[ { -9, 9 }, VertexCount @ g ] ] },
    AllTrue[ Keys @ InfraMeasurement[ g, InfraShell[ p, 3 ], "VertexDensity" ], q |->
      InfraMeasurement[ g, InfraIntegral[ InfraDifferential[ f ], InfraSegment[ p, q ] ], "ValueDensity" ] ===
        <| f[ q ] - f[ p ] -> InfraMeasurement[ g, InfraSegment[ p, q ], "Cardinality" ] |> ] ],
  True,
  TestID -> "InfraIntegral-SquareTiling-differential-is-Dirac-on-every-segment-to-the-shell"
]

VerificationTest[
  SeedRandom[ 14 ];
  With[ { g = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
    { p = First @ GraphCenter @ g, f = AssociationThread[ VertexList @ g, RandomInteger[ { -9, 9 }, VertexCount @ g ] ] },
    AllTrue[ VertexList @ g, q |->
      InfraMeasurement[ g, InfraIntegral[ InfraDifferential[ f ], InfraSegment[ p, q ] ], "ValueDensity" ] ===
        <| f[ q ] - f[ p ] -> InfraMeasurement[ g, InfraSegment[ p, q ], "Cardinality" ] |> ] ],
  True,
  TestID -> "InfraIntegral-HexagonalTiling-differential-is-Dirac-on-every-segment"
]

(* rays and lines have many ends: the density of df has one atom per end pair, at f(end) - f(start) *)
VerificationTest[
  With[ { df = InfraMeasurement[ integralGrid, InfraDifferential[ integralF ], "Function" ] },
    AllTrue[ { InfraHalfLine[ 13, 14 ], InfraInfiniteLine[ 12, 13 ] }, obj |->
      Keys @ InfraMeasurement[ integralGrid, InfraIntegral[ df, obj ], "ValueDensity" ] ===
        Union[ ( path |-> integralF[ Last @ path ] - integralF[ First @ path ] ) /@
          Replace[ obj, { h_InfraHalfLine :> RandomInfraHalfLine[ integralGrid, h, All ], l_InfraInfiniteLine :> RandomInfraInfiniteLine[ integralGrid, l, All ] } ] ] ] ],
  True,
  TestID -> "InfraIntegral-GridGraph-differential-on-rays-and-lines-reads-the-ends"
]

VerificationTest[
  With[ { g = GridGraph[ { 7, 7 } ], f = AssociationThread[ Range[ 49 ], Range[ 49 ]^2 ] },
    InfraMeasurement[ g, InfraIntegral[ InfraDifferential[ f ], InfraArc[ 25, { 18, 32 }, "RadiusDelta" -> 1 ] ], "ValueDensity" ] ],
  <| 32^2 - 18^2 -> 2 |>,
  TestID -> "InfraIntegral-GridGraph-differential-is-Dirac-on-an-open-arc"
]

VerificationTest[
  InfraMeasurement[ integralLattice, InfraIntegral[ InfraDifferential[ Apply[ Times ] ], integralChains[ { 0, 0 }, { 6, 6 } ] ], "ValueDensity" ],
  <| 36 -> 924 |>,
  TestID -> "InfraIntegral-Lattice-differential-of-ij-is-Dirac-on-the-924-chains"
]

VerificationTest[
  InfraMeasurement[ integralDiamond, InfraIntegral[ InfraDifferential[ <| 1 -> 1, 2 -> 50, 3 -> -7, 4 -> 10000 |> ], integralChains[ 1, 4 ] ], All ],
  <| "Value" -> 9999, "ValueDensity" -> <| 9999 -> 2 |>, "Mean" -> 9999, "Cardinality" -> 2 |>,
  TestID -> "InfraIntegral-Diamond-foreign-head-differential-is-Dirac"
]

(* ===== the value density is one forward sweep, equal to the enumeration of the members ===== *)

VerificationTest[
  SeedRandom[ 5 ];
  AllTrue[ integralRandomDAGs, g |-> With[ { hasse = TransitiveReductionGraph @ g, p = First @ TopologicalSort @ g },
    { w = AssociationThread[ EdgeList @ hasse, RandomInteger[ { -3, 3 }, EdgeCount @ hasse ] ] },
    AllTrue[ DeleteCases[ VertexOutComponent[ g, { p } ], p ], q |->
      InfraMeasurement[ g, InfraIntegral[ w, integralChains[ p, q ] ], "ValueDensity" ] ===
        KeySort @ Counts[ ( path |-> Total[ w /@ DirectedEdge @@@ Partition[ path, 2, 1 ] ] ) /@ FindPath[ hasse, p, q, Infinity, All ] ] ] ] ],
  True,
  TestID -> "InfraIntegral-RandomDAGs-1-form-value-density-is-the-enumeration"
]

VerificationTest[
  SeedRandom[ 6 ];
  AllTrue[ integralRandomDAGs, g |-> With[ { hasse = TransitiveReductionGraph @ g, p = First @ TopologicalSort @ g },
    { f = AssociationThread[ VertexList @ g, RandomInteger[ { -5, 5 }, VertexCount @ g ] ] },
    AllTrue[ DeleteCases[ VertexOutComponent[ g, { p } ], p ], q |->
      InfraMeasurement[ g, InfraIntegral[ f, integralChains[ p, q ] ], "ValueDensity" ] ===
        KeySort @ Counts[ Total @ Lookup[ f, # ] & /@ FindPath[ hasse, p, q, Infinity, All ] ] ] ] ],
  True,
  TestID -> "InfraIntegral-RandomDAGs-0-form-value-density-counts-both-ends"
]

VerificationTest[
  InfraMeasurement[ integralGrid, InfraIntegral[ integralF, InfraSegment[ 2, 24 ] ], "ValueDensity" ] ===
    KeySort @ Counts[ Total @ Lookup[ integralF, # ] & /@ RandomInfraSegment[ integralGrid, InfraSegment[ 2, 24 ], All ] ],
  True,
  TestID -> "InfraIntegral-GridGraph-segment-value-density-is-the-enumeration"
]

(* "Mean" reads the occupation densities, "Cardinality" the members: both agree with the value density *)
VerificationTest[
  SeedRandom[ 8 ];
  With[ { w = AssociationThread[ RandomChoice[ { DirectedEdge @@ #, DirectedEdge @@ Reverse @ # } ] & /@ ( List @@@ EdgeList @ integralGrid ), RandomInteger[ { -5, 5 }, EdgeCount @ integralGrid ] ] },
    AllTrue[ { InfraSegment[ 1, 19 ], InfraHalfLine[ 13, 14 ], InfraInfiniteLine[ 12, 13 ], InfraSegment[ 7, 7 ] }, obj |->
      AllTrue[ { integralF, w, 1 & }, form |->
        With[ { readings = InfraMeasurement[ integralGrid, InfraIntegral[ form, obj ], All ] },
          readings[ "Mean" ] == Total[ KeyValueMap[ Times, readings[ "ValueDensity" ] ] ] / readings[ "Cardinality" ] &&
          readings[ "Cardinality" ] == Total @ readings[ "ValueDensity" ] == InfraMeasurement[ integralGrid, obj, "Cardinality" ] ] ] ] ],
  True,
  TestID -> "InfraIntegral-GridGraph-Mean-and-Cardinality-agree-with-the-value-density"
]

VerificationTest[
  InfraMeasurement[ integralDiamond, InfraIntegral[ <| 1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7 |>, integralChains[ 1, 4 ] ], All ],
  <| "Value" -> { 12, 14 }, "ValueDensity" -> <| 12 -> 1, 14 -> 1 |>, "Mean" -> 13, "Cardinality" -> 2 |>,
  TestID -> "InfraIntegral-Diamond-foreign-head-readings"
]

(* ===== exactness: with one minimal element a 1-form is exact iff its chain integrals depend only on the end; with two it fails ===== *)

VerificationTest[
  SeedRandom[ 19 ];
  With[ { h = AssociationThread[ VertexList @ integralLattice, RandomInteger[ { -9, 9 }, VertexCount @ integralLattice ] ] },
    { w = InfraMeasurement[ integralLattice, InfraDifferential[ h ], "Function" ] },
    { potential = AssociationMap[ q |-> InfraMeasurement[ integralLattice, InfraIntegral[ w, integralChains[ { 0, 0 }, q ] ], "Value" ], VertexList @ integralLattice ] },
    { AllTrue[ potential, NumericQ ], InfraMeasurement[ integralLattice, InfraDifferential[ potential ], "Function" ] === w } ],
  { True, True },
  TestID -> "InfraIntegral-Lattice-path-independent-1-form-is-the-differential-of-its-integral"
]

VerificationTest[
  InfraMeasurement[ integralLattice, InfraIntegral[ <| DirectedEdge[ { 2, 2 }, { 3, 2 } ] -> 1 |>, integralChains[ { 2, 2 }, { 3, 3 } ] ], "ValueDensity" ],
  <| 0 -> 1, 1 -> 1 |>,
  TestID -> "InfraIntegral-Lattice-non-exact-1-form-is-path-dependent"
]

VerificationTest[
  With[ { crown = Graph[ { 1, 2, 3, 4 }, { 1 -> 3, 2 -> 3, 2 -> 4, 1 -> 4 } ] },
    { circulation = form |-> Total[ { 1, -1, 1, -1 } ( InfraMeasurement[ crown, InfraIntegral[ form, integralChains[ #1, #2 ] ], "Value" ] & @@@ { { 1, 3 }, { 2, 3 }, { 2, 4 }, { 1, 4 } } ) ] },
    { InfraMeasurement[ crown, InfraIntegral[ 0 &, integralChains[ #1, #2 ] ], "Cardinality" ] & @@@ { { 1, 3 }, { 2, 3 }, { 2, 4 }, { 1, 4 } },
      circulation @ <| DirectedEdge[ 1, 3 ] -> 1, DirectedEdge[ 2, 3 ] -> 0, DirectedEdge[ 2, 4 ] -> 0, DirectedEdge[ 1, 4 ] -> 0 |>,
      circulation @ InfraMeasurement[ crown, InfraDifferential[ <| 1 -> 4, 2 -> -1, 3 -> 6, 4 -> 2 |> ], "Function" ] } ],
  { { 1, 1, 1, 1 }, 1, 0 },
  TestID -> "InfraIntegral-Crown-path-independent-yet-not-exact"
]

(* ===== regions: the sum over the support; Gauss, the integral of the codifferential is the flux through the boundary ===== *)

VerificationTest[
  InfraMeasurement[ integralGrid, InfraIntegral[ integralF, InfraBall[ 13, 1 ] ], All ],
  <| "Value" -> 201, "ValueDensity" -> <| 201 -> 1 |>, "Mean" -> 201, "Cardinality" -> 1 |>,
  TestID -> "InfraIntegral-GridGraph-ball-readings"
]

VerificationTest[
  { InfraMeasurement[ integralGrid, InfraIntegral[ 1 &, InfraBall[ 13, 1 ] ], "Value" ],
    InfraMeasurement[ integralGrid, InfraIntegral[ 1 &, InfraShell[ 13, 2 ] ], "Value" ],
    InfraMeasurement[ integralGrid, InfraIntegral[ integralF, { 1, 2, 3 } ], "Value" ],
    InfraMeasurement[ integralGrid, InfraIntegral[ integralF, 25 ], "Value" ] },
  { 5, 8, 10, 97 },
  TestID -> "InfraIntegral-GridGraph-region-volumes-and-sums"
]

VerificationTest[
  SeedRandom[ 21 ];
  With[ { w = AssociationThread[ RandomChoice[ { DirectedEdge @@ #, DirectedEdge @@ Reverse @ # } ] & /@ ( List @@@ EdgeList @ integralGrid ), RandomInteger[ { -5, 5 }, EdgeCount @ integralGrid ] ] },
    AllTrue[ { InfraBall[ 13, 1 ], InfraShell[ 13, 2 ], InfraBall[ 1, 2 ], { 1, 2, 3, 9, 25 }, 7, InfraIntersection[ InfraBall[ 1, 3 ], InfraBall[ 25, 4 ] ] }, region |->
      InfraMeasurement[ integralGrid, InfraIntegral[ InfraCodifferential[ w ], region ], "Value" ] == InfraMeasurement[ integralGrid, InfraIntegral[ w, region ], "Flux" ] ] ],
  True,
  TestID -> "InfraIntegral-GridGraph-Gauss-on-regions"
]

VerificationTest[
  SeedRandom[ 23 ];
  AllTrue[ integralRandomDAGs, g |-> With[ { hasse = TransitiveReductionGraph @ g },
    { w = AssociationThread[ EdgeList @ hasse, RandomInteger[ { -3, 3 }, EdgeCount @ hasse ] ], region = RandomSample[ VertexList @ g, RandomInteger[ { 1, VertexCount @ g } ] ] },
    InfraMeasurement[ g, InfraIntegral[ InfraCodifferential[ w ], region ], "Value" ] == InfraMeasurement[ g, InfraIntegral[ w, region ], "Flux" ] ] ],
  True,
  TestID -> "InfraIntegral-RandomDAGs-Gauss-on-random-regions"
]

VerificationTest[
  InfraMeasurement[ integralGrid, InfraIntegral[ InfraDifferential[ integralF ], InfraBall[ 13, 1 ] ], All ],
  <| "Cardinality" -> 1, "Flux" -> -18 |>,
  TestID -> "InfraIntegral-GridGraph-1-form-over-a-region-has-a-flux-and-no-value"
]

(* an integrand head is read through its "Function" *)
VerificationTest[
  InfraMeasurement[ integralDiamond, InfraIntegral[ InfraAntiderivative[ <| 1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7 |>, Method -> "PathCount" ], integralChains[ 1, 4 ] ], All ] ===
    InfraMeasurement[ integralDiamond, InfraIntegral[ InfraMeasurement[ integralDiamond, InfraAntiderivative[ <| 1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7 |>, Method -> "PathCount" ], "Function" ], integralChains[ 1, 4 ] ], All ],
  True,
  TestID -> "InfraIntegral-Diamond-integrand-head"
]

(* ===== no member, no domain ===== *)

VerificationTest[
  With[ { g = Graph[ { 1, 2 }, { } ] },
    { InfraMeasurement[ g, InfraIntegral[ <| 1 -> 1 |>, InfraSegment[ 1, 2 ] ], All ], Head @ InfraMeasurement[ g, InfraIntegral[ <| 1 -> 1 |>, InfraSegment[ 1, 2 ] ], "Mean" ] } ],
  { <| "Value" -> { }, "ValueDensity" -> <| |>, "Cardinality" -> 0 |>, InfraMeasurement },
  TestID -> "InfraIntegral-disconnected-segment-has-no-member"
]

(* polylines, open polyline arcs, closed arcs and circles are not families of alternative walks on the substrate: they stay unevaluated *)
VerificationTest[
  Head @ InfraMeasurement[ integralGrid, InfraIntegral[ integralF, # ], All ] & /@
    { InfraSegment[ 1, 13, 25 ], InfraArc[ 13, { 8, 14, 18 }, "RadiusDelta" -> 1 ], InfraArc[ 13, { 8, 8 }, "RadiusDelta" -> 1 ], InfraCircle[ 13, { 1, 2 } ] },
  ConstantArray[ InfraMeasurement, 4 ],
  TestID -> "InfraIntegral-GridGraph-polylines-closed-arcs-and-circles-unevaluated"
]

VerificationTest[
  { Head @ InfraMeasurement[ integralGrid, InfraIntegral[ integralF, InfraSegment[ 1, 13 ] ], "Foo" ],
    Head @ InfraMeasurement[ integralGrid, InfraIntegral[ integralF, InfraSegment[ 1, 13 ] ], "Flux" ],
    Head @ InfraMeasurement[ integralGrid, InfraIntegral[ integralF, unknownHead[ 1 ] ], All ],
    Head @ InfraMeasurement[ integralGrid, InfraIntegral[ InfraAntiderivative[ integralF ], InfraBall[ 13, 1 ] ], "Value" ] },
  ConstantArray[ InfraMeasurement, 4 ],
  TestID -> "InfraIntegral-unknown-readings-domains-and-integrands-unevaluated"
]

(* the generic readings of InfraMeasurement need a "Graph" and stay unevaluated on an integral *)
VerificationTest[
  Join[
    Head @ InfraMeasurement[ integralGrid, InfraIntegral[ integralF, InfraSegment[ 1, 13 ] ], # ] & /@
      { "Graph", "Length", "VertexDensity", "EdgeDensity", "Subgraph", "Faithful", "CountingMeasure", "RiemannianMeasure" },
    { Head @ InfraMemberQ[ integralGrid, InfraIntegral[ integralF, InfraSegment[ 1, 13 ] ], { 1, 2, 3, 8, 13 } ] } ],
  Append[ ConstantArray[ InfraMeasurement, 8 ], InfraMemberQ ],
  TestID -> "InfraIntegral-generic-readings-unevaluated"
]

EndTestSection[]
