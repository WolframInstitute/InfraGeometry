Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraAnalysis :: Displacements *)

(* A displacement is an association v -> { w1, w2, ... } (multivalued in
   general; values are always lists), thought of as v -> exp_v(r X) for a
   vector field X at scale r = DisplacementMagnitude -- a section of the
   scale-r tangent bundle whose fiber over v is the r-ball at v.  Flows
   compose as maps, but by Baker-Campbell-Hausdorff

     Phi_Y . Phi_X = exp( X + Y + (1/2)[X, Y] + O(r^3) ),

   composition is NOT the sum: the sum is the bisector of the two
   composition orders (the +-(1/2)[X, Y] terms cancel), negation is the
   metric reflection through the base point, and general scalars are
   endpoints of t-scaled geodesics (rounded target distance, straightest
  candidates kept by geodesic flux). Weak k-continuity asks for one close
  target pair across each edge; Hausdorff and strong variants control all
  targets. Genuine metric ties stay multivalued and DisplacementReduce
  contracts them by iterated centres. *)

DisplacementCompose[ displacements__Association ] :=
  Fold[ { done, next } |-> ( Union @@ Lookup[ next, # ] & ) /@ done, { displacements } ]

DisplacementScale[ graph_Graph, displacement_Association, t_ ] :=
  With[
    { distancesFrom = source |-> AssociationThread[ VertexList @ graph, GraphDistance[ graph, source ] ] },
    { countsFrom = source |-> With[ { dist = distancesFrom[ source ] },
        Fold[
          { counts, vertex } |-> Append[ counts, vertex -> Total @ Lookup[ counts,
            Select[ AdjacencyList[ graph, vertex ], dist[ # ] == dist[ vertex ] - 1 & ] ] ],
          Association[ source -> 1 ],
          SortBy[ Select[ VertexList @ graph, 0 < dist[ # ] < Infinity & ], dist ] ] ] },
    (* gamma(t), a = gamma(0), b = gamma(1): the points on the ray a -> b, or its opposite for t < 0, closest to |t| d(a, b) from a, and among them
       the maximal geodesic flux sigma(p, q) sigma(q, s) / sigma(p, s) through the middle of the aligned triple *)
    { gamma = { a, b } |-> With[
        { da = distancesFrom[ a ], db = distancesFrom[ b ], sigmaA = countsFrom[ a ], sigmaB = countsFrom[ b ] },
        { ray = Select[ VertexList @ graph,
            If[ t >= 0,
              da[ # ] + db[ # ] == da[ b ] || da[ # ] == da[ b ] + db[ # ],
              db[ # ] == da[ # ] + da[ b ]
            ] & ] },
        { closest = MinimalBy[ ray, Abs[ da[ # ] - Abs[ t ] da[ b ] ] & ] },
        MaximalBy[ closest,
          Which[
            t < 0,                        sigmaA[ # ] sigmaA[ b ] / sigmaB[ # ],
            da[ # ] + db[ # ] == da[ b ], sigmaA[ # ] sigmaB[ # ] / sigmaA[ b ],
            True,                         sigmaA[ b ] sigmaB[ # ] / sigmaA[ # ]
          ] & ] ] },
    AssociationMap[
      ( Union @@ Table[ gamma[ #, target ], { target, displacement @ # } ] ) &,
      Keys @ displacement ] ]

DisplacementNegative[ graph_Graph, displacement_Association ] :=
  DisplacementScale[ graph, displacement, -1 ]

DisplacementInverse[ displacement_Association ] :=
  With[ { vertices = Keys @ displacement },
    AssociationMap[
      { vertex } |-> Select[ vertices, MemberQ[ displacement @ #, vertex ] & ],
      vertices ] ]

(* X + Y: bisector of Phi_Y Phi_X (v) and Phi_X Phi_Y (v) -- the two orders are
   exp( X + Y +- (1/2)[X, Y] + O(r^3) ), so their midpoints realise
   exp_v( X + Y ) with the commutator cancelled *)
DisplacementSum[ graph_Graph, displacement1_Association, displacement2_Association ] :=
  With[ { order12 = DisplacementCompose[ displacement1, displacement2 ],
          order21 = DisplacementCompose[ displacement2, displacement1 ] },
    AssociationMap[
      ( Union @@ Flatten[ Table[ DisplacementScale[ graph, <| end1 -> { end2 } |>, 1/2 ][ end1 ],
          { end1, order12 @ # }, { end2, order21 @ # } ], 1 ] ) &,
      Keys @ displacement1 ] ]

Options[ DisplacementCommutator ] = { Method -> "Inverse" }

DisplacementCommutator[
    graph_Graph, displacement1_Association, displacement2_Association,
    opts : OptionsPattern[] ] :=
  AssociationMap[
    DisplacementCommutator[ graph, displacement1, displacement2, #, opts ] &,
    Keys @ displacement1 ]

DisplacementCommutator[
    graph_Graph, displacement1_Association, displacement2_Association, point_,
    OptionsPattern[] ] :=
  Switch[ OptionValue[ Method ],
    "Inverse", DisplacementCompose[
      displacement1, displacement2,
      DisplacementInverse @ displacement1, DisplacementInverse @ displacement2 ] @ point,
    "Negative", Fold[
      { points, step } |-> Union @@ ( step /@ points ),
      { point },
      { displacement1, displacement2,
        DisplacementNegative[ graph, <| # -> displacement1 @ # |> ][ # ] &,
        DisplacementNegative[ graph, <| # -> displacement2 @ # |> ][ # ] & } ]
  ]

DisplacementBracket[ graph_Graph, displacement1_Association, displacement2_Association ] :=
  DisplacementCommutator[ graph, displacement1, displacement2, Method -> "Negative" ]

DisplacementBracket[ graph_Graph, displacement1_Association, displacement2_Association, point_ ] :=
  DisplacementCommutator[ graph, displacement1, displacement2, point, Method -> "Negative" ]

DisplacementMagnitude[ graph_Graph, displacement_Association ] :=
  Max @ KeyValueMap[
    { point, targets } |-> Max @ Table[ GraphDistance[ graph, point, target ], { target, targets } ],
    displacement ]

DisplacementReduce[ graph_Graph, displacement_Association ] :=
  Map[
    FixedPoint[
      targets |-> MinimalBy[ targets,
        { candidate } |-> Max @ Table[ GraphDistance[ graph, candidate, target ], { target, targets } ] ],
      # ] &,
    displacement ]

DisplacementSingleValuedQ[ displacement_Association ] :=
  AllTrue[ Values @ displacement, Length @ # == 1 & ]

DisplacementBijectionQ[ displacement_Association ] :=
  DisplacementSingleValuedQ @ displacement &&
    Sort @ Catenate @ Values @ displacement === Sort @ Keys @ displacement

DisplacementIsomorphismQ[ graph_Graph, displacement_Association ] :=
  DisplacementBijectionQ @ displacement &&
    AllTrue[ EdgeList @ graph,
      EdgeQ[ graph, UndirectedEdge @@ Catenate @ Lookup[ displacement, List @@ # ] ] & ]

Options[ ContinuousDisplacementQ ] = { Method -> "Weak" }

ContinuousDisplacementQ[ graph_Graph, displacement_Association, opts : OptionsPattern[] ] :=
  ContinuousDisplacementQ[ graph, displacement, 1, opts ]

ContinuousDisplacementQ[
    graph_Graph, displacement_Association, k_, OptionsPattern[] ] :=
  With[
    { setDistance = Switch[ OptionValue[ Method ],
        "Weak", { targets1, targets2 } |->
          Min @ Flatten @ Outer[ GraphDistance[ graph, #1, #2 ] &, targets1, targets2, 1, 1 ],
        "Hausdorff", { targets1, targets2 } |->
          Max[
            Max @ Map[ target1 |-> Min @ Map[ GraphDistance[ graph, target1, # ] &, targets2 ], targets1 ],
            Max @ Map[ target2 |-> Min @ Map[ GraphDistance[ graph, target2, # ] &, targets1 ], targets2 ] ],
        "Strong", { targets1, targets2 } |->
          Max @ Flatten @ Outer[ GraphDistance[ graph, #1, #2 ] &, targets1, targets2, 1, 1 ] ] },
    AllTrue[ EdgeList @ graph,
      { edge } |-> setDistance[ displacement @ First @ edge, displacement @ Last @ edge ] <= k ] ]

Options[ PolarDisplacements ] = { "Direction" -> "Outward" }

PolarDisplacements[ graph_Graph, center_, OptionsPattern[] ] :=
  With[
    { dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ],
      sign = Switch[ OptionValue[ "Direction" ], "Outward", 1, "Inward", -1 ] },
    { AssociationMap[
        { v } |-> Replace[ Select[ AdjacencyList[ graph, v ], dist[ # ] == dist[ v ] + sign & ], { } -> { v } ],
        VertexList @ graph ],
      AssociationMap[
        { v } |-> Replace[ Select[ AdjacencyList[ graph, v ], dist[ # ] == dist[ v ] & ], { } -> { v } ],
        VertexList @ graph ] }
  ]

GradientDisplacement[ graph_Graph, f_Association ] :=
  AssociationMap[
    { v } |-> With[ { best = MaximalBy[ AdjacencyList[ graph, v ], f ] },
      If[ f @ First @ best > f @ v, best, { v } ] ],
    VertexList @ graph ]

TranslationDisplacement[ graph_Graph, vector_List ] :=
  With[
    { position = AssociationThread[ VertexList @ graph, GraphEmbedding @ graph ],
      nearest = Nearest[ GraphEmbedding @ graph -> VertexList @ graph ] },
    AssociationMap[ nearest[ position @ # + vector ] &, VertexList @ graph ] ]

RandomDisplacement[ graph_Graph, radius_ : 1 ] :=
  With[
    {
      order = First @ Last @ Reap[ BreadthFirstScan[ graph, First @ VertexList @ graph, { "DiscoverVertex" -> ( Sow[ #1 ] & ) } ] ],
      ballOf = vertex |-> Union[ { vertex }, AdjacencyList[ graph, vertex, radius ] ]
    },
    {
      assign = targets |-> Fold[
        { acc, vertex } |-> Join[ acc, <| vertex -> With[
          { neighborTargets = Catenate @ Lookup[ acc, Intersection[ AdjacencyList[ graph, vertex ], Keys @ acc ], { } ], ball = ballOf[ vertex ] },
          { admissible = Fold[ Intersection, ball, Table[ Union[ { target }, AdjacencyList[ graph, target ] ], { target, neighborTargets } ] ] },
          { RandomChoice @ If[ admissible === { },
              MinimalBy[ ball, { candidate } |-> Max @ Table[ GraphDistance[ graph, candidate, target ], { target, neighborTargets } ] ],
              admissible ] }
        ] |> ],
        targets,
        order
      ],
      repair = { targets, violating } |-> Fold[
        { acc, vertex } |-> Join[ acc, <| vertex -> With[
          { neighborTargets = Catenate @ Lookup[ acc, AdjacencyList[ graph, vertex ] ], ball = ballOf[ vertex ] },
          { RandomChoice @ MinimalBy[ ball, { candidate } |->
              { Max @ Table[ GraphDistance[ graph, candidate, target ], { target, neighborTargets } ], GraphDistance[ graph, vertex, candidate ] } ] }
        ] |> ],
        targets,
        violating
      ],
      violatingOf = targets |-> Union @ Catenate @ Select[ List @@@ EdgeList[ graph ],
        { edge } |-> GraphDistance[ graph, First @ targets @ First @ edge, First @ targets @ Last @ edge ] > 1 ]
    },
    First @ NestWhile[
      attempt |-> NestWhile[
        Apply[ { targets, previous } |-> With[
          { violating = violatingOf[ targets ] },
          { If[ violating === { }, targets, repair[ targets, violating ] ], violating }
        ] ],
        { assign[ <| |> ], None },
        Last[ # ] =!= { } &,
        1,
        50
      ],
      { None, None },
      Last[ # ] =!= { } &,
      1,
      5
    ]
  ]

FindKillingDisplacement[ graph_Graph ] :=
  First @ FindKillingDisplacement[ graph, All ]

FindKillingDisplacement[ graph_Graph, All ] :=
  With[
    { vertices = VertexList @ graph },
    { permutations = DeleteCases[ GroupElements @ GraphAutomorphismGroup @ graph, Cycles[ { } ] ] },
    { displacements = Table[
        AssociationThread[ vertices, List /@ Permute[ vertices, permutation ] ],
        { permutation, permutations } ] },
    MinimalBy[ displacements, DisplacementMagnitude[ graph, # ] & ]
  ]

KillingDisplacementMagnitude[ graph_Graph ] :=
  Min @ Append[
    Map[ DisplacementMagnitude[ graph, # ] &, FindKillingDisplacement[ graph, All ] ],
    Infinity ]

Options[ DisplacementPlot ] = Options[ Graphics ]

DisplacementPlot[ graph_Graph, displacement_Association, opts : OptionsPattern[] ] :=
  DisplacementPlot[ graph, { displacement }, opts ]

DisplacementPlot[ graph_Graph, displacements : { __Association }, opts : OptionsPattern[] ] :=
  With[
    { position = AssociationThread[ VertexList @ graph, GraphEmbedding @ graph ] },
    Show[
      Graph[ graph, VertexCoordinates -> GraphEmbedding @ graph, VertexSize -> Small,
        VertexStyle -> LightGray, EdgeStyle -> Opacity[ 0.4, LightGray ] ],
      Graphics @ Table[
        With[
          { pairs = DeleteCases[
              Catenate @ KeyValueMap[
                { vertex, targets } |-> Table[ { position @ vertex, position @ target }, { target, targets } ],
                displacements[[ index ]] ],
              { p_, p_ } ] },
          { ColorData[ 97 ][ index ], Arrowheads[ 0.02 ],
            Arrow @ BezierCurve @ { #[[ 1 ]], ( #[[ 1 ]] + #[[ 2 ]] )/2 + 0.2 { 1, -1 } Reverse[ #[[ 2 ]] - #[[ 1 ]] ], #[[ 2 ]] } & /@ pairs } ],
        { index, Length @ displacements } ],
      Sequence @@ FilterRules[ { opts }, Options[ Graphics ] ]
    ]
  ]
