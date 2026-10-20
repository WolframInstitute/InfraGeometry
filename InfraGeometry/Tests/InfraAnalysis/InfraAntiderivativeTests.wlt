BeginTestSection["InfraAntiderivative"]

(* ===== InfraAntiderivative, InfraDerivative: F(v) = Sum over u <= v of f(u) K(u, v), and its exact inverse ===== *)

antiderivativeDiamond = Graph[ { 1, 2, 3, 4 }, { 1 -> 2, 1 -> 3, 2 -> 4, 3 -> 4 } ]

antiderivativeDiamondF = <| 1 -> 2, 2 -> 3, 3 -> 5, 4 -> 7 |>

antiderivativeImplied = Graph[ Range[ 6 ], { 1 -> 2, 2 -> 3, 1 -> 3, 1 -> 4, 4 -> 5, 3 -> 5, 2 -> 6, 5 -> 6, 1 -> 6, 1 -> 5 } ]

antiderivativeF = <| 1 -> 5, 2 -> -2, 3 -> 7, 4 -> 1, 5 -> 3, 6 -> -4 |>

antiderivativeMethods = { "Volume", "Paths", "Average", "Uniform", "Flow" }

antiderivativeRandomDAGs = ( SeedRandom[ 7 ];
  Table[ With[ { n = RandomInteger[ { 4, 8 } ] },
      Graph[ Range[ n ], DirectedEdge @@@ ( Sort /@ RandomSample[ Subsets[ Range[ n ], { 2 } ], RandomInteger[ { 3, Min[ 12, n ( n - 1 ) / 2 ] } ] ] ) ] ],
    30 ] )

antiderivativeRandomForms = ( SeedRandom[ 3 ]; AssociationThread[ VertexList @ #, RandomInteger[ { -5, 5 }, VertexCount @ # ] ] & /@ antiderivativeRandomDAGs )

VerificationTest[
  InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ antiderivativeDiamondF ], "Function" ],
  <| 1 -> 2, 2 -> 5, 3 -> 7, 4 -> 17 |>,
  TestID -> "InfraAntiderivative-Diamond-Volume-sums-the-past"
]

(* "Paths" counts each u once per chain from u to v: the two chains from the bottom reach the top *)
VerificationTest[
  InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ antiderivativeDiamondF, Method -> "Paths" ], "Function" ] -
    InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ antiderivativeDiamondF ], "Function" ],
  <| 1 -> 0, 2 -> 0, 3 -> 0, 4 -> 2 |>,
  TestID -> "InfraAntiderivative-Diamond-Paths-minus-Volume-is-f-of-the-bottom"
]

(* the minimal non-local case: mu(a, d) = 1 on the diamond, so the Moebius derivative reaches past the links, by f(a) *)
VerificationTest[
  InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ antiderivativeDiamondF ], "Kernel" ],
  <| { 1, 1 } -> 1, { 1, 2 } -> -1, { 1, 3 } -> -1, { 1, 4 } -> 1, { 2, 2 } -> 1, { 2, 4 } -> -1, { 3, 3 } -> 1, { 3, 4 } -> -1, { 4, 4 } -> 1 |>,
  TestID -> "InfraDerivative-Diamond-Moebius-kernel"
]

VerificationTest[
  InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ antiderivativeDiamondF ], "Function" ] -
    InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ antiderivativeDiamondF, Method -> "Paths" ], "Function" ],
  <| 1 -> 0, 2 -> 0, 3 -> 0, 4 -> 2 |>,
  TestID -> "InfraDerivative-Diamond-Volume-minus-Paths-is-f-of-the-bottom"
]

VerificationTest[
  InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ antiderivativeDiamondF, Method -> "Uniform" ], "Kernel" ],
  <| { 1, 1 } -> 1, { 1, 2 } -> 1, { 1, 3 } -> 1, { 1, 4 } -> 1, { 2, 2 } -> 1, { 2, 4 } -> 1/2, { 3, 3 } -> 1, { 3, 4 } -> 1/2, { 4, 4 } -> 1 |>,
  TestID -> "InfraAntiderivative-Diamond-Uniform-kernel-is-exact"
]

VerificationTest[
  Keys @ InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ antiderivativeDiamondF, Method -> "Average" ], All ],
  { "Function", "Kernel" },
  TestID -> "InfraAntiderivative-Diamond-All"
]

