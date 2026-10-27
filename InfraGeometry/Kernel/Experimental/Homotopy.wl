Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: Homotopy *)

Options[ FindInfraHomotopy ] = {
  Method -> Automatic,
  "FreeHomotopy" -> False,
  "NullHomotopicCycles" -> { 1, 2, 3 },
  "MaxLength" -> Automatic,
  "MaxMoves" -> Infinity,
  "MaxStates" -> 1000
}

FindInfraHomotopy[ graph_Graph, InfraHomotopy[ a_, b_, relationOptions___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] :=
  FindInfraHomotopy[ graph, a, b, count, opts, relationOptions ]

FindInfraHomotopy[ graph_Graph, a_, b_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    ! DirectedGraphQ[ graph ] &&
    SubsetQ[ First /@ Options[ FindInfraHomotopy ], First /@ { opts } ] &&
    MatchQ[ OptionValue[ FindInfraHomotopy, { opts }, Method ], Automatic | "Exhaustive" | "Greedy" ] &&
    MatchQ[ OptionValue[ FindInfraHomotopy, { opts }, "FreeHomotopy" ], True | False ] &&
    MatchQ[ OptionValue[ FindInfraHomotopy, { opts }, "MaxLength" ], Automatic | Infinity | _Integer?( n |-> n > 0 ) ] &&
    MatchQ[ OptionValue[ FindInfraHomotopy, { opts }, "MaxMoves" ], Infinity | _Integer?( n |-> n >= 0 ) ] &&
    ( MatchQ[ OptionValue[ FindInfraHomotopy, { opts }, "MaxStates" ], _Integer?( n |-> n > 0 ) ] ||
      OptionValue[ FindInfraHomotopy, { opts }, "MaxStates" ] === Infinity && OptionValue[ FindInfraHomotopy, { opts }, Method ] === "Exhaustive" ) :=
  With[ { result =
  With[ {
      method = OptionValue[ FindInfraHomotopy, { opts }, Method ],
      free = OptionValue[ FindInfraHomotopy, { opts }, "FreeHomotopy" ],
      faceSpec = Replace[ OptionValue[ FindInfraHomotopy, { opts }, "NullHomotopicCycles" ], n_Integer?( n |-> n >= 0 ) :> Range[ n ] ],
      lengthLimit = OptionValue[ FindInfraHomotopy, { opts }, "MaxLength" ],
      moveLimit = OptionValue[ FindInfraHomotopy, { opts }, "MaxMoves" ],
      stateLimit = OptionValue[ FindInfraHomotopy, { opts }, "MaxStates" ],
      adjacent = { x, y } |-> x === y || EdgeQ[ graph, UndirectedEdge[ x, y ] ],
      shape = { closed, walk } |-> If[ closed,
        With[ { core = MapIndexed[ { First @ #2, #1 } &,
            If[ Length[ walk ] > 1 && First[ walk ] === Last[ walk ], Most[ walk ], walk ] ] },
          Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ],
        PathGraph[ MapIndexed[ { First @ #2, #1 } &, walk ], DirectedEdges -> True ] ],
      canonical = walk |-> If[ Length[ walk ] <= 1, walk,
        With[ { core = Most[ walk ] },
          { rotation = First @ Sort @ Table[ RotateLeft[ core, i ], { i, 0, Length[ core ] - 1 } ] },
          If[ Length[ rotation ] == 1, rotation, Append[ rotation, First[ rotation ] ] ] ] ] },
    { validWalk = walk |-> ListQ[ walk ] && Length[ walk ] > 0 &&
        AllTrue[ walk, VertexQ[ graph, # ] & ] && AllTrue[ Partition[ walk, 2, 1 ], adjacent @@ # & ],
      spread = x |-> Which[
        AssociationQ[ x ], Keys[ x ],
        MatchQ[ x, { __Graph } ], x,
        ListQ[ x ] && Length[ x ] > 0 && ! AllTrue[ x, VertexQ[ graph, # ] & ] && AllTrue[ x, ListQ ], x,
        True, { x } ] },
    { decode = x |-> Which[
        ListQ[ x ] && validWalk[ x ], { False, x },
        GraphQ[ x ] && VertexCount[ x ] > 0,
          With[ { vertices = VertexList[ x ], closed = EdgeCount[ x ] == VertexCount[ x ] },
            { spelled = ! AllTrue[ vertices, VertexQ[ graph, # ] & ] &&
                AllTrue[ vertices, MatchQ[ #, { _Integer, _ } ] & ] &&
                Sort[ First /@ vertices ] === Range[ Length[ vertices ] ],
              start = SelectFirst[ vertices,
                If[ DirectedGraphQ[ x ], VertexInDegree[ x, # ] == 0, VertexDegree[ x, # ] == 1 ] &,
                First[ vertices ] ] },
            { ordered = If[ spelled, SortBy[ vertices, First ],
                First @ Last @ Reap[ DepthFirstScan[ x, start, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ] ] },
            { sequence = If[ spelled, Last /@ ordered, ordered ],
              edges = If[ closed, Partition[ ordered, 2, 1, 1 ], Partition[ ordered, 2, 1 ] ] },
            { walk = If[ closed && Length[ sequence ] > 1, Append[ sequence, First[ sequence ] ], sequence ] },
            If[ Length[ ordered ] == Length[ vertices ] && EdgeCount[ x ] == Length[ edges ] &&
                AllTrue[ edges, EdgeQ[ x, If[ DirectedGraphQ[ x ], DirectedEdge, UndirectedEdge ] @@ # ] & ] &&
                validWalk[ walk ], { closed, walk }, None ] ],
        True, None ],
      lengths = ListQ[ faceSpec ] && AllTrue[ faceSpec, MatchQ[ #, _Integer?( n |-> n > 0 ) ] & ] },
    { explicit = ListQ[ faceSpec ] && AllTrue[ faceSpec,
          ListQ[ # ] && Length[ # ] > 0 && validWalk[ Append[ #, First[ # ] ] ] & ],
      sources = decode /@ spread[ a ],
      targets = If[ b === Automatic, Automatic, decode /@ spread[ b ] ] },
    If[ ( lengths || explicit ) && FreeQ[ sources, None ] && Length[ sources ] > 0 &&
        ( targets === Automatic || FreeQ[ targets, None ] && Length[ targets ] > 0 &&
          SameQ @@ ( First /@ Join[ sources, targets ] ) ),
      With[ {
          duplicate = vertex |-> If[ lengths, MemberQ[ faceSpec, 1 ], MemberQ[ faceSpec, { vertex } ] ],
          spur = { x, y } |-> x =!= y && If[ lengths, MemberQ[ faceSpec, 2 ],
              MemberQ[ faceSpec, { x, y } | { y, x } ] ],
          cycles = If[ lengths,
            Catenate[ ( First /@ # & /@ FindCycle[ graph, { # }, All ] ) & /@ Select[ faceSpec, # >= 3 & ] ],
            faceSpec ],
          components = ConnectedComponents[ graph ],
          sourcePairs = If[ targets === Automatic, { #, Automatic } & /@ sources, Tuples[ { sources, targets } ] ] },
        { exact = NoneTrue[ cycles, Length[ # ] >= 3 & ],
          reduceStep = walk |-> With[
            { duplicatePosition = SelectFirst[ Range[ Length[ walk ] - 1 ],
                walk[[ # ]] === walk[[ # + 1 ]] && duplicate[ walk[[ # ]] ] &, None ] },
            If[ duplicatePosition =!= None, Delete[ walk, duplicatePosition + 1 ],
              With[ { spurPosition = SelectFirst[ Range[ Length[ walk ] - 2 ],
                  walk[[ # ]] === walk[[ # + 2 ]] && spur[ walk[[ # ]], walk[[ # + 1 ]] ] &, None ] },
                If[ spurPosition === None, walk, Drop[ walk, { spurPosition + 1, spurPosition + 2 } ] ] ] ] ],
          faceMoves = DeleteDuplicates @ Catenate @ Map[ face |->
            Flatten[ Table[
              { doubled[[ start + 1 ;; start + size + 1 ]],
                Reverse[ doubled[[ start + size + 1 ;; start + Length[ face ] + 1 ]] ] },
              { doubled, { Join[ face, face ], Join[ Reverse[ face ], Reverse[ face ] ] } },
              { start, 0, Length[ face ] - 1 }, { size, 0, Length[ face ] } ], 2 ], cycles ],
          spurGraph = Graph[ VertexList[ graph ], Select[ EdgeList[ graph ], spur @@ ( List @@ # ) & ] ] },
        { reductions = { closed, walk } |-> If[ closed && free,
            Most @ FixedPointList[
              current |-> With[ { rotations = If[ Length[ current ] <= 1, { current },
                    Table[ Append[ #, First[ # ] ] & @ RotateLeft[ Most[ current ], i ],
                      { i, 0, Length[ current ] - 2 } ] ] },
                { shorter = Select[ reduceStep /@ rotations, Length[ # ] < Length[ current ] & ] },
                If[ shorter === { }, current, canonical[ First @ SortBy[ shorter, { Length, Identity } ] ] ] ],
              canonical[ walk ] ],
            Most @ FixedPointList[ reduceStep, walk ] ],
          moves = { closed, walk } |-> DeleteDuplicates @ Join[
            Catenate @ Table[ If[ duplicate[ walk[[ i ]] ], { Insert[ walk, walk[[ i ]], i + 1 ] }, { } ],
              { i, Length[ walk ] } ],
            Cases[ Range[ Length[ walk ] - 1 ],
              i_ /; walk[[ i ]] === walk[[ i + 1 ]] && duplicate[ walk[[ i ]] ] :> Delete[ walk, i + 1 ] ],
            Catenate @ Table[ ( Join[ walk[[ ;; i ]], { #, walk[[ i ]] }, walk[[ i + 1 ;; ]] ] & ) /@
                Select[ AdjacencyList[ graph, walk[[ i ]] ], spur[ walk[[ i ]], # ] & ], { i, Length[ walk ] } ],
            Cases[ Range[ Length[ walk ] - 2 ],
              i_ /; walk[[ i ]] === walk[[ i + 2 ]] && spur[ walk[[ i ]], walk[[ i + 1 ]] ] :>
                Drop[ walk, { i + 1, i + 2 } ] ],
            Catenate @ Map[ move |-> Table[
                If[ walk[[ i ;; i + Length[ move[[ 1 ]] ] - 1 ]] === move[[ 1 ]],
                  Join[ walk[[ ;; i - 1 ]], move[[ 2 ]], walk[[ i + Length[ move[[ 1 ]] ] ;; ]] ], Nothing ],
                { i, Length[ walk ] - Length[ move[[ 1 ]] ] + 1 } ], faceMoves ],
            If[ ! closed && free,
              Join[ Append[ walk, # ] & /@ AdjacencyList[ graph, Last[ walk ] ],
                Prepend[ walk, # ] & /@ AdjacencyList[ graph, First[ walk ] ],
                If[ Length[ walk ] > 1, { Most[ walk ], Rest[ walk ] }, { } ] ], { } ] ] },
        { results = Map[ pair |-> With[
            { closed = First[ pair[[ 1 ]] ], start = Last[ pair[[ 1 ]] ],
              target = If[ pair[[ 2 ]] === Automatic, Automatic, Last[ pair[[ 2 ]] ] ] },
            { left = reductions[ closed, start ],
              right = If[ target === Automatic, Automatic, reductions[ closed, target ] ],
              canon = If[ closed && free, canonical, Identity ],
              minimumLength = If[ closed || free, 1, GraphDistance[ graph, First[ start ], Last[ start ] ] + 1 ],
              maximumLength = Replace[ lengthLimit,
                Automatic :> Max[ Length[ start ], If[ target === Automatic, 1, Length[ target ] ] ] +
                  2 * Max[ Prepend[ Length /@ cycles, 3 ] ] ] },
            { minimumCount = Which[
                free, Length @ SelectFirst[ components, MemberQ[ #, First[ start ] ] & ],
                closed || minimumLength == 1, 1,
                True,
                MatrixPower[ AdjacencyMatrix[ graph ], minimumLength - 1 ][[
                  First @ FirstPosition[ VertexList[ graph ], First[ start ] ],
                  First @ FirstPosition[ VertexList[ graph ], Last[ start ] ] ]] ],
              neighbours = walk |-> DeleteDuplicates @ Map[ canon,
                If[ closed && free && Length[ walk ] > 1,
                  Catenate[ moves[ closed, Append[ #, First[ # ] ] ] & /@
                    Table[ RotateLeft[ Most[ walk ], i ], { i, 0, Length[ walk ] - 2 } ] ],
                  moves[ closed, walk ] ] ],
              bridge = { x, y, transportGraph } |-> With[ { path = FindShortestPath[ transportGraph, x, y ] },
                If[ path === { }, { }, Prepend[ Catenate[ ( { { #[[ 1 ]], #[[ 2 ]], #[[ 1 ]] }, { #[[ 2 ]] } } & ) /@
                    Partition[ path, 2, 1 ] ], { x } ] ] ] },
            Which[
              target =!= Automatic && start === target, { { start } },
              target =!= Automatic && GraphDistance[ graph, First[ start ], First[ target ] ] === Infinity, { },
              target =!= Automatic && ! free &&
                  ( First[ start ] =!= First[ target ] || Last[ start ] =!= Last[ target ] ), { },
              ! closed && free,
                With[ { endpoints = If[ target === Automatic,
                    SelectFirst[ components, MemberQ[ #, First[ start ] ] & ], { First[ target ] } ] },
                  Map[ endpoint |-> With[ { transport = FindShortestPath[ graph, First[ start ], endpoint ] },
                    If[ transport === { }, Nothing,
                      Join[
                        Reverse[ Table[ Take[ start, i ], { i, Length[ start ] } ] ],
                        Catenate[ ( { #, { Last[ # ] } } & ) /@ Partition[ transport, 2, 1 ] ],
                        If[ target === Automatic, { }, Rest[ Table[ Take[ target, i ], { i, Length[ target ] } ] ] ]
                      ]
                    ]
                  ], endpoints ]
                ],
              target =!= Automatic && Last[ left ] === Last[ right ],
                { Join[ left, Rest[ Reverse[ right ] ] ] },
              target =!= Automatic && exact && closed && free &&
                  Length[ Last[ left ] ] == 1 && Length[ Last[ right ] ] == 1,
                With[ { middle = bridge[ First[ Last[ left ] ], First[ Last[ right ] ], spurGraph ] },
                  If[ middle === { }, { }, { Join[ left, Rest[ middle ], Rest[ Reverse[ right ] ] ] } ] ],
              target =!= Automatic && exact, { },
              target === Automatic && exact,
                If[ closed && free && Length[ Last[ left ] ] == 1,
                  Map[ vertex |-> Join[ left, Rest[ bridge[ First[ Last[ left ] ], vertex, spurGraph ] ] ],
                    SelectFirst[ ConnectedComponents[ spurGraph ], MemberQ[ #, First[ Last[ left ] ] ] & ] ],
                  { left } ],
              target === Automatic && Length[ Last[ left ] ] == minimumLength &&
                  ( count === Automatic || count === 1 || MatchQ[ count, _UpTo ] ), { left },
              True,
                With[ { score = candidate |-> {
                    If[ target === Automatic, Length[ candidate ], EditDistance[ candidate, canon[ target ] ] ],
                    Length[ candidate ] } },
                  { search = NestWhile[
                    state |-> With[ { current = First[ state[[ 2 ]] ] },
                      { candidates = If[ Last[ current ] >= moveLimit, { },
                          Select[ neighbours[ First[ current ] ],
                            ! KeyExistsQ[ First[ state ], # ] && Length[ # ] <= maximumLength & ] ] },
                      { chosen = Take[ If[ method === "Greedy", Take[ SortBy[ candidates, score ], UpTo[ 1 ] ],
                            SortBy[ candidates, score ] ],
                          If[ stateLimit === Infinity, All, UpTo[ stateLimit - Length[ First[ state ] ] ] ] ] },
                      { parents = Fold[ { accumulated, next } |-> Append[ accumulated, next -> First[ current ] ],
                          First[ state ], chosen ],
                        frontier = Join[ Rest[ state[[ 2 ]] ], { #, Last[ current ] + 1 } & /@ chosen ] },
                      { parents, If[ method === "Exhaustive", frontier, SortBy[ frontier, score[ First[ # ] ] & ] ] } ],
                    { <| canon[ start ] -> None |>, { { canon[ start ], 0 } } },
                    state |-> state[[ 2 ]] =!= { } && Length[ First[ state ] ] < stateLimit &&
                      If[ target === Automatic,
                        Count[ Length /@ Keys[ First[ state ] ], minimumLength ] <
                          Switch[ count, All, minimumCount, Automatic, 1, _UpTo, First[ count ], _, count ],
                        ! KeyExistsQ[ First[ state ], canon[ target ] ] ] ] },
                  { parents = First[ search ] },
                  { ends = If[ target === Automatic, Select[ Keys[ parents ], Length[ # ] == minimumLength & ],
                      If[ KeyExistsQ[ parents, canon[ target ] ], { canon[ target ] }, { } ] ] },
                  If[ ends === { } || target === Automatic &&
                      ( count === All && Length[ ends ] < minimumCount || IntegerQ[ count ] && Length[ ends ] < count ), None,
                    Map[ endpoint |-> Reverse @ Most @ NestWhileList[ parents, endpoint, # =!= None & ], ends ] ] ] ] ],
            sourcePairs ] },
          If[ FreeQ[ results, None ],
            With[ { chains = DeleteDuplicates @ Catenate @ MapThread[
                  { pair, chains } |-> Map[ shape[ First[ pair[[ 1 ]] ], # ] &, chains, { 2 } ],
                  { sourcePairs, results } ] },
              Switch[ count,
                Automatic, First[ chains, { } ],
                All, chains,
                _UpTo, Take[ chains, count ],
                _, If[ Length[ chains ] < count, { }, Take[ chains, count ] ] ] ],
            None ] ],
      None ] ] },
    result /; result =!= None ]

Options[ FindInfraHomotopyRepresentativeHomotopy ] = Options[ FindInfraHomotopy ]

FindInfraHomotopyRepresentativeHomotopy[ graph_Graph, walk_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] :=
  With[ { result = FindInfraHomotopy[ graph, walk, Automatic, count, opts ] },
    result /; ListQ[ result ] ]

Options[ FindInfraHomotopyRepresentative ] = Options[ FindInfraHomotopy ]

FindInfraHomotopyRepresentative[ graph_Graph, walk_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : All,
    opts : OptionsPattern[] ] :=
  With[ { result = FindInfraHomotopyRepresentativeHomotopy[ graph, walk, If[ count === Automatic, 1, count ], opts ] },
    With[ { representatives = DeleteDuplicates[ Last /@ result ] },
      Switch[ count,
        Automatic, First[ representatives, { } ],
        All, representatives,
        _UpTo, Take[ representatives, count ],
        _, If[ Length[ representatives ] < count, { }, Take[ representatives, count ] ] ] ] /; ListQ[ result ] ]

Options[ HomotopicQ ] = Options[ FindInfraHomotopy ]

HomotopicQ[ graph_Graph, a_, b_, opts : OptionsPattern[] ] :=
  With[ { spread = x |-> Which[
      AssociationQ[ x ], Keys[ x ],
      MatchQ[ x, { __Graph } ], x,
      ListQ[ x ] && Length[ x ] > 0 && ! AllTrue[ x, VertexQ[ graph, # ] & ] && AllTrue[ x, ListQ ], x,
      True, { x } ] },
    { pairs = Tuples[ { spread[ a ], spread[ b ] } ] },
    { results = FindInfraHomotopy[ graph, #[[ 1 ]], #[[ 2 ]], opts ] & /@ pairs },
    If[ MemberQ[ results, { } ], False, True ] /; Length[ results ] > 0 && AllTrue[ results, ListQ ] ]


Options[ NullHomotopicQ ] = Options[ FindInfraHomotopy ]

NullHomotopicQ[ graph_Graph, cycle_List, opts : OptionsPattern[] ] /;
    Length[ cycle ] > 0 && AllTrue[ cycle, VertexQ[ graph, # ] & ] :=
  With[ { loop = walk |-> With[ { core = MapIndexed[ { First @ #2, #1 } &,
        If[ Length[ walk ] > 1 && First[ walk ] === Last[ walk ], Most[ walk ], walk ] ] },
      Graph[ core, DirectedEdge @@@ Partition[ core, 2, 1, 1 ] ] ] },
    With[ { result = HomotopicQ[ graph, loop[ cycle ], loop[ { First[ cycle ] } ], opts ] },
      result /; MatchQ[ result, True | False ] ] ]

NullHomotopicQ[ graph_Graph, walks : { __Graph }, opts : OptionsPattern[] ] :=
  With[ { results = NullHomotopicQ[ graph, #, opts ] & /@ walks },
    And @@ results /; AllTrue[ results, MatchQ[ #, True | False ] & ] ]

NullHomotopicQ[ graph_Graph, walk_Graph, opts : OptionsPattern[] ] :=
  With[ { certificate = FindInfraHomotopy[ graph, walk, walk, opts ] },
    With[ { sequence = Last /@ SortBy[ VertexList[ First[ certificate ] ], First ] },
      NullHomotopicQ[ graph, sequence, opts ] ] /; MatchQ[ certificate, { __Graph } ] ]

HomotopyMoveType[ walk1_List, walk2_List ] :=
  Which[
    Length[ walk2 ] < Length[ walk1 ], "Contract",
    Length[ walk2 ] > Length[ walk1 ], "Extend",
    True, "Lateral"
  ]

HomotopyMoveType[ walk1_Graph, walk2_Graph ] :=
  HomotopyMoveType[ VertexList[ walk1 ], VertexList[ walk2 ] ]

HomotopyMoveTypes[ walks_List ] /;
    MatchQ[ walks, { __Graph } | { { __Graph } .. } ] || AllTrue[ walks, ListQ ] :=
  Which[
    MatchQ[ walks, { __Graph } ], MapThread[ HomotopyMoveType, { Most[ walks ], Rest[ walks ] } ],
    MatchQ[ walks, { { __Graph } .. } ], HomotopyMoveTypes /@ walks,
    AllTrue[ walks, ListQ ], MapThread[ HomotopyMoveType, { Most[ walks ], Rest[ walks ] } ]
  ]
