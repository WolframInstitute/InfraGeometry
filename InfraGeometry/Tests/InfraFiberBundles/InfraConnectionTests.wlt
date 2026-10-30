BeginTestSection[ "InfraConnection" ]

VerificationTest[
  InfraConnection[ x ],
  InfraConnection[ x ],
  TestID -> "InfraConnection-head-is-inert"
]

VerificationTest[
  { InfraConnectionQ[ unknown, InfraConnection[ { } ] ], RandomInfraConnection[ unknown ],
    InfraHorizontalLift[ unknown, InfraConnection[ { } ], 1, { 1 } ],
    InfraParallelTransport[ unknown, InfraConnection[ { } ], { 1 } ],
    InfraHolonomy[ unknown, InfraConnection[ { } ], { 1 } ] },
  { InfraConnectionQ[ unknown, InfraConnection[ { } ] ], RandomInfraConnection[ unknown ],
    InfraHorizontalLift[ unknown, InfraConnection[ { } ], 1, { 1 } ],
    InfraParallelTransport[ unknown, InfraConnection[ { } ], { 1 } ],
    InfraHolonomy[ unknown, InfraConnection[ { } ], { 1 } ] },
  TestID -> "InfraConnection-unsupported-context-stays-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CompleteGraph[ 4 ], <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    InfraConnectionQ[ fib, # ] & /@ {
      InfraConnection[ { UndirectedEdge[ 1, 3 ], UndirectedEdge[ 2, 4 ] } ],
      InfraConnection[ { UndirectedEdge[ 4, 2 ], UndirectedEdge[ 3, 1 ] } ],
      InfraConnection[ { } ],
      InfraConnection[ { UndirectedEdge[ 1, 3 ] } ],
      InfraConnection[ { UndirectedEdge[ 1, 3 ], UndirectedEdge[ 1, 4 ], UndirectedEdge[ 2, 4 ] } ],
      InfraConnection[ { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 3, 4 ] } ],
      InfraConnection[ { UndirectedEdge[ 1, 3 ], UndirectedEdge[ 3, 1 ], UndirectedEdge[ 2, 4 ] } ],
      InfraConnection[ { UndirectedEdge[ 1, 5 ] } ] } ],
  { True, True, False, False, False, False, False, False },
  TestID -> "InfraConnectionQ-perfect-matchings-over-whole-fibers"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ { 1, 2, 3, 4 }, { UndirectedEdge[ 1, 3 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { connection = InfraConnection[ { UndirectedEdge[ 1, 3 ] } ] },
    { InfraConnectionQ[ fib, connection ], RandomInfraConnection[ fib ], RandomInfraConnection[ fib, All ],
      Head @ InfraParallelTransport[ fib, connection, { "p", "q" } ] } ],
  { False, { }, { }, InfraParallelTransport },
  TestID -> "InfraConnection-isolated-fiber-vertices-obstruct-completeness"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 5 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4, 5 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q", 5 -> "q" |> ] },
    { RandomInfraConnection[ fib ], RandomInfraConnection[ fib, 1 ], RandomInfraConnection[ fib, UpTo[ 2 ] ],
      RandomInfraConnection[ fib, All ] } ],
  { { }, { }, { }, { } },
  TestID -> "RandomInfraConnection-unequal-neighboring-fibers"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ], UndirectedEdge @@@ { { 1, 4 }, { 2, 4 }, { 3, 5 }, { 3, 6 } } ],
      <| 1 -> "p", 2 -> "p", 3 -> "p", 4 -> "q", 5 -> "q", 6 -> "q" |> ] },
    { Min @ VertexDegree @ InfraTotalSpace @ fib, RandomInfraConnection[ fib, All ] } ],
  { 1, { } },
  TestID -> "RandomInfraConnection-Hall-obstruction-without-isolated-vertices"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { members = RandomInfraConnection[ fib, All ] },
    { Length @ members, DuplicateFreeQ @ members, InfraConnectionQ[ fib, members ],
      RandomInfraConnection[ fib, 2, "NextVertexFunction" -> Identity ] === members,
      RandomInfraConnection[ fib, 3 ], Length @ RandomInfraConnection[ fib, UpTo[ 3 ] ],
      RandomInfraConnection[ fib, 0 ], RandomInfraConnection[ fib, UpTo[ 0 ] ] } ],
  { 2, True, True, True, { }, 2, { }, { } },
  TestID -> "RandomInfraConnection-count-contract-on-two-matchings"
]

