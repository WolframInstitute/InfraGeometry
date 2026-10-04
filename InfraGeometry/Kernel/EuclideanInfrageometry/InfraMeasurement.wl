Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraMeasurement *)

PackageScope[ takeRepresentatives ]
PackageScope[ searchMethod ]

InfraMeasurement[ graph_Graph, objs : { __ }, spec_ ] :=
  InfraMeasurement[ graph, #, spec ] & /@ objs

(* a List of region heads reads every support off one GraphDistanceMatrix, the distance to a core the Min over its columns and the interval
   of a segment the two rows summing to the distance: one single-source GraphDistance costs 34 ms on a 989-vertex mesh, the whole matrix 10 ms *)

InfraMeasurement[ graph_Graph,
    regions : { ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] .. }, "VertexDensity" ] :=
  With[ { vlist = VertexList @ graph, n = VertexCount @ graph, dm = GraphDistanceMatrix @ graph },
    { index = AssociationThread[ vlist -> Range @ n ],
      bands = Replace[ regions, {
          ( InfraBall | InfraTube | InfraCylinder )[ c_, r : Except[ _List ] ] :> { { c, 0, r } },
          ( InfraBall | InfraShell | InfraTube | InfraCylinder )[ c_, { r_, s_ } ] :> { { c, r, s } },
          InfraShell[ c_, r : Except[ _List ] ] :> { { c, r, r } },
          InfraCone[ axis_List, slope_ ] :> MapIndexed[ { a, i } |-> { a, 0, slope ( First @ i - 1 ) }, axis ] }, { 1 } ] },
    { distances = AssociationMap[
        core |-> Clip[
          Min /@ dm[[ All, Lookup[ index, Which[
            VertexQ[ graph, core ], { core },
            MatchQ[ core, _List | _Association | _Graph ], Keys @ InfraDensity[ graph, core ],
            MatchQ[ core, InfraSegment[ p_, q_ ] /; VertexQ[ graph, p ] && VertexQ[ graph, q ] ],
              With[ { d = dm[[ Lookup[ index, Key @ First @ core ], Lookup[ index, Key @ Last @ core ] ]] },
                If[ d === Infinity, { },
                  Pick[ vlist, dm[[ Lookup[ index, Key @ First @ core ] ]] + dm[[ Lookup[ index, Key @ Last @ core ] ]], d ] ] ],
            True, Keys @ InfraMeasurement[ graph, core, "VertexDensity" ] ] ] ]],
          { 0, n + 1 } ],
        DeleteDuplicates @ Catenate[ bands ][[ All, 1 ]] ] },
    Map[
      triples |-> AssociationThread[
        Sort @ Pick[ vlist,
          Sign @ Total[ ( { core, lo, hi } |-> UnitStep[ Lookup[ distances, Key @ core ] - Ceiling[ lo ] ] *
              UnitStep[ Floor @ Min[ hi, n ] - Lookup[ distances, Key @ core ] ] ) @@@ triples ],
          1 ],
        1 ],
      bands ] ]

InfraMeasurement[ graph_Graph,
    regions : { ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] .. }, "CountingMeasure" ] :=
  Length /@ InfraMeasurement[ graph, regions, "VertexDensity" ]

InfraMeasurement[ graph_Graph,
    regions : { ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone )[ _, _ ] .. }, "RiemannianMeasure" ] :=
  With[ { n = VertexCount @ graph, index = AssociationThread[ VertexList @ graph -> Range @ VertexCount @ graph ],
          adjacency = Sign[ AdjacencyMatrix @ graph + Transpose @ AdjacencyMatrix @ graph ] },
    Map[
      support |-> With[ { inside = Normal @ SparseArray[ Thread[ Lookup[ index, support ] -> 1 ], n ] },
        Total[ inside ( 1 - Sign[ adjacency . ( 1 - inside ) ] ) ] ],
      Keys /@ InfraMeasurement[ graph, regions, "VertexDensity" ] ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], props : { __String } ] :=
  AssociationMap[ InfraMeasurement[ graph, obj, # ] &, props ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraIntersection[ __ ] | InfraUnion[ __ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone | InfraSphere )[ _, _ ] ], All ] :=
  InfraMeasurement[ graph, obj,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

InfraMeasurement[ _Graph, ( InfraSegment | InfraRay | InfraLine )[ __ ], "Faithful" ] :=
  True

InfraMeasurement[ _Graph, InfraArc[ __ ], "Faithful" ] :=
  Undetermined

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, Except[ { p_, ___, p_ }, { _, _, __ } ], ___ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone | InfraSphere )[ _, _ ] ], "Cardinality" ] :=
  Total @ Map[
    dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
      { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
              { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ],
          <| |>, TopologicalSort @ dag ] },
      Total @ Lookup[ alpha, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ] ],
    Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraIntersection[ __ ] | InfraUnion[ __ ] | InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone | InfraSphere )[ _, _ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] ], "VertexDensity" ] :=
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
    obj : Except[ _List | InfraCircle[ _, _, ___ ] | ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone | InfraSphere )[ _, _ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] ], "EdgeDensity" ] :=
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
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, Except[ { p_, ___, p_ }, { _, _, __ } ], ___ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone | InfraSphere )[ _, _ ] ], "Length" ] :=
  Replace[
    Union @@ Map[
      dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ GraphDistance[ dag, s, t ],
          { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
          { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    { one_ } :> one ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "Subgraph" ] :=
  Subgraph[ graph, Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "CountingMeasure" ] :=
  Length @ InfraMeasurement[ graph, obj, "VertexDensity" ]

InfraMeasurement[ graph_Graph, obj : Except[ _List ], "RiemannianMeasure" ] :=
  With[ { support = Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] },
    { inside = AssociationThread[ support, True ] },
    Count[ support, v_ /; AllTrue[ AdjacencyList[ graph, v ], TrueQ @ Lookup[ inside, Key @ # ] & ] ] ]

FindInfraRepresentative[ graph_Graph,
    obj : ( InfraSegment | InfraRay | InfraLine )[ Except[ _Rule | _RuleDelayed ], Except[ _Rule | _RuleDelayed ] ] |
      InfraArc[ _, Except[ { p_, p_ }, { _, _ } ], ___Rule ],
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
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] |
                  InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraTube | InfraCylinder | InfraCone | InfraSphere )[ _, _ ] ], path_List ] :=
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
  With[ { prune = Lookup[ Association @ Cases[ { mods }, _Rule ], "Pruning", 0 ] },
    Which[
      MemberQ[ { mods }, "RandomChoice" ], { "NextVertexFunction" -> RandomSample },
      prune === 0 || prune === Infinity, { },
      IntegerQ[ prune ], { "NextVertexFunction" -> ( RandomSample[ #, UpTo[ prune ] ] & ) },
      True, { "NextVertexFunction" -> ( RandomSample[ #, UpTo[ Max[ 1, Round[ prune Length @ # ] ] ] ] & ) } ] ]

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
    { "VertexDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]
