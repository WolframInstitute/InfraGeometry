Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraCircleThrough *)

Options[ RandomInfraCircleThrough ] = { "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraCircleThrough[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraCircleThrough[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraCircleThrough[ ___, RandomSeeding -> None ] ] ] ]

(* The visited-set states retain simplicity and prescribed-point containment; a plain shortest-path DAG loses these constraints. *)

InfraMeasurement[ graph_Graph,
    InfraCircleThrough[ points_List, InfraCircle[ center_, { inner_Integer, outer_Integer } ] ],
    property : ( "Graph" | "Faithful" | "Cardinality" | "Length" | "VertexDensity" | "EdgeDensity" |
      "Subgraph" | "CountingMeasure" | "RiemannianMeasure" | All ) ] /; UndirectedGraphQ[ graph ] && SimpleGraphQ[ graph ] && ! WeightedGraphQ[ graph ] &&
    1 <= inner <= outer && points =!= {} && AnyTrue[ VertexList[ graph ], SameQ[ #, center ] & ] &&
    AllTrue[ points, point |-> AnyTrue[ VertexList[ graph ], SameQ[ #, point ] & ] ] :=
  Module[
    { vertices, indexed, vertexIndex, centerIndex, requested, distances, band, adjacency, exterior, root, requiredMask,
      initial, frontier, layers, transitions = <||>, accepted = {}, minimumLength = Infinity, depth = 1,
      next, reduction = <||>, registry = <||>, successors = <| 1 -> {} |>, labels = <||>,
      suffixCounts = <| 1 -> 1 |>, children, signature, identifier, source, dag, carrier,
      blocks, moves, bandGraph, position, bandDistances, witnesses, masks, closings, closing, bound, exhausted },
    vertices = VertexList[ graph ];
    indexed = IndexGraph[ graph ];
    vertexIndex = AssociationThread[ vertices, Range[ Length[ vertices ] ] ];
    centerIndex = Lookup[ vertexIndex, Key[ center ] ];
    requested = Sort @ DeleteDuplicates[ Lookup[ vertexIndex, Key /@ points ] ];
    distances = GraphDistance[ indexed, centerIndex ];
    band = Select[ Range[ Length[ vertices ] ], index |-> TrueQ[ inner <= distances[[ index ]] <= outer ] ];
    exterior = Select[ Range[ Length[ vertices ] ], index |-> distances[[ index ]] < Infinity && distances[[ index ]] > outer ];
    adjacency = AssociationMap[ index |-> Intersection[ AdjacencyList[ indexed, index ], band ], band ];
    root = First[ requested ];
    requiredMask = Total[ 2^(requested - 1) ];
    initial = { 2^(root - 1), root, 0 };
    (* the search over simple paths hung the kernel on the mesh band {2, 3}: a state is kept only when its depth plus a lower bound on the
       rest of the cycle fits the bound, raised from the least conceivable length until a cycle is accepted; a cycle lies in one block of the
       band, and only a block with every requested vertex can carry one *)
    blocks = If[ SubsetQ[ band, requested ], Union @@ Select[ KVertexConnectedComponents[ Subgraph[ indexed, band ], 2 ],
      block |-> Length[ block ] >= 3 && SubsetQ[ block, requested ] ], {} ];
    (* a cycle that cuts c off from an exterior neighbour x of a rim vertex y meets every path c ... y, x, so it meets a fixed shortest one *)
    witnesses = Join[ List /@ requested, Map[
      rim |-> Select[ FindShortestPath[ indexed, centerIndex, rim ], index |-> distances[[ index ]] >= inner && MemberQ[ blocks, index ] ],
      Select[ band, index |-> distances[[ index ]] == outer && IntersectingQ[ AdjacencyList[ indexed, index ], exterior ] ] ] ];
    exhausted = blocks === {} || MemberQ[ witnesses, {} ];
    If[ ! exhausted,
      moves = AssociationMap[ index |-> Intersection[ AdjacencyList[ indexed, index ], blocks ], blocks ];
      bandGraph = Subgraph[ indexed, blocks ];
      position = AssociationThread[ VertexList[ bandGraph ], Range[ VertexCount[ bandGraph ] ] ];
      bandDistances = GraphDistanceMatrix[ bandGraph ];
      masks = Map[ set |-> Total[ 2^(set - 1) ], witnesses ];
      (* the rest of a cycle from v through an unmet set W is at least min over w in W of d(v, w) + d(w, root), and its last vertex is an
         unvisited neighbour u of the root, at least d(v, u) + 1 *)
      closings = Map[ set |-> Min /@ Transpose[ Map[ index |->
          bandDistances[[ position[ index ] ]] + bandDistances[[ position[ index ], position[ root ] ]], set ] ], witnesses ];
      closing = state |-> Max[
        1 + Min[ bandDistances[[ position[ state[[ 2 ]] ],
          Lookup[ position, Select[ moves[ root ], index |-> index === state[[ 2 ]] || BitGet[ state[[ 1 ]], index - 1 ] == 0 ] ] ]] ],
        closings[[ Flatten @ Position[ BitAnd[ state[[ 1 ]], masks ], 0 ], position[ state[[ 2 ]] ] ]] ];
      bound = Max[ 2, Length[ requested ] - 1, closing[ initial ] - 1 ];
      exhausted = closing[ initial ] === Infinity
    ];
    layers = {};
    While[ accepted === {} && ! exhausted && bound < Length[ blocks ],
      bound++;
      exhausted = True;
      transitions = <||>;
      depth = 1;
      frontier = { initial };
      layers = {};
      While[ frontier =!= {},
        layers = Join[ layers, { frontier } ];
        If[ depth >= Max[ 3, Length[ requested ] ],
          accepted = Select[ frontier, state |->
            BitAnd[ state[[ 1 ]], requiredMask ] == requiredMask &&
            state[[ 3 ]] < state[[ 2 ]] && MemberQ[ adjacency[ state[[ 2 ]] ], root ] &&
            With[ { removed = Select[ band, index |-> BitGet[ state[[ 1 ]], index - 1 ] == 1 ] },
              Intersection[ exterior, VertexComponent[ VertexDelete[ indexed, removed ], centerIndex ] ] === {} ] ];
          If[ accepted =!= {}, minimumLength = depth; Break[] ]
        ];
        Scan[ state |-> (
          next = Select[ ({ BitSet[ state[[ 1 ]], # - 1 ], #, If[ depth == 1, #, state[[ 3 ]] ] } &) /@
            Select[ moves[ state[[ 2 ]] ], index |-> BitGet[ state[[ 1 ]], index - 1 ] == 0 ],
            child |-> With[ { length = depth + closing[ child ] },
              If[ bound < length < Infinity, exhausted = False ];
              length <= bound ] ];
          AssociateTo[ transitions, state -> next ]
        ), frontier ];
        frontier = DeleteDuplicates @ Catenate[ (state |-> Lookup[ transitions, Key[ state ] ]) /@ frontier ];
        depth++
      ]
    ];
    Scan[ layer |-> Scan[ state |-> (
      children = If[ MemberQ[ accepted, state ], { 1 },
        DeleteCases[ DeleteDuplicates[ (child |-> Lookup[ reduction, Key[ child ], 0 ]) /@
          Lookup[ transitions, Key[ state ], {} ] ], 0 ] ];
      If[ children === {},
        AssociateTo[ reduction, state -> 0 ],
        signature = { state[[ 2 ]], Sort[ children ] };
        identifier = Lookup[ registry, Key[ signature ], 0 ];
        If[ identifier == 0,
          identifier = Length[ registry ] + 2;
          AssociateTo[ registry, signature -> identifier ];
          AssociateTo[ successors, identifier -> Sort[ children ] ];
          AssociateTo[ labels, identifier -> vertices[[ state[[ 2 ]] ]] ];
          AssociateTo[ suffixCounts, identifier -> Total[ Lookup[ suffixCounts, children ] ] ]
        ];
        AssociateTo[ reduction, state -> identifier ]
      ]
    ), layer ], Reverse[ layers ] ];
    source = Lookup[ reduction, Key[ initial ], 0 ];
    If[ source == 0,
      dag = Graph[ { 0, 1 }, {}, DirectedEdges -> True ];
      successors = <| 0 -> {}, 1 -> {} |>;
      suffixCounts = <| 0 -> 0, 1 -> 1 |>;
      labels = <||>,
      dag = Graph[ Keys[ successors ], Catenate @ KeyValueMap[ { node, targets } |-> (DirectedEdge[ node, # ] & /@ targets), successors ] ]
    ];
    carrier = If[ source == 0, Graph[ {}, {}, DirectedEdges -> True ],
      VertexReplace[ dag, Map[ node |-> node -> { node, If[ node === 1, labels[ source ], labels[ node ] ] }, VertexList[ dag ] ] ] ];
    Switch[ property,
      "Graph", carrier,
      "Faithful", True,
      "Cardinality", suffixCounts[ source ],
      "Length", minimumLength,
      _, With[ { incoming = GroupBy[ EdgeList[ dag ], Last -> First ] },
        { prefixes = Fold[ { counts, node } |-> Append[ counts, node ->
            If[ node === source, 1, Total[ Lookup[ counts, Lookup[ incoming, node, {} ], 0 ] ] ] ],
            <||>, TopologicalSort[ dag ] ] },
        { vertexDensity = KeySort @ Merge[
            Map[ node |-> labels[ node ] -> prefixes[ node ] suffixCounts[ node ], Keys[ labels ] ], Total ],
          edgeDensity = KeySort @ Merge[ Map[ edge |->
            ( UndirectedEdge @@ Sort[ { labels[ First[ edge ] ],
                If[ Last[ edge ] === 1, labels[ source ], labels[ Last[ edge ] ] ] } ] ) ->
              prefixes[ First[ edge ] ] suffixCounts[ Last[ edge ] ], EdgeList[ dag ] ], Total ] },
        { support = Keys[ vertexDensity ] },
        Switch[ property,
          "VertexDensity", vertexDensity,
          "EdgeDensity", edgeDensity,
          "Subgraph", Subgraph[ graph, support ],
          "CountingMeasure", Length[ support ],
          "RiemannianMeasure", Count[ support, vertex_ /;
            AllTrue[ AdjacencyList[ graph, vertex ], neighbor |-> AnyTrue[ support, SameQ[ #, neighbor ] & ] ] ],
          All, <| "Graph" -> carrier, "Faithful" -> True, "Cardinality" -> suffixCounts[ source ], "Length" -> minimumLength,
            "VertexDensity" -> vertexDensity, "EdgeDensity" -> edgeDensity, "Subgraph" -> Subgraph[ graph, support ],
            "CountingMeasure" -> Length[ support ], "RiemannianMeasure" -> Count[ support, vertex_ /;
              AllTrue[ AdjacencyList[ graph, vertex ], neighbor |-> AnyTrue[ support, SameQ[ #, neighbor ] & ] ] ] |> ] ] ]
  ]

RandomInfraCircleThrough[ graph_Graph, token_InfraCircleThrough,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraCircleThrough ], First /@ { opts } ] ) :=
  With[ { carrier = InfraMeasurement[ graph, token, "Graph" ] },
    RandomInfraCircleThrough[ carrier, count, opts ] /; GraphQ[ carrier ] ]

RandomInfraCircleThrough[ carrier_Graph,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( DirectedGraphQ[ carrier ] && AcyclicGraphQ[ carrier ] &&
    AllTrue[ VertexList[ carrier ], MatchQ[ #, { _Integer, _ } ] & ] &&
    SubsetQ[ First /@ Options[ RandomInfraCircleThrough ], First /@ { opts } ] &&
    MemberQ[ { Automatic, Identity }, OptionValue[ RandomInfraCircleThrough, { opts }, "NextVertexFunction" ] ] ) :=
  Module[ { source, sink, successors, suffixes, total, number, selected = <||>, draw, ranks,
      node, residual, path, targets, cumulative, choice, representatives },
    If[ VertexCount[ carrier ] == 0, Return[ {} ] ];
    source = First @ Pick[ VertexList[ carrier ], VertexInDegree[ carrier ], 0 ];
    sink = First @ Pick[ VertexList[ carrier ], VertexOutDegree[ carrier ], 0 ];
    successors = GroupBy[ EdgeList[ carrier ], First -> Last ];
    suffixes = Fold[ { counts, vertex } |-> Append[ counts, vertex ->
        If[ vertex === sink, 1, Total[ Lookup[ counts, Key /@ Lookup[ successors, Key[ vertex ], {} ], 0 ] ] ] ],
      <||>, Reverse @ TopologicalSort[ carrier ] ];
    total = Lookup[ suffixes, Key[ source ] ];
    number = Replace[ count, { All -> total, Automatic -> Min[ 1, total ], UpTo[ n_ ] :> Min[ n, total ] } ];
    If[ number > total, Return[ {} ] ];
    ranks = If[ count === All || OptionValue[ "NextVertexFunction" ] === Identity, Range[ number ],
      Do[
        draw = RandomInteger[ { 1, last } ];
        AssociateTo[ selected, If[ KeyExistsQ[ selected, draw ], last, draw ] -> True ],
        { last, total - number + 1, total } ];
      RandomSample[ Keys[ selected ] ] ];
    representatives = Map[ rank |-> (
      node = source;
      residual = rank;
      path = {};
      While[ node =!= sink,
        path = Join[ path, { Last[ node ] } ];
        targets = Lookup[ successors, Key[ node ] ];
        cumulative = Accumulate[ Lookup[ suffixes, Key /@ targets ] ];
        choice = First @ FirstPosition[ cumulative, value_ /; value >= residual ];
        residual -= If[ choice == 1, 0, cumulative[[ choice - 1 ]] ];
        node = targets[[ choice ]]
      ];
      path ), ranks ];
    If[ count === Automatic, If[ representatives === {}, {}, First[ representatives ] ], representatives ]
  ]

RandomInfraCircleThrough[ graph_Graph, points_List, circle_InfraCircle,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] :=
  RandomInfraCircleThrough[ graph, InfraCircleThrough[ points, circle ], count, opts ]

InfraMemberQ[ graph_Graph, token : InfraCircleThrough[ points_List, InfraCircle[ center_, { inner_Integer, outer_Integer } ] ],
    candidate_List ] :=
  With[ { vertices = VertexList[ graph ], carrier = InfraMeasurement[ graph, token, "Graph" ],
      cycle = If[ Length[ candidate ] > 1 && First[ candidate ] === Last[ candidate ], Most[ candidate ], candidate ] },
    With[ { indices = AssociationThread[ vertices, Range[ Length[ vertices ] ] ], indexed = IndexGraph[ graph ] },
      With[ { ids = Lookup[ indices, Key /@ cycle ] },
        Length[ cycle ] >= 3 && DuplicateFreeQ[ ids ] && AllTrue[ cycle, vertex |-> AnyTrue[ vertices, SameQ[ #, vertex ] & ] ] &&
          VertexCount[ carrier ] > 0 &&
          GraphDistance[ carrier, First @ Pick[ VertexList[ carrier ], VertexInDegree[ carrier ], 0 ],
            First @ Pick[ VertexList[ carrier ], VertexOutDegree[ carrier ], 0 ] ] == Length[ cycle ] &&
          With[ { distances = GraphDistance[ indexed, Lookup[ indices, Key[ center ] ] ] },
            SubsetQ[ ids, Lookup[ indices, Key /@ points ] ] &&
              AllTrue[ ids, inner <= distances[[ # ]] <= outer & ] &&
              AllTrue[ Partition[ Append[ ids, First[ ids ] ], 2, 1 ], EdgeQ[ indexed, UndirectedEdge @@ # ] & ] &&
              Intersection[ Select[ Range[ Length[ vertices ] ], outer < distances[[ # ]] < Infinity & ],
                VertexComponent[ VertexDelete[ indexed, ids ], Lookup[ indices, Key[ center ] ] ] ] === {} ] ] ] /;
      GraphQ[ carrier ] ]


InfraMeasurement[ graph_Graph, token_InfraCircleThrough, properties : { __String } ] /;
    SubsetQ[ { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity",
      "Subgraph", "CountingMeasure", "RiemannianMeasure" }, properties ] :=
  With[ { data = InfraMeasurement[ graph, token, All ] },
    KeyTake[ data, properties ] /; AssociationQ[ data ] ]