VerificationTest[
  BlockRandom[
    With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
        <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
      SeedRandom[ 318 ];
      With[ { first = RandomInfraConnection[ fib, RandomSeeding -> None ] },
        SeedRandom[ 318 ];
        { Head @ first, InfraConnectionQ[ fib, first ], first === RandomInfraConnection[ fib, Automatic, RandomSeeding -> None ] } ] ] ],
  { InfraConnection, True, True },
  TestID -> "RandomInfraConnection-single-shape-and-ambient-seed"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ { }, { } ], <| |> ] },
    { RandomInfraConnection[ fib ], RandomInfraConnection[ fib, All ], RandomInfraConnection[ fib, 2 ],
      RandomInfraConnection[ fib, UpTo[ 2 ] ], InfraConnectionQ[ fib, InfraConnection[ { } ] ],
      InfraConnectionQ[ fib, { InfraConnection[ { } ] } ], InfraConnectionQ[ fib, { } ],
      InfraTrivialMonodromyQ[ fib, InfraConnection[ { } ] ], InfraTrivialMonodromyQ[ fib, { } ] } ],
  { InfraConnection[ { } ], { InfraConnection[ { } ] }, { }, { InfraConnection[ { } ] }, True, True, False, True, False },
  TestID -> "RandomInfraConnection-unique-empty-connection-is-not-absence"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ { 1, 2, 3 }, { UndirectedEdge[ 1, 2 ] } ], <| 1 -> "p", 2 -> "p", 3 -> "q" |> ] },
    { RandomInfraConnection[ fib, All ], InfraConnectionQ[ fib, InfraConnection[ { } ] ],
      InfraParallelTransport[ fib, InfraConnection[ { } ], { "p" } ],
      InfraHolonomy[ fib, InfraConnection[ { } ], { "q" } ] } ],
  { { InfraConnection[ { } ] }, True, <| 1 -> 1, 2 -> 2 |>, Cycles[ { } ] },
  TestID -> "InfraConnection-isolated-base-fibers-need-no-horizontal-edges"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 6 ], UndirectedEdge @@@ Join[
        Tuples[ { { 1, 2 }, { 3, 4 } } ], Tuples[ { { 3, 4 }, { 5, 6 } } ] ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q", 5 -> "r", 6 -> "r" |> ] },
    { members = RandomInfraConnection[ fib, All ] },
    { Length @ members, DuplicateFreeQ @ members, InfraConnectionQ[ fib, members ], InfraTrivialMonodromyQ[ fib, members ] } ],
  { 4, True, True, True },
  TestID -> "RandomInfraConnection-independent-edge-matchings-multiply"
]