(* D_K = K^-1: the two "Kernel" readings are inverse matrices for every method *)
VerificationTest[
  AllTrue[ Append[ antiderivativeMethods, { "Weights", <| DirectedEdge[ 1, 2 ] -> 3, DirectedEdge[ 3, 4 ] -> -2 |> } ], m |->
    With[ { k = InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ antiderivativeDiamondF, Method -> m ], "Kernel" ],
            inverse = InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ antiderivativeDiamondF, Method -> m ], "Kernel" ] },
      Table[ Sum[ Lookup[ k, Key @ { u, w }, 0 ] Lookup[ inverse, Key @ { w, v }, 0 ], { w, 4 } ], { u, 4 }, { v, 4 } ] === IdentityMatrix[ 4 ] ] ],
  True,
  TestID -> "InfraDerivative-Diamond-kernel-inverts-the-antiderivative-kernel"
]

(* D(I f) = f and I(D f) = f, exactly, for every method; the integrand head is read through its "Function" *)
VerificationTest[
  AllTrue[ Transpose[ { Join[ { antiderivativeDiamond, antiderivativeImplied }, antiderivativeRandomDAGs ], Join[ { antiderivativeDiamondF, antiderivativeF }, antiderivativeRandomForms ] } ],
    Apply[ { g, f } |->
      With[ { weights = AssociationThread[ EdgeList @ TransitiveReductionGraph @ g, Range[ EdgeCount @ TransitiveReductionGraph @ g ] - 2 ] },
        AllTrue[ Append[ antiderivativeMethods, { "Weights", weights } ], m |->
          InfraMeasurement[ g, InfraDerivative[ InfraAntiderivative[ f, Method -> m ], Method -> m ], "Function" ] === f &&
          InfraMeasurement[ g, InfraAntiderivative[ InfraDerivative[ f, Method -> m ], Method -> m ], "Function" ] === f ] ] ] ],
  True,
  TestID -> "InfraDerivative-RandomDAGs-inverts-every-method-in-both-orders"
]

(* the order, not its encoding: the transitive closure gives the same readings for both heads and every method *)
VerificationTest[
  AllTrue[ antiderivativeMethods, m |->
    InfraMeasurement[ antiderivativeImplied, InfraAntiderivative[ antiderivativeF, Method -> m ], All ] ===
      InfraMeasurement[ TransitiveClosureGraph @ antiderivativeImplied, InfraAntiderivative[ antiderivativeF, Method -> m ], All ] &&
    InfraMeasurement[ antiderivativeImplied, InfraDerivative[ antiderivativeF, Method -> m ], All ] ===
      InfraMeasurement[ TransitiveClosureGraph @ antiderivativeImplied, InfraDerivative[ antiderivativeF, Method -> m ], All ] ],
  True,
  TestID -> "InfraAntiderivative-ImpliedEdgesDAG-order-invariance"
]

(* K = (1 - W)^-1 for link weights W: the derivative is F(v) - Sum over links u -> v of W(u, v) F(u), supported on the diagonal and the links *)
VerificationTest[
  With[ { links = List @@@ EdgeList @ TransitiveReductionGraph @ antiderivativeImplied },
    AllTrue[ Rest @ antiderivativeMethods, m |->
      AllTrue[ Keys @ InfraMeasurement[ antiderivativeImplied, InfraDerivative[ antiderivativeF, Method -> m ], "Kernel" ],
        pair |-> SameQ @@ pair || MemberQ[ links, pair ] ] ] ],
  True,
  TestID -> "InfraDerivative-ImpliedEdgesDAG-path-methods-are-link-local"
]

(* the Moebius derivative is local iff every interval is a chain, iff no two chains share their ends *)
VerificationTest[
  KeySort @ Counts @ Map[
    g |-> With[ { links = List @@@ EdgeList @ TransitiveReductionGraph @ g },
      { AllTrue[ Keys @ InfraMeasurement[ g, InfraDerivative[ 0 & ], "Kernel" ], pair |-> SameQ @@ pair || MemberQ[ links, pair ] ],
        Max @ Values @ InfraMeasurement[ g, InfraAntiderivative[ 0 &, Method -> "Paths" ], "Kernel" ] <= 1 } ],
    antiderivativeRandomDAGs ],
  <| { False, False } -> 4, { True, True } -> 26 |>,
  TestID -> "InfraDerivative-RandomDAGs-Moebius-local-iff-every-interval-is-a-chain"
]

