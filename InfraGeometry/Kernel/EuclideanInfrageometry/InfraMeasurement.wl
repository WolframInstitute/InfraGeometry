Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraMeasurement *)

InfraMeasurement[ graph_Graph, objs : { __ }, spec_ ] /;
    ! VertexQ[ graph, objs ] && ! AllTrue[ objs, vertex |-> VertexQ[ graph, vertex ] ] &&
      ( spec =!= "VertexDensity" || ! MatchQ[ objs, { ( _Graph | _List ) .. } ] ) :=
  InfraMeasurement[ graph, #, spec ] & /@ objs

InfraMeasurement[ graph_Graph, vertices : { __ }, property : "Subgraph" | "CountingMeasure" | "RiemannianMeasure" | { __String } | All ] /;
    VertexQ[ graph, vertices ] || AllTrue[ vertices, vertex |-> VertexQ[ graph, vertex ] ] :=
  InfraMeasurement[ graph, InfraMeasurement[ graph, vertices, "VertexDensity" ], property ]

InfraMeasurement[ graph_Graph, density_Association, All ] :=
  InfraMeasurement[ graph, density, { "VertexDensity", "Subgraph", "CountingMeasure", "RiemannianMeasure" } ]

(* a List of balls, shells and constant tubes reads every support off one GraphDistanceMatrix, the distance to a core the Min over its columns
   and the interval of a segment the two rows summing to the distance: one single-source GraphDistance costs 34 ms on a 989-vertex mesh, the
   whole matrix 10 ms *)

InfraMeasurement[ graph_Graph,
    regions : { ( InfraBall | InfraShell | InfraTube )[ _, _?NumericQ | Infinity | { _?NumericQ | Infinity, _?NumericQ | Infinity } ] .. },
    "VertexDensity" ] :=
  With[ { vlist = VertexList @ graph, n = VertexCount @ graph, dm = GraphDistanceMatrix @ graph },
    { index = AssociationThread[ vlist -> Range @ n ],
      bands = Replace[ regions, {
          ( InfraBall | InfraTube )[ c_, r : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List ] ] :> { { c, 0, r } },
          ( InfraBall | InfraShell | InfraTube )[ c_, { r_, s_ } ] :> { { c, r, s } },
          InfraShell[ c_, r : Except[ _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List ] ] :> { { c, r, r } } }, { 1 } ] },
    { distances = AssociationMap[
        core |-> Clip[
          Min /@ dm[[ All, Lookup[ index, Which[
            VertexQ[ graph, core ], { core },
            MatchQ[ core, _List | _Association | _Graph ], Keys @ InfraMeasurement[ graph, core, "VertexDensity" ],
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

InfraMeasurement[ graph_Graph, obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraEquidistantSet | _List ], props : { __String } ] :=
  AssociationMap[ InfraMeasurement[ graph, obj, # ] &, props ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List |
                  _Association | _InfraForwardDeformation | InfraIntersection[ __ ] | InfraUnion[ __ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] |
                  _InfraIntegral | _InfraDifferential | _InfraCodifferential | _InfraAntiderivative | _InfraDerivative ], All ] :=
  InfraMeasurement[ graph, obj,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

InfraMeasurement[ _Graph, ( InfraSegment | InfraHalfLine | InfraInfiniteLine )[ __ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List |
                  _InfraGeodesic | InfraSegment[ _, _, __ ] | InfraArc[ _, Except[ { p_, ___, p_ }, { _, _, __ } ], ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], "Cardinality" ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
    Total @ Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ],
            <| |>, TopologicalSort @ dag ] },
        Total @ Lookup[ alpha, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ] ],
      dags ] /; MatchQ[ dags, { ___Graph } ] ]

InfraMeasurement[ graph_Graph, vertex_, "VertexDensity" ] /; VertexQ[ graph, vertex ] :=
  <| vertex -> 1 |>

InfraMeasurement[ graph_Graph, density_Association, "VertexDensity" ] :=
  If[ VertexQ[ graph, density ], <| density -> 1 |>, KeySort @ density ]

InfraMeasurement[ graph_Graph, object_Graph, "VertexDensity" ] :=
  If[ VertexQ[ graph, object ], <| object -> 1 |>,
    KeySort @ Which[
      AllTrue[ VertexList[ object ], MatchQ[ { _Integer, _ } ] ] &&
          Sort[ First /@ VertexList[ object ] ] === Range[ VertexCount[ object ] ],
        Counts[ Last /@ VertexList[ object ] ],
      ! LoopFreeGraphQ[ object ] || ! AcyclicGraphQ[ object ], Counts[ VertexList[ object ] ],
      True,
        With[ { incoming = GroupBy[ EdgeList[ object ], Last -> First ],
            outgoing = GroupBy[ EdgeList[ object ], First -> Last ], order = TopologicalSort[ object ] },
          { prefixes = Fold[ { counts, vertex } |-> Append[ counts, vertex -> Replace[ Lookup[ incoming, Key[ vertex ], { } ],
                { { } -> 1, previous_ :> Total[ Lookup[ counts, Key /@ previous ] ] } ] ], <| |>, order ],
            suffixes = Fold[ { counts, vertex } |-> Append[ counts, vertex -> Replace[ Lookup[ outgoing, Key[ vertex ], { } ],
                { { } -> 1, following_ :> Total[ Lookup[ counts, Key /@ following ] ] } ] ], <| |>, Reverse[ order ] ] },
          AssociationMap[ vertex |-> Lookup[ prefixes, Key[ vertex ] ] Lookup[ suffixes, Key[ vertex ] ], VertexList[ object ] ] ] ] ]

InfraMeasurement[ graph_Graph, objects_List, "VertexDensity" ] /;
    VertexQ[ graph, objects ] || AllTrue[ objects, vertex |-> VertexQ[ graph, vertex ] ] :=
  If[ VertexQ[ graph, objects ], <| objects -> 1 |>, KeySort[ Counts[ objects ] ] ]

(* GroupBy sums 16000 walk marginals in 0.2 s; Merge[..., Total] took 18 s. *)
InfraMeasurement[ graph_Graph, objects : { ( _Graph | _List ) .. }, "VertexDensity" ] /;
    ! VertexQ[ graph, objects ] && ! AllTrue[ objects, vertex |-> VertexQ[ graph, vertex ] ] :=
  With[ { densities = InfraMeasurement[ graph, #, "VertexDensity" ] & /@ objects },
    KeySort @ GroupBy[ Catenate[ Normal /@ densities ], First -> Last, Total ] /;
      AllTrue[ densities, AssociationQ ] ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List |
                  _Graph | _Association | _InfraGeodesic | _InfraWalk | _InfraPoint | _InfraForwardDeformation |
                  InfraIntersection[ __ ] | InfraUnion[ __ ] | InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] ], "VertexDensity" ] /; ! VertexQ[ graph, obj ] :=
  With[ { graphObject = InfraMeasurement[ graph, obj, "Graph" ] },
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
      Replace[ graphObject, dag_Graph :> { dag } ] ],
    Total ] /; MatchQ[ graphObject, _Graph | { ___Graph } ] ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List |
                  _InfraGeodesic | _InfraForwardDeformation | InfraIntersection[ __ ] | InfraUnion[ __ ] | InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] ], "EdgeDensity" ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
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
        dags ],
      Total ] /; MatchQ[ dags, { ___Graph } ] ]