VerificationTest[
  BlockRandom[
    With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
        <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
      SeedRandom[ 792 ];
      With[ { reference = RandomInteger[ 10 ^ 9, 4 ] },
        SeedRandom[ 792 ];
        RandomInfraConnection[ fib, All, RandomSeeding -> None ];
        With[ { allQuiet = RandomInteger[ 10 ^ 9, 4 ] === reference },
          SeedRandom[ 792 ];
          RandomInfraConnection[ fib, "NextVertexFunction" -> Identity, RandomSeeding -> None ];
          { allQuiet, RandomInteger[ 10 ^ 9, 4 ] === reference } ] ] ] ],
  { True, True },
  TestID -> "RandomInfraConnection-All-and-Identity-do-not-draw"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { Sort @ RandomInfraConnection[ fib, All, "NextVertexFunction" -> Reverse ] === Sort @ RandomInfraConnection[ fib, All ],
      Length @ RandomInfraConnection[ fib, All, "NextVertexFunction" -> ( Take[ #, UpTo[ 1 ] ] & ) ],
      InfraConnectionQ[ fib, RandomInfraConnection[ fib, "NextVertexFunction" -> First ] ],
      RandomInfraConnection[ fib, 2, "NextVertexFunction" -> First ] } ],
  { True, 1, True, { } },
  TestID -> "RandomInfraConnection-ordering-and-pruned-search-tree"
]

VerificationTest[
  BlockRandom[
    SeedRandom[ 29 ];
    With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
        <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
      { InfraConnectionQ[ fib, RandomInfraConnection[ fib, "NextVertexFunction" -> RandomChoice, RandomSeeding -> None ] ],
        Length @ RandomInfraConnection[ fib, UpTo[ 3 ], "NextVertexFunction" -> RandomChoice, RandomSeeding -> None ],
        RandomInfraConnection[ fib, 2, "NextVertexFunction" -> RandomChoice, RandomSeeding -> None ],
        Head @ RandomInfraConnection[ fib, All, "NextVertexFunction" -> RandomChoice, RandomSeeding -> None ] } ] ],
  { True, 1, { }, RandomInfraConnection },
  TestID -> "RandomInfraConnection-RandomChoice-keeps-one-route"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { Head @ RandomInfraConnection[ fib, "UnknownOption" -> True ],
      Head @ RandomInfraConnection[ fib, "NextVertexFunction" -> "UnknownOrdering" ],
      Head @ RandomInfraConnection[ fib, "NextVertexFunction" -> ( "not-a-candidate" & ) ],
      Head @ RandomInfraConnection[ fib, "NextVertexFunction" -> ( Join[ #, # ] & ) ],
      Head @ RandomInfraConnection[ fib, -1 ], Quiet[ Head @ RandomInfraConnection[ fib, UpTo[ -1 ] ], UpTo::innf ] } ],
  ConstantArray[ RandomInfraConnection, 6 ],
  TestID -> "RandomInfraConnection-unsupported-options-counts-and-callbacks-stay-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ] },
    { Length @ RandomInfraConnection[ fib, All, "NextVertexFunction" -> Identity, "NextVertexFunction" -> RandomChoice ],
      Head @ RandomInfraConnection[ fib, All, "NextVertexFunction" -> RandomChoice, "NextVertexFunction" -> Identity ] } ],
  { 2, RandomInfraConnection },
  TestID -> "RandomInfraConnection-first-duplicate-option-wins"
]

VerificationTest[
  With[ { vertices = { { }, { 1 }, vertex[ 2 ], vertex[ 3 ] },
      projection = <| { } -> { "p" }, { 1 } -> { "p" }, vertex[ 2 ] -> base[ "q" ], vertex[ 3 ] -> base[ "q" ] |> },
    { fib = InfraFiberedGraph[ Graph[ vertices,
        UndirectedEdge @@@ Tuples[ { Take[ vertices, 2 ], Drop[ vertices, 2 ] } ] ], projection ] },
    { connection = RandomInfraConnection[ fib, "NextVertexFunction" -> First ] },
    { Length @ RandomInfraConnection[ fib, All ], InfraConnectionQ[ fib, connection ],
      InfraParallelTransport[ fib, connection, { { "p" }, base[ "q" ] } ],
      InfraHorizontalLift[ fib, connection, { }, { { "p" }, base[ "q" ], { "p" } } ] } ],
  { 2, True, <| { } -> vertex[ 2 ], { 1 } -> vertex[ 3 ] |>, { { }, vertex[ 2 ], { } } },
  TestID -> "InfraConnection-literal-list-and-expression-labels"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ { { 1 }, { 2 }, { 3 }, { 4 } },
      UndirectedEdge @@@ Tuples[ { { { 1 }, { 2 } }, { { 3 }, { 4 } } } ] ],
      <| { 1 } -> "p", { 2 } -> "p", { 3 } -> "q", { 4 } -> "q" |> ] },
    { connection = RandomInfraConnection[ fib, "NextVertexFunction" -> First ] },
    { InfraConnectionQ[ fib, connection ], InfraHorizontalLift[ fib, connection, { 1 }, { "p", "q" } ] } ],
  { True, { { 1 }, { 3 } } },
  TestID -> "RandomInfraConnection-callback-list-vertex-is-one-candidate"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 8 ] ] },
    { InfraHorizontalLift[ fib, connection, 1, { 1, 2, 3, 4, 1 } ],
      InfraHorizontalLift[ fib, connection, 1, { 1, 2, 1, 2 } ],
      InfraHorizontalLift[ fib, connection, 1, { 1 } ],
      InfraParallelTransport[ fib, connection, { 1, 2, 3, 4, 1 } ] } ],
  { { 1, 2, 3, 4, 5 }, { 1, 2, 1, 2 }, { 1 }, <| 1 -> 5, 5 -> 1 |> },
  TestID -> "InfraHorizontalLift-preserves-walk-order-and-repeated-visits"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 8 ] ] },
    { firstWalk = { 1, 2, 3 }, secondWalk = { 3, 4, 1 } },
    { firstTransport = InfraParallelTransport[ fib, connection, firstWalk ],
      secondTransport = InfraParallelTransport[ fib, connection, secondWalk ],
      joined = InfraParallelTransport[ fib, connection, Join[ firstWalk, Rest @ secondWalk ] ],
      reversed = InfraParallelTransport[ fib, connection, Reverse @ firstWalk ] },
    { And @@ KeyValueMap[ { source, target } |-> Lookup[ joined, Key @ source ] === Lookup[ secondTransport, Key @ target ],
        firstTransport ],
      And @@ KeyValueMap[ { source, target } |-> Lookup[ reversed, Key @ target ] === source, firstTransport ],
      InfraParallelTransport[ fib, connection, { 1 } ] } ],
  { True, True, <| 1 -> 1, 5 -> 5 |> },
  TestID -> "InfraParallelTransport-identity-composition-and-inverse-laws"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 8 ] ] },
    { Head @ InfraHorizontalLift[ fib, connection, 2, { 1, 2 } ],
      Head @ InfraHorizontalLift[ fib, connection, 1, { 1, 3 } ],
      Head @ InfraHorizontalLift[ fib, connection, 1, { } ],
      Head @ InfraParallelTransport[ fib, connection, { 1, 3 } ],
      Head @ InfraParallelTransport[ fib, connection, { } ],
      Head @ InfraHolonomy[ fib, connection, { 1, 2, 3 } ],
      Head @ InfraParallelTransport[ fib, InfraConnection[ { } ], { 1 } ] } ],
  { InfraHorizontalLift, InfraHorizontalLift, InfraHorizontalLift, InfraParallelTransport, InfraParallelTransport,
    InfraHolonomy, InfraParallelTransport },
  TestID -> "InfraConnection-readers-reject-invalid-walks-starts-and-incomplete-connections"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CompleteGraph[ 4 ], <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ],
      connection = InfraConnection[ UndirectedEdge @@@ Tuples[ { { 1, 2 }, { 3, 4 } } ] ] },
    { InfraConnectionQ[ fib, connection ],
      Head @ InfraHorizontalLift[ fib, connection, 1, { "p", "q" } ],
      Head @ InfraParallelTransport[ fib, connection, { "p", "q" } ],
      Head @ InfraHolonomy[ fib, connection, { "p", "q", "p" } ] } ],
  { False, InfraHorizontalLift, InfraParallelTransport, InfraHolonomy },
  TestID -> "InfraConnection-readers-never-select-an-ambiguous-lift"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 8 ] ] },
    { InfraHolonomy[ fib, connection, { 1, 2, 3, 4, 1 } ], InfraHolonomy[ fib, connection, { 1, 2, 1 } ],
      InfraHolonomy[ fib, connection, { 1 } ], InfraTrivialMonodromyQ[ fib, connection ] } ],
  { Cycles[ { { 1, 2 } } ], Cycles[ { } ], Cycles[ { } ], False },
  TestID -> "InfraHolonomy-twisted-double-cover-and-identity-walk"
]

