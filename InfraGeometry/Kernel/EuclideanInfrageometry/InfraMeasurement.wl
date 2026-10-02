Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraMeasurement *)

PackageScope[ takeRepresentatives ]
PackageScope[ searchMethod ]

InfraMeasurement[ graph_Graph, objs : { __ }, spec_ ] :=
  InfraMeasurement[ graph, #, spec ] & /@ objs

InfraMeasurement[ graph_Graph, obj : Except[ _List ], props : { __String } ] :=
  AssociationMap[ InfraMeasurement[ graph, obj, # ] &, props ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraIntersection[ __ ] | InfraUnion[ __ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] ], All ] :=
  InfraMeasurement[ graph, obj,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph",
      "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" } ]

InfraMeasurement[ _Graph, ( InfraSegment | InfraRay | InfraLine )[ __ ], "Faithful" ] :=
  True

InfraMeasurement[ _Graph, ( InfraCircle | InfraArc )[ __ ], "Faithful" ] :=
  Undetermined

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] ], "Cardinality" ] :=
  Total @ Map[
    dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
      { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
              { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ],
          <| |>, TopologicalSort @ dag ] },
      Total @ Lookup[ alpha, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ] ],
    Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraIntersection[ __ ] | InfraUnion[ __ ] | ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] ], "VertexDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        AssociationMap[ Lookup[ alpha, Key @ # ] Lookup[ beta, Key @ # ] &, VertexList @ dag ] ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    Total ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraCircle[ _, _, ___ ] | ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] ], "EdgeDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        Association[ # -> Lookup[ alpha, Key @ First @ # ] Lookup[ beta, Key @ Last @ # ] & /@ EdgeList @ dag ] ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    Total ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] |
                  InfraCircle[ _, _, ___ ] | ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] ], "Length" ] :=
  Replace[
    Union @@ Map[
      dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ GraphDistance[ dag, s, t ],
          { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
          { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    { one_ } :> one ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "Subgraph" ] :=
  Subgraph[ graph, Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "Volume" ] :=
  Length @ InfraMeasurement[ graph, obj, "VertexDensity" ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "BoundaryVolume" ] :=
  With[ { support = Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] },
    { inside = AssociationThread[ support, True ] },
    Count[ support, v_ /; AnyTrue[ AdjacencyList[ graph, v ], ! TrueQ @ Lookup[ inside, Key @ # ] & ] ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "InteriorVolume" ] :=
  InfraMeasurement[ graph, obj, "Volume" ] - InfraMeasurement[ graph, obj, "BoundaryVolume" ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "HalfBoundaryVolume" ] :=
  InfraMeasurement[ graph, obj, "Volume" ] - InfraMeasurement[ graph, obj, "BoundaryVolume" ] / 2

FindInfraRepresentative[ graph_Graph,
    obj : ( InfraSegment | InfraRay | InfraLine )[ Except[ _Rule | _RuleDelayed ], Except[ _Rule | _RuleDelayed ] ] |
      InfraArc[ _, { _, _ }, ___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  With[ {
      cap     = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
      prune   = Lookup[ Association @ Cases[ { mods }, _Rule ], "Pruning", 0 ],
      randomQ = MemberQ[ { mods }, "RandomChoice" ],
      dags    = Select[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ], VertexCount[ # ] > 0 & ] },
    { engines = Map[
        dag |-> With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ] },
          { beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
                  { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
              <| |>, Reverse @ TopologicalSort @ dag ] },
          { out, beta, Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] } ],
        dags ] },
    { draw = { out, beta, sources } |->
        NestWhile[
          path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
            Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
          { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
          path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ] },
    { members = If[ randomQ && cap < Infinity && engines =!= { },
        Table[ draw @@ RandomChoice[ ( Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines ) -> engines ], cap ],
        Catenate @ Last @ Reap @ Fold[
          { found, engine } |-> With[ { out = First @ engine },
            Last @ NestWhile[
              Apply[ { stack, got } |-> With[ { path = First @ stack },
                { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
                If[ nexts === { },
                  ( Sow[ path ]; { Rest @ stack, got + 1 } ),
                  { Join[ Append[ path, # ] & /@ If[ prune > 0, Select[ nexts, RandomReal[ ] >= prune & ], nexts ], Rest @ stack ],
                    got } ] ] ],
              { List /@ Last @ engine, found },
              state |-> First @ state =!= { } && Last @ state < cap ] ],
          0, engines ] ] },
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     Take[ members, count ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

InfraMemberQ[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] |
                  InfraCircle[ _, _, ___ ] | ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] ], path_List ] :=
  path =!= { } &&
  AnyTrue[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ],
    dag |-> VertexQ[ dag, First @ path ] && VertexInDegree[ dag, First @ path ] == 0 &&
      VertexQ[ dag, Last @ path ] && VertexOutDegree[ dag, Last @ path ] == 0 &&
      AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ]

takeRepresentatives[ members_List, count_, mods___ ] :=
  If[ MemberQ[ { mods }, "RandomChoice" ] && count =!= All && members =!= { },
    Replace[ count, { Automatic :> RandomChoice @ members, UpTo[ n_ ] | n_ :> RandomChoice[ members, n ] } ],
    Switch[ count,
      Automatic, First[ members, { } ],
      All,       members,
      _UpTo,     Take[ members, count ],
      _,         If[ Length @ members < count, { }, Take[ members, count ] ] ] ]

takeRepresentatives[ member : Except[ _List ], ___ ] :=
  member

searchMethod[ mods___ ] :=
  Which[
    MemberQ[ { mods }, "RandomChoice" ], { Method -> "RandomGreedy" },
    Lookup[ Association @ Cases[ { mods }, _Rule ], "Pruning", 0 ] > 0,
      { Method -> { "Exhaustive", "Pruning" -> Lookup[ Association @ Cases[ { mods }, _Rule ], "Pruning" ] } },
    True, { } ]

InfraSubgraph[ graph_Graph, obj_ -> t_Integer ] :=
  Subgraph[ graph,
    VertexList @ NeighborhoodGraph[ graph, Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ], t ] ]

InfraSubgraph[ graph_Graph, obj : Except[ _Rule | _RuleDelayed ] ] :=
  InfraMeasurement[ graph, obj, "Subgraph" ]

InfraMeasurement[ graph_Graph, InfraIntersection[ objs__ ], "VertexDensity" ] :=
  With[ { densities = InfraMeasurement[ graph, #, "VertexDensity" ] & /@ { objs } },
    KeySort @ KeyTake[ Merge[ densities, Apply[ Times ] ], Intersection @@ ( Keys /@ densities ) ] ]

InfraMeasurement[ graph_Graph, InfraUnion[ objs__ ], "VertexDensity" ] :=
  KeySort @ Merge[ InfraMeasurement[ graph, #, "VertexDensity" ] & /@ { objs }, Total ]

InfraMeasurement[ graph_Graph, obj : ( InfraIntersection | InfraUnion )[ __ ], All ] :=
  InfraMeasurement[ graph, obj,
    { "VertexDensity", "Subgraph", "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" } ]