(* on the Z^2 product order the Moebius derivative is the mixed second difference, the wave operator in null coordinates *)
VerificationTest[
  With[ { lattice = Graph[ Flatten[ Table[ { i, j }, { i, 0, 4 }, { j, 0, 4 } ], 1 ],
            Flatten @ Table[ { If[ i < 4, DirectedEdge[ { i, j }, { i + 1, j } ], Nothing ], If[ j < 4, DirectedEdge[ { i, j }, { i, j + 1 } ], Nothing ] }, { i, 0, 4 }, { j, 0, 4 } ] ] },
    { F = AssociationMap[ p |-> Prime[ 1 + 5 First @ p + Last @ p ], VertexList @ lattice ] },
    InfraMeasurement[ lattice, InfraDerivative[ F ], "Function" ] ===
      AssociationMap[ p |-> Lookup[ F, Key @ p, 0 ] - Lookup[ F, Key[ p - { 1, 0 } ], 0 ] - Lookup[ F, Key[ p - { 0, 1 } ], 0 ] + Lookup[ F, Key[ p - { 1, 1 } ], 0 ],
        VertexList @ lattice ] ],
  True,
  TestID -> "InfraDerivative-Lattice-Moebius-is-the-mixed-second-difference"
]

(* P. Hall: the Moebius derivative of 1 is 1 - chi of the order complex of the strict past *)
VerificationTest[
  AllTrue[ Prepend[ antiderivativeRandomDAGs, Graph[ Range[ 5 ], { 1 -> 3, 1 -> 4, 2 -> 3, 2 -> 4, 3 -> 5, 4 -> 5 } ] ],
    g |-> With[ { comparable = { a, b } |-> MemberQ[ VertexOutComponent[ g, { a } ], b ] || MemberQ[ VertexOutComponent[ g, { b } ], a ] },
      { euler = past |-> Total[ ( -1 ) ^ ( Length[ # ] - 1 ) & /@ Select[ Rest @ Subsets[ past ], chain |-> AllTrue[ Subsets[ chain, { 2 } ], pair |-> comparable @@ pair ] ] ] },
      InfraMeasurement[ g, InfraDerivative[ 1 & ], "Function" ] === AssociationMap[ v |-> 1 - euler @ DeleteCases[ VertexInComponent[ g, { v } ], v ], VertexList @ g ] ] ],
  True,
  TestID -> "InfraDerivative-RandomDAGs-Hall-Euler-characteristic"
]

VerificationTest[
  InfraMeasurement[ Graph[ Range[ 5 ], { 1 -> 3, 1 -> 4, 2 -> 3, 2 -> 4, 3 -> 5, 4 -> 5 } ], InfraDerivative[ 1 & ], "Function" ],
  <| 1 -> 1, 2 -> 1, 3 -> -1, 4 -> -1, 5 -> 1 |>,
  TestID -> "InfraDerivative-CrownWithTop-Hall-values"
]

(* "Flow" splits the mass of each vertex evenly over its out-links, so the sinks receive all of it *)
VerificationTest[
  AllTrue[ Transpose[ { antiderivativeRandomDAGs, antiderivativeRandomForms } ],
    Apply[ { g, f } |-> Total @ Lookup[ InfraMeasurement[ g, InfraAntiderivative[ f, Method -> "Flow" ], "Function" ], Pick[ VertexList @ g, VertexOutDegree @ g, 0 ] ] == Total @ f ] ],
  True,
  TestID -> "InfraAntiderivative-RandomDAGs-Flow-conserves-mass-at-the-sinks"
]

(* "Average" and "Uniform" kill constants off the sources: D 1 is the indicator of the minimal elements *)
VerificationTest[
  AllTrue[ antiderivativeRandomDAGs, g |-> AllTrue[ { "Average", "Uniform" }, m |->
    InfraMeasurement[ g, InfraDerivative[ 1 &, Method -> m ], "Function" ] === AssociationThread[ VertexList @ g, Boole @ Thread[ VertexInDegree @ g == 0 ] ] ] ],
  True,
  TestID -> "InfraDerivative-RandomDAGs-Average-and-Uniform-kill-constants"
]

(* "Uniform" is the mean of the integral of f over all chains from the sources, each chain counting both ends *)
VerificationTest[
  AllTrue[ Transpose[ { antiderivativeRandomDAGs, antiderivativeRandomForms } ],
    Apply[ { g, f } |-> With[ { hasse = TransitiveReductionGraph @ g },
      { sources = Pick[ VertexList @ hasse, VertexInDegree @ hasse, 0 ] },
      InfraMeasurement[ g, InfraAntiderivative[ f, Method -> "Uniform" ], "Function" ] ===
        AssociationMap[ v |-> If[ MemberQ[ sources, v ], f[ v ],
            Mean[ Total[ Lookup[ f, # ] ] & /@ Catenate[ FindPath[ hasse, #, v, Infinity, All ] & /@ sources ] ] ],
          VertexList @ g ] ] ] ],
  True,
  TestID -> "InfraAntiderivative-RandomDAGs-Uniform-is-the-mean-over-maximal-chains"
]

VerificationTest[
  InfraMeasurement[ antiderivativeImplied, InfraAntiderivative[ antiderivativeF, Method -> { "Weights", AssociationThread[ EdgeList @ TransitiveReductionGraph @ antiderivativeImplied, 1 ] } ], "Function" ] ===
    InfraMeasurement[ antiderivativeImplied, InfraAntiderivative[ antiderivativeF, Method -> "Paths" ], "Function" ],
  True,
  TestID -> "InfraAntiderivative-ImpliedEdgesDAG-unit-weights-are-Paths"
]

VerificationTest[
  AllTrue[ antiderivativeMethods, m |->
    InfraMeasurement[ antiderivativeImplied, InfraAntiderivative[ antiderivativeF, Method -> m, "Direction" -> "Future" ], "Function" ] ===
      InfraMeasurement[ ReverseGraph @ antiderivativeImplied, InfraAntiderivative[ antiderivativeF, Method -> m ], "Function" ] &&
    InfraMeasurement[ antiderivativeImplied, InfraDerivative[ antiderivativeF, Method -> m, "Direction" -> "Future" ], "Function" ] ===
      InfraMeasurement[ ReverseGraph @ antiderivativeImplied, InfraDerivative[ antiderivativeF, Method -> m ], "Function" ] ],
  True,
  TestID -> "InfraAntiderivative-ImpliedEdgesDAG-Future-is-time-reversal"
]

(* blow up each vertex into n copies and each link into K_(n, n): "Average" and "Flow" commute with it, "Uniform" on a graded order only,
   "Volume" and "Paths" not at all *)
VerificationTest[
  With[ { blowUp = { g, n } |-> Graph[ Flatten[ Table[ { v, i }, { v, VertexList @ g }, { i, n } ], 1 ],
            Flatten @ Table[ DirectedEdge[ { First @ e, i }, { Last @ e, j } ], { e, EdgeList @ TransitiveReductionGraph @ g }, { i, n }, { j, n } ] ] },
    { commutesQ = { g, n, m, f } |-> With[ { big = blowUp[ g, n ] },
        AssociationMap[ v |-> Sum[ InfraMeasurement[ big, InfraAntiderivative[ Association @ Flatten @ Table[ { w, i } -> f[ w ] / n, { w, VertexList @ g }, { i, n } ], Method -> m ], "Function" ][ { v, i } ], { i, n } ],
          VertexList @ g ] === InfraMeasurement[ g, InfraAntiderivative[ f, Method -> m ], "Function" ] ] },
    { blowF = <| 1 -> 2, 2 -> -1, 3 -> 5, 4 -> 3 |> },
    Table[ { commutesQ[ antiderivativeDiamond, 2, method, blowF ], commutesQ[ antiderivativeDiamond, 3, method, blowF ],
        commutesQ[ Graph[ { 1, 2, 3, 4 }, { 1 -> 2, 2 -> 4, 3 -> 4 } ], 2, method, blowF ] },
      { method, antiderivativeMethods } ] ],
  { { False, False, False }, { False, False, False }, { True, True, True }, { True, True, False }, { True, True, True } },
  TestID -> "InfraAntiderivative-BlowUp-Average-Flow-commute-Uniform-on-graded-orders"
]

(* the spray order from c on an undirected substrate: u <= v iff d(c, u) + d(u, v) == d(c, v), its intervals the segments *)
VerificationTest[
  With[ { spray = SprayGraph[ GridGraph[ { 5, 5 } ], 7 ] }, EdgeCount @ spray == EdgeCount @ TransitiveReductionGraph @ spray ],
  True,
  TestID -> "InfraAntiderivative-GridGraph-spray-graph-is-its-own-Hasse-diagram"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], f = AssociationThread[ Range[ 25 ], Prime /@ Range[ 25 ] ] },
    { uniform = InfraMeasurement[ g, InfraAntiderivative[ f, Method -> "Uniform", "Origin" -> 7 ], "Function" ] },
    AllTrue[ Range[ 25 ], v |-> uniform[ v ] == InfraMeasurement[ g, InfraIntegral[ f, InfraSegment[ 7, v ] ], "Mean" ] ] ],
  True,
  TestID -> "InfraAntiderivative-GridGraph-spray-Uniform-is-the-mean-along-the-segment"
]

VerificationTest[
  With[ { g = GridGraph[ { 5, 5 } ], f = AssociationThread[ Range[ 25 ], Prime /@ Range[ 25 ] ] },
    { volume = InfraMeasurement[ g, InfraAntiderivative[ f, "Origin" -> 7 ], "Function" ] },
    AllTrue[ Range[ 25 ], v |-> volume[ v ] == InfraMeasurement[ g, InfraIntegral[ f, InfraMeasurement[ g, InfraSegment[ 7, v ], "VertexDensity" ] ], "Value" ] ] ],
  True,
  TestID -> "InfraAntiderivative-GridGraph-spray-Volume-is-the-sum-over-the-segment-support"
]

VerificationTest[
  SeedRandom[ 5 ];
  With[ { g = InfraSubstrate[ "HexagonalTilingGraph", "Small" ] },
    { c = First @ GraphCenter @ g, f = AssociationThread[ VertexList @ g, RandomInteger[ { -9, 9 }, VertexCount @ g ] ] },
    { uniform = InfraMeasurement[ g, InfraAntiderivative[ f, Method -> "Uniform", "Origin" -> c ], "Function" ] },
    AllTrue[ VertexList @ g, v |-> uniform[ v ] == InfraMeasurement[ g, InfraIntegral[ f, InfraSegment[ c, v ] ], "Mean" ] ] ],
  True,
  TestID -> "InfraAntiderivative-HexagonalTiling-spray-Uniform-is-the-mean-along-the-segment"
]

VerificationTest[
  With[ { g = GridGraph[ { 4, 4 } ], f = AssociationThread[ Range[ 16 ], Prime /@ Range[ 16 ] ] },
    AllTrue[ Append[ antiderivativeMethods, { "Weights", <| DirectedEdge[ 6, 7 ] -> 2 |> } ], m |->
      InfraMeasurement[ g, InfraDerivative[ InfraAntiderivative[ f, Method -> m, "Origin" -> 6 ], Method -> m, "Origin" -> 6 ], "Function" ] === f ] ],
  True,
  TestID -> "InfraDerivative-GridGraph-spray-inverts-every-method"
]

(* without an origin an undirected substrate has no order; a DAG takes none; unknown methods, options and readings stay unevaluated *)
VerificationTest[
  { Head @ InfraMeasurement[ GridGraph[ { 3, 3 } ], InfraAntiderivative[ #^2 & ], "Function" ],
    Head @ InfraMeasurement[ GridGraph[ { 3, 3 } ], InfraAntiderivative[ #^2 & ], All ],
    Head @ InfraMeasurement[ GridGraph[ { 3, 3 } ], InfraAntiderivative[ #^2 &, "Origin" -> 10 ], "Function" ],
    Head @ InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ #^2 &, "Origin" -> 1 ], "Function" ],
    Head @ InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ #^2 &, Method -> "Foo" ], "Function" ],
    Head @ InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ #^2 &, "Foo" -> 1 ], "Function" ],
    Head @ InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ #^2 &, "Direction" -> "Sideways" ], "Kernel" ],
    Head @ InfraMeasurement[ Graph[ { 1 -> 2, 2 -> 1 } ], InfraAntiderivative[ #^2 & ], "Function" ],
    Head @ InfraMeasurement[ antiderivativeDiamond, InfraAntiderivative[ #^2 & ], "Cardinality" ],
    Head @ InfraMeasurement[ antiderivativeDiamond, InfraDerivative[ #^2 & ], "Subgraph" ] },
  ConstantArray[ InfraMeasurement, 10 ],
  TestID -> "InfraAntiderivative-unsupported-input-unevaluated"
]

EndTestSection[]
