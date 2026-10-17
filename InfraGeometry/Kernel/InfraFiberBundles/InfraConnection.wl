Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: InfraFiberBundles :: InfraConnection *)

(* Ported from InfraGaugeTheory Kernel/Connections.wl at e5dc83b; InfraGaugeTheory keeps its own copy *)

InfraConnectionQ[ fib : _[ _Graph, __ ], InfraConnection[ edges_List ] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  With[ { total = InfraTotalGraph @ fib, base = InfraBaseGraph @ fib, projection = InfraFibrationAssociation @ fib },
    { vertices = VertexList @ total, baseVertices = VertexList @ base },
    { index = AssociationThread[ vertices, Range @ Length @ vertices ],
      baseIndex = AssociationThread[ baseVertices, Range @ Length @ baseVertices ] },
    AllTrue[ edges, MatchQ[ #, UndirectedEdge[ _, _ ] ] && EdgeQ[ total, # ] & ] &&
      With[ { indexedEdges = Lookup[ index, Key /@ ( List @@ # ) ] & /@ edges,
          projected = Lookup[ baseIndex, Key /@ Lookup[ projection, Key /@ vertices ] ] },
        DuplicateFreeQ[ Sort /@ indexedEdges ] &&
          AllTrue[ indexedEdges, projected[[ First @ # ]] =!= projected[[ Last @ # ]] & ] &&
          With[ { connection = Graph[ Range @ Length @ vertices, UndirectedEdge @@@ indexedEdges ], indexedBase = IndexGraph @ base },
            AllTrue[ Range @ Length @ vertices,
              vertex |-> Sort[ projected[[ AdjacencyList[ connection, vertex ] ]] ] ===
                Sort @ AdjacencyList[ indexedBase, projected[[ vertex ]] ] ] ] ] ]

InfraConnectionQ[ fib : _[ _Graph, __ ], connections_List ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  connections =!= { } && And @@ ( InfraConnectionQ[ fib, # ] & /@ connections )

(* Global monodromy is trivial iff every horizontal leaf projects injectively to the base. *)

InfraFlatConnectionQ[ fib : _[ _Graph, __ ], connection : InfraConnection[ edges_List ] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  InfraConnectionQ[ fib, connection ] &&
    With[ { projection = InfraFibrationAssociation @ fib },
      AllTrue[ ConnectedComponents @ Graph[ VertexList @ InfraTotalGraph @ fib, edges ],
        DuplicateFreeQ[ Lookup[ projection, Key /@ # ] ] & ] ]

InfraFlatConnectionQ[ fib : _[ _Graph, __ ], connections_List ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] :=
  connections =!= { } && And @@ ( InfraFlatConnectionQ[ fib, # ] & /@ connections )

Options[ RandomInfraConnection ] = { "NextVertexFunction" -> Automatic }

RandomInfraConnection[ fib : _[ _Graph, __ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /;
    AssociationQ[ InfraFibrationAssociation @ fib ] && GraphQ[ InfraBaseGraph @ fib ] &&
    SubsetQ[ First /@ Options[ RandomInfraConnection ], First /@ Flatten @ { opts } ] &&
    With[ { next = OptionValue[ RandomInfraConnection, { opts }, "NextVertexFunction" ] },
      ! MatchQ[ next, _String | _Integer | _Real | _Rational | _Complex | _List | _Association | _Rule | _RuleDelayed ] &&
        ( count =!= All || next =!= RandomChoice ) ] :=
  With[ { total = InfraTotalGraph @ fib, base = InfraBaseGraph @ fib, projection = InfraFibrationAssociation @ fib,
      cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      next = Replace[ OptionValue[ RandomInfraConnection, { opts }, "NextVertexFunction" ],
        Automatic :> If[ count === All, Identity, RandomSample ] ] },
    { vertices = VertexList @ total, indexedTotal = IndexGraph @ total },
    { index = AssociationThread[ vertices, Range @ Length @ vertices ],
      fibers = GroupBy[ Range @ Length @ vertices, Lookup[ projection, Key @ vertices[[ # ]] ] & ] },
    { groups = Map[
        edge |-> With[ { left = Lookup[ fibers, Key @ First @ edge ], right = Lookup[ fibers, Key @ Last @ edge ] },
          { left, right, Graph[ Join[ left, right ],
              Catenate @ Map[ source |-> UndirectedEdge[ source, # ] & /@
                Select[ right, EdgeQ[ indexedTotal, UndirectedEdge[ source, # ] ] & ], left ] ] } ],
        EdgeList @ base ] },
    { slots = Catenate @ MapIndexed[ { group, position } |-> ( { First @ position, # } & /@ First @ group ), groups ],
      starts = Most @ FoldList[ Plus, 1, Length /@ ( First /@ groups ) ],
      feasible = AllTrue[ groups, Length @ First @ # === Length @ #[[ 2 ]] &&
        Length @ FindIndependentEdgeSet[ #[[ 3 ]] ] === Length @ First @ # & ],
      order = candidates |-> If[ candidates === { }, { True, { } },
        With[ { labels = vertices[[ candidates ]] },
          { selected = next @ labels },
          { selectedList = If[ MemberQ[ labels, Verbatim @ selected ], { selected }, selected ] },
          If[ ListQ @ selectedList && DuplicateFreeQ @ selectedList &&
              AllTrue[ selectedList, MemberQ[ labels, Verbatim @ # ] & ],
            { True, Lookup[ index, Key /@ selectedList ] }, { False, { } } ] ] ] },
    (* A maximum matching decides feasibility; the stack enumerates in candidate order and stops at the requested count. *)
    { search = Reap @ NestWhile[
        Apply[ { stack, found, valid } |-> With[ { chosen = First @ stack },
          If[ Length @ chosen === Length @ slots,
            ( Sow @ InfraConnection @ MapThread[
                { slot, target } |-> UndirectedEdge[ vertices[[ Last @ slot ]], vertices[[ target ]] ], { slots, chosen } ];
              { Rest @ stack, found + 1, valid } ),
            With[ { position = Length @ chosen + 1 },
              { group = slots[[ position, 1 ]], source = slots[[ position, 2 ]] },
              { used = Drop[ chosen, starts[[ group ]] - 1 ],
                left = Drop[ groups[[ group, 1 ]], position - starts[[ group ]] + 1 ] },
              { candidates = Select[ groups[[ group, 2 ]], target |->
                  ! MemberQ[ used, target ] && EdgeQ[ groups[[ group, 3 ]], UndirectedEdge[ source, target ] ] &&
                    Length @ FindIndependentEdgeSet @ Subgraph[ groups[[ group, 3 ]],
                      Join[ left, Complement[ groups[[ group, 2 ]], Append[ used, target ] ] ] ] === Length @ left ] },
              { ordered = order @ candidates },
              { Join[ Append[ chosen, # ] & /@ Last @ ordered, Rest @ stack ], found, First @ ordered } ] ] ] ],
        { If[ feasible, { { } }, { } ], 0, True },
        state |-> First @ state =!= { } && state[[ 2 ]] < cap && Last @ state ] },
    { members = Catenate @ Last @ search },
    Switch[ count,
      Automatic, First[ members, { } ],
      All, members,
      _UpTo, members,
      _, If[ Length @ members < count, { }, members ] ] /; Last @ First @ search ]

InfraHorizontalLift[ fib : _[ _Graph, __ ], connection : InfraConnection[ edges_List ], start_, walk : { __ } ] /;
    TrueQ[ InfraConnectionQ[ fib, connection ] ] && VertexQ[ InfraTotalGraph @ fib, start ] &&
    Lookup[ InfraFibrationAssociation @ fib, Key @ start ] === First @ walk &&
    With[ { base = InfraBaseGraph @ fib },
      AllTrue[ walk, VertexQ[ base, # ] & ] && AllTrue[ Partition[ walk, 2, 1 ], EdgeQ[ base, UndirectedEdge @@ # ] & ] ] :=
  With[ { vertices = VertexList @ InfraTotalGraph @ fib, projection = InfraFibrationAssociation @ fib },
    { index = AssociationThread[ vertices, Range @ Length @ vertices ], projected = Lookup[ projection, Key /@ vertices ] },
    { indexedConnection = Graph[ Range @ Length @ vertices, UndirectedEdge @@@ ( Lookup[ index, Key /@ ( List @@ # ) ] & /@ edges ) ] },
    vertices[[ FoldList[
      { vertex, baseVertex } |-> First @ Select[ AdjacencyList[ indexedConnection, vertex ], projected[[ # ]] === baseVertex & ],
      Lookup[ index, Key @ start ], Rest @ walk ] ]] ]

InfraParallelTransport[ fib : _[ _Graph, __ ], connection_InfraConnection, walk : { __ } ] /;
    TrueQ[ InfraConnectionQ[ fib, connection ] ] &&
    With[ { base = InfraBaseGraph @ fib },
      AllTrue[ walk, VertexQ[ base, # ] & ] && AllTrue[ Partition[ walk, 2, 1 ], EdgeQ[ base, UndirectedEdge @@ # ] & ] ] :=
  AssociationMap[ start |-> Last @ InfraHorizontalLift[ fib, connection, start, walk ],
    VertexList @ InfraFiber[ fib, First @ walk ] ]

InfraHolonomy[ fib : _[ _Graph, __ ], connection_InfraConnection, loop : { __ } ] /;
    First @ loop === Last @ loop && TrueQ[ InfraConnectionQ[ fib, connection ] ] &&
    With[ { base = InfraBaseGraph @ fib },
      AllTrue[ loop, VertexQ[ base, # ] & ] && AllTrue[ Partition[ loop, 2, 1 ], EdgeQ[ base, UndirectedEdge @@ # ] & ] ] :=
  With[ { transport = InfraParallelTransport[ fib, connection, loop ], fiber = VertexList @ InfraFiber[ fib, First @ loop ] },
    { index = AssociationThread[ fiber, Range @ Length @ fiber ] },
    PermutationCycles @ Lookup[ index, Key /@ Lookup[ transport, Key /@ fiber ] ] ]

FindInfraHorizontalLift[ fib : _[ _Graph, __ ], connection_InfraConnection, start_, walk_List,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All ) ] :=
  With[ { lift = InfraHorizontalLift[ fib, connection, start, walk ] },
    Switch[ count,
      All, { lift },
      _UpTo, Take[ { lift }, count ],
      _, If[ count > 1, { }, Take[ { lift }, count ] ] ] /; ListQ @ lift ]