VerificationTest[
  With[ { total = Graph[ { 1, 7, 4, 2, 3, 5, 6, 8, 9 }, EdgeList @ CycleGraph[ 9 ] ] },
    { fib = InfraFiberedGraph[ total, vertex |-> Mod[ vertex, 3, 1 ] ], connection = InfraConnection[ EdgeList @ total ] },
    { VertexList @ InfraFiber[ fib, 1 ], PermutationList[ InfraHolonomy[ fib, connection, { 1, 2, 3, 1 } ], 3 ] } ],
  { { 1, 7, 4 }, { 3, 1, 2 } },
  TestID -> "InfraHolonomy-indexes-in-the-declared-fiber-vertex-order"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ GraphProduct[ CompleteGraph[ 3 ], CycleGraph[ 4 ], "Cartesian" ], Last ] },
    { connection = RandomInfraConnection[ fib, "NextVertexFunction" -> Identity ] },
    { InfraConnectionQ[ fib, connection ], InfraHolonomy[ fib, connection, { 1, 2, 3, 4, 1 } ],
      InfraTrivialMonodromyQ[ fib, connection ] } ],
  { True, Cycles[ { } ], True },
  TestID -> "InfraTrivialMonodromyQ-product-bundle-has-trivial-global-monodromy"
]

