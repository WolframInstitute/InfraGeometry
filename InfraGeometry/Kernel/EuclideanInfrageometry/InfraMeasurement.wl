Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraMeasurement *)

InfraMeasurement[ graph_Graph, objs : { __ }, spec_ ] :=
  InfraMeasurement[ graph, #, spec ] & /@ objs

(* a List of balls, shells and constant tubes reads every support off one GraphDistanceMatrix, the distance to a core the Min over its columns
   and the interval of a segment the two rows summing to the distance: one single-source GraphDistance costs 34 ms on a 989-vertex mesh, the
   whole matrix 10 ms *)

InfraMeasurement[ graph_Graph,
    regions : { ( InfraBall | InfraShell | InfraTube )[ _, _?NumericQ | Infinity | { _?NumericQ | Infinity, _?NumericQ | Infinity } ] .. },
    "VertexDensity" ] :=
  With[ { vlist = VertexList @ graph, n = VertexCount @ graph, dm = GraphDistanceMatrix @ graph },
    { index = AssociationThread[ vlist -> Range @ n ],
      bands = Replace[ regions, {
          ( InfraBall | InfraTube )[ c_, r : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List ] ] :> { { c, 0, r } },
          ( InfraBall | InfraShell | InfraTube )[ c_, { r_, s_ } ] :> { { c, r, s } },
          InfraShell[ c_, r : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List ] ] :> { { c, r, r } } }, { 1 } ] },
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
    regions : { ( InfraBall | InfraShell | InfraTube )[ _, _?NumericQ | Infinity | { _?NumericQ | Infinity, _?NumericQ | Infinity } ] .. },
    "CountingMeasure" ] :=
  Length /@ InfraMeasurement[ graph, regions, "VertexDensity" ]

InfraMeasurement[ graph_Graph,
    regions : { ( InfraBall | InfraShell | InfraTube )[ _, _?NumericQ | Infinity | { _?NumericQ | Infinity, _?NumericQ | Infinity } ] .. },
    "RiemannianMeasure" ] :=
  With[ { n = VertexCount @ graph, index = AssociationThread[ VertexList @ graph -> Range @ VertexCount @ graph ],
          adjacency = Sign[ AdjacencyMatrix @ graph + Transpose @ AdjacencyMatrix @ graph ] },
    Map[
      support |-> With[ { inside = Normal @ SparseArray[ Thread[ Lookup[ index, support ] -> 1 ], n ] },
        Total[ inside ( 1 - Sign[ adjacency . ( 1 - inside ) ] ) ] ],
      Keys /@ InfraMeasurement[ graph, regions, "VertexDensity" ] ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List ], props : { __String } ] :=
  AssociationMap[ InfraMeasurement[ graph, obj, # ] &, props ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List | InfraIntersection[ __ ] | InfraUnion[ __ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], All ] :=
  InfraMeasurement[ graph, obj,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

InfraMeasurement[ _Graph, ( InfraSegment | InfraHalfLine | InfraInfiniteLine )[ __ ], "Faithful" ] :=
  True

InfraMeasurement[ _Graph, InfraArc[ __ ], "Faithful" ] :=
  Undetermined

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List | InfraSegment[ _, _, __ ] | InfraArc[ _, Except[ { p_, ___, p_ }, { _, _, __ } ], ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], "Cardinality" ] :=
  Total @ Map[
    dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
      { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
              { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ],
          <| |>, TopologicalSort @ dag ] },
      Total @ Lookup[ alpha, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ] ],
    Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ]

InfraMeasurement[ graph_Graph, density_Association, "VertexDensity" ] :=
  KeySort @ density

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List | InfraIntersection[ __ ] | InfraUnion[ __ ] | InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] |
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
    obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List | InfraIntersection[ __ ] | InfraUnion[ __ ] | InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] |
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
    obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List | InfraSegment[ _, _, __ ] | InfraArc[ _, Except[ { p_, ___, p_ }, { _, _, __ } ], ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], "Length" ] :=
  Replace[
    Union @@ Map[
      dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ GraphDistance[ dag, s, t ],
          { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
          { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    { one_ } :> one ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List ], "Subgraph" ] :=
  Subgraph[ graph, Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List ], "CountingMeasure" ] :=
  Length @ InfraMeasurement[ graph, obj, "VertexDensity" ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List ], "RiemannianMeasure" ] :=
  With[ { support = Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] },
    { inside = AssociationThread[ support, True ] },
    Count[ support, v_ /; AllTrue[ AdjacencyList[ graph, v ], TrueQ @ Lookup[ inside, Key @ # ] & ] ] ]

InfraMemberQ[ graph_Graph,
    obj : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraRegionNearest | _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] |
                  InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], path_List ] :=
  path =!= { } &&
  AnyTrue[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ],
    dag |-> VertexQ[ dag, First @ path ] && VertexInDegree[ dag, First @ path ] == 0 &&
      VertexQ[ dag, Last @ path ] && VertexOutDegree[ dag, Last @ path ] == 0 &&
      AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ]

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

InfraMeasurement[ graph_Graph, InfraUnion[ objs__ ], "EdgeDensity" ] :=
  KeySort @ Merge[ InfraMeasurement[ graph, #, "EdgeDensity" ] & /@ { objs }, Total ]

InfraMeasurement[ graph_Graph, obj : InfraIntersection[ __ ], All ] :=
  InfraMeasurement[ graph, obj,
    { "VertexDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraMeasurement[ graph_Graph, obj : InfraUnion[ __ ], All ] :=
  InfraMeasurement[ graph, obj,
    { "VertexDensity", "EdgeDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

InfraMeasurement[ graph_Graph, token : _InfraRay | _InfraLine | _InfraPolygon, property_ ] :=
  InfraMeasurement[ graph, Replace[ token, { InfraRay[ args___ ] :> InfraHalfLine[ args ],
    InfraLine[ args___ ] :> InfraInfiniteLine[ args ], InfraPolygon[ args___ ] :> InfraRegularPolygon[ args ] } ], property ]

InfraMemberQ[ graph_Graph, token : _InfraRay | _InfraLine | _InfraPolygon, representative_ ] :=
  InfraMemberQ[ graph, Replace[ token, { InfraRay[ args___ ] :> InfraHalfLine[ args ],
    InfraLine[ args___ ] :> InfraInfiniteLine[ args ], InfraPolygon[ args___ ] :> InfraRegularPolygon[ args ] } ], representative ]