InfraMeasurement[ graph_Graph,
    obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List |
                  _InfraGeodesic | InfraSegment[ _, _, __ ] | InfraArc[ _, Except[ { p_, ___, p_ }, { _, _, __ } ], ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], "Length" ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
    Replace[
      Union @@ Map[
        dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ GraphDistance[ dag, s, t ],
            { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
            { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
        dags ],
      { one_ } :> one ] /; MatchQ[ dags, { ___Graph } ] ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List ], "Subgraph" ] :=
  With[ { density = InfraMeasurement[ graph, obj, "VertexDensity" ] },
    Subgraph[ graph, Keys @ density ] /; AssociationQ @ density ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List ], "CountingMeasure" ] :=
  With[ { density = InfraMeasurement[ graph, obj, "VertexDensity" ] },
    Length @ density /; AssociationQ @ density ]

InfraMeasurement[ graph_Graph, obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List ], "RiemannianMeasure" ] :=
  With[ { density = InfraMeasurement[ graph, obj, "VertexDensity" ] },
    With[ { support = Keys @ density },
      { inside = AssociationThread[ support, True ] },
      Count[ support, v_ /; AllTrue[ AdjacencyList[ graph, v ], TrueQ @ Lookup[ inside, Key @ # ] & ] ] ] /; AssociationQ @ density ]

InfraMemberQ[ graph_Graph,
    obj : Except[ _InfraDeformation | _InfraCircleThrough | _InfraMidpoint | _InfraPerpendicularBisector | _InfraEquidistantSet | _InfraRegionNearest | _List |
                  _InfraGeodesic | _InfraForwardDeformation | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ } | { p_, p_ } | { _ }, ___ ] |
                  InfraCircle[ _, _, ___ ] |
                  ( InfraBall | InfraShell | InfraSphere )[ _, _ ] |
                  ( InfraTube | InfraCylinder | InfraCone | InfraSolidOfRevolution )[ _, _, ___Rule ] |
                  ( InfraBallHull | InfraConvexHull | InfraQuadric )[ _, ___ ] ], path_List ] :=
  With[ { dags = Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] },
    path =!= { } &&
    AnyTrue[ dags,
      dag |-> VertexQ[ dag, First @ path ] && VertexInDegree[ dag, First @ path ] == 0 &&
        VertexQ[ dag, Last @ path ] && VertexOutDegree[ dag, Last @ path ] == 0 &&
        AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ] /; MatchQ[ dags, { ___Graph } ] ]

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