VerificationTest[
  With[ { total = Graph[ Range[ 12 ], Join[ EdgeList @ CycleGraph[ 8 ], UndirectedEdge @@@ { { 9, 10 }, { 10, 11 }, { 11, 12 } } ] ] },
    { fib = InfraFiberedGraph[ total, <| 1 -> 1, 2 -> 2, 3 -> 3, 4 -> 4, 5 -> 1, 6 -> 2, 7 -> 3, 8 -> 4,
        9 -> "p", 10 -> "q", 11 -> "p", 12 -> "q" |> ],
      connection = InfraConnection[ Join[ EdgeList @ CycleGraph[ 8 ], { UndirectedEdge[ 9, 10 ], UndirectedEdge[ 11, 12 ] } ] ] },
    { InfraConnectionQ[ fib, connection ], InfraTrivialMonodromyQ[ fib, connection ] } ],
  { True, False },
  TestID -> "InfraTrivialMonodromyQ-checks-all-disconnected-base-components"
]

VerificationTest[
  BlockRandom[
    With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ],
        connection = InfraConnection[ EdgeList @ CycleGraph[ 8 ] ] },
      SeedRandom[ 628 ];
      With[ { reference = RandomInteger[ 10 ^ 9, 4 ] },
        SeedRandom[ 628 ];
        InfraHorizontalLift[ fib, connection, 1, { 1, 2, 3, 4, 1 } ];
        InfraParallelTransport[ fib, connection, { 1, 2, 3, 4, 1 } ];
        InfraHolonomy[ fib, connection, { 1, 2, 3, 4, 1 } ];
        InfraTrivialMonodromyQ[ fib, connection ];
        RandomInteger[ 10 ^ 9, 4 ] === reference ] ] ],
  True,
  TestID -> "InfraConnection-readers-consume-no-random-draws"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ { }, { } ], <| |> ] },
    { InfraConnectionQ[ fib, { InfraConnection[ { } ], unknown } ],
      InfraTrivialMonodromyQ[ fib, { InfraConnection[ { } ], unknown } ] } ],
  With[ { fib = InfraFiberedGraph[ Graph[ { }, { } ], <| |> ] },
    { InfraConnectionQ[ fib, unknown ], InfraTrivialMonodromyQ[ fib, unknown ] } ],
  TestID -> "InfraConnectionQ-collection-does-not-turn-undecided-members-into-False"
]

VerificationTest[
  With[ { projection = <| 1 -> "p", 2 -> "q" |> },
    Map[ graph |-> With[ { fib = InfraFiberedGraph[ graph, projection ] },
      { Head @ RandomInfraConnection[ fib ], Head @ InfraConnectionQ[ fib, InfraConnection[ { } ] ] } ], {
      Graph[ { 1, 2 }, { DirectedEdge[ 1, 2 ] } ],
      Graph[ { 1, 2 }, { UndirectedEdge[ 1, 2 ] }, EdgeWeight -> { 2 } ],
      Graph[ { 1, 2 }, { UndirectedEdge[ 1, 2 ], UndirectedEdge[ 1, 2 ] } ] } ] ],
  ConstantArray[ { RandomInfraConnection, InfraConnectionQ }, 3 ],
  TestID -> "InfraConnection-unsupported-graph-domains-stay-unevaluated"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 6 ], vertex |-> Mod[ vertex, 3, 1 ] ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 6 ] ] },
    { first = InfraParallelTransport[ fib, connection, { 1, 2 } ],
      second = InfraParallelTransport[ fib, connection, { 2, 3 } ],
      joined = InfraParallelTransport[ fib, connection, { 1, 2, 3 } ],
      reverse = InfraParallelTransport[ fib, connection, { 3, 2, 1 } ] },
    { InfraConnectionQ[ fib, connection ], InfraParallelTransport[ fib, connection, { 1 } ],
      And @@ KeyValueMap[ { source, target } |-> Lookup[ joined, Key @ source ] === Lookup[ second, Key @ target ], first ],
      And @@ KeyValueMap[ { source, target } |-> Lookup[ reverse, Key @ target ] === source, joined ],
      InfraHorizontalLift[ fib, connection, 1, { 1, 2, 3, 1 } ],
      InfraHolonomy[ fib, connection, { 1, 2, 3, 1 } ], InfraTrivialMonodromyQ[ fib, connection ] } ],
  { True, <| 1 -> 1, 4 -> 4 |>, True, True, { 1, 2, 3, 4 }, Cycles[ { { 1, 2 } } ], False },
  TestID -> "InfraConnection-general-fibered-graph-transport-and-holonomy-laws"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ Graph[ Range[ 4 ], { UndirectedEdge[ 1, 3 ] } ],
      <| 1 -> "p", 2 -> "p", 3 -> "q", 4 -> "q" |> ],
      connection = InfraConnection[ { UndirectedEdge[ 1, 3 ] } ] },
    { InfraConnectionQ[ fib, connection ], RandomInfraConnection[ fib, All ],
      Head @ InfraHorizontalLift[ fib, connection, 1, { "p", "q" } ],
      Head @ InfraParallelTransport[ fib, connection, { "p", "q" } ] } ],
  { False, { }, InfraHorizontalLift, InfraParallelTransport },
  TestID -> "InfraConnection-general-fibered-graph-still-requires-complete-matchings"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ CycleGraph[ 8 ], vertex |-> Mod[ vertex, 4, 1 ] ],
      connection = InfraConnection[ EdgeList @ CycleGraph[ 8 ] ] },
    { InfraTrivialMonodromyQ[ fib, connection ], InfraTrivialMonodromyQ[ fib, InfraConnection[ { } ] ], InfraTrivialMonodromyQ[ fib, { } ] } ],
  { False, False, False },
  TestID -> "InfraTrivialMonodromyQ-negative-cases"
]

VerificationTest[
  With[ { fib = InfraFiberedGraph[ GraphProduct[ CompleteGraph[ 2 ], CycleGraph[ 4 ], "Cartesian" ], Last ] },
    { connection = RandomInfraConnection[ fib, "NextVertexFunction" -> Identity, RandomSeeding -> 7 ] },
    { InfraTrivialMonodromyQ[ fib, connection ], InfraTrivialMonodromyQ[ fib, { connection, connection } ] } ],
  { True, True },
  TestID -> "InfraTrivialMonodromyQ-positive-and-list-cases"
]

VerificationTest[
  InfraTrivialMonodromyQ[ unknown, InfraConnection[ { } ] ],
  InfraTrivialMonodromyQ[ unknown, InfraConnection[ { } ] ],
  TestID -> "InfraTrivialMonodromyQ-leaves-unsupported-contexts-unevaluated"
]

EndTestSection[ ]
