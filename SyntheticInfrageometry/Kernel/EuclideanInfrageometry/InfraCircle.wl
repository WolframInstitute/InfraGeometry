Package["WolframInstitute`SyntheticInfrageometry`"]

PackageScope[circlePool]

(* WolframInstitute`SyntheticInfrageometry` :: EuclideanInfrageometry :: InfraCircle *)


(* ===================== InfraCircle ===================== *)

(* the circles around c through p as an object.  A circle around c through p is a shortest simple cycle of the band { v : r - tIn <= d(c, v) <= r + tOut }, r = d(c, p), that passes through p and separates c from { v : d(c, v) > r + tOut }; InfraCircle[graph, c, p] evaluates to InfraCircle[<| "Atoms" -> {dag, ...}, "Center" -> c, "Point" -> p, "Band" -> {rmin, rmax}, "Graph" -> union, "Closed" -> True |>] and stands for all of them at once.  The carrier is the circle pool cut along a radial seam through p (CirclePoolStructure): an atom is a contiguous arc S of the seam with a pair (u, v) of cut-shell ends and stands for the cycles S ++ (a v-u geodesic of the cut shell); the atoms through p are rotated to start at p, so each is a DAG with source p, sinks adjacent to p and the closing edge implicit -- exact on a planar local graph whose band the seam cuts open, and off that class the cycles through p come from the length sweep, one path atom each, under ::uncertified.  "Graph" is the union of the atoms with their closing edges, the atoms oriented alike wherever the positions they share allow it; its directed closed walks through p are exactly the circles when it is acyclic away from p, which need not be -- two circles can pass a neighbour of p once leaving and once returning.  circle[[i]] is the i-th circle as a directed cycle graph, "Multiplicity", "InfraDensity", "EdgeDensity" and "Length" the DP.  Without the graph, InfraCircle[c, r] is the InfraScene token *)

InfraCircle::uncertified = "The circle carrier of the band `1` around `2` is not certified exact; the circles through `3` come from the cycle sweep instead.";

Options[ InfraCircle ] = { "Tolerance" -> 0 };

InfraCircle[ graph_Graph, center_, p_, OptionsPattern[] ] :=
  With[ { r = GraphDistance[ graph, center, p ],
          tolerance = Replace[ OptionValue[ "Tolerance" ], t : Except[ _List ] :> { t, t } ] },
    { band = { Max[ 1, r - First @ tolerance ], r + Last @ tolerance } },
    { localG = If[ r === Infinity, Graph[ { }, { } ], NeighborhoodGraph[ graph, center, Last @ band + 2 ] ] },
    { dist = AssociationThread[ VertexList @ localG, GraphDistance[ localG, center ] ] },
    { shellVs = Select[ VertexList @ localG, First @ band <= dist[ # ] <= Last @ band & ],
      outside  = Select[ VertexList @ localG, dist[ # ] == Last @ band + 1 & ] },
    { shell = Subgraph[ localG, shellVs ],
      separatingQ = verts |-> With[ { component = SelectFirst[ ConnectedComponents @ VertexDelete[ localG, verts ], MemberQ[ #, center ] & ] },
        component =!= Missing[ "NotFound" ] && AllTrue[ component, dist[ # ] <= Last @ band & ] ],
      (* the seam is a radial geodesic through p when one reaches the outside, and c's first radial geodesic otherwise -- p then sits in the cut shell and the atoms through it are sub-DAGs *)
      seam = If[ outside === { }, { },
        With[ { radial = Select[ outside, dist[ # ] == r + GraphDistance[ localG, p, # ] & ] },
          Take[ If[ radial === { }, FindShortestPath[ localG, center, First @ outside ],
                    Join[ FindShortestPath[ localG, center, p ], Rest @ FindShortestPath[ localG, p, First @ radial ] ] ],
                { First @ band + 1, Last @ band + 1 } ] ] ] },
    { cut = VertexDelete[ shell, seam ], cutSet = Complement[ shellVs, seam ] },
    { atoms = Catenate @ Map[
        arc |-> Map[
          ends |-> With[ { u = First @ ends, v = Last @ ends },
            { dvu = GraphDistance[ cut, v, u ], i = FirstPosition[ arc, p, { 0 } ][[ 1 ]] },
            { edges = Which[
                dvu === Infinity, None,
                i > 0,
                  Join[ DirectedEdge @@@ Partition[ Join[ arc[[ i ;; ]], { v } ], 2, 1 ],
                        EdgeList @ GeodesicIntervalGraph[ cut, v, u ],
                        DirectedEdge @@@ Partition[ Join[ { u }, arc[[ ;; i - 1 ]] ], 2, 1 ] ],
                MemberQ[ cutSet, p ] && GraphDistance[ cut, v, p ] + GraphDistance[ cut, p, u ] == dvu,
                  Join[ EdgeList @ GeodesicIntervalGraph[ cut, p, u ],
                        DirectedEdge @@@ Partition[ Join[ { u }, arc, { v } ], 2, 1 ],
                        DeleteCases[ EdgeList @ GeodesicIntervalGraph[ cut, v, p ], DirectedEdge[ _, p ] ] ],
                True, None ] },
            If[ edges === None, Nothing,
              <| "Length" -> Length @ arc + dvu + 1,
                 "Graph" -> Graph[ Union @ Prepend[ Catenate[ List @@@ edges ], p ], Sort @ edges ] |> ] ],
          If[ Length @ arc == 1,
            Subsets[ Intersection[ AdjacencyList[ shell, First @ arc ], cutSet ], { 2 } ],
            Tuples[ { Intersection[ AdjacencyList[ shell, First @ arc ], cutSet ],
                      Intersection[ AdjacencyList[ shell, Last @ arc ], cutSet ] } ] ] ],
        Catenate @ Table[ Take[ seam, { i, j } ], { i, Length @ seam }, { j, i, Length @ seam } ] ] },
    (* the shortest length class with a separating representative; separation is an atom invariant on the certified class, so one path per atom decides *)
    { pool = Replace[
        Catch @ Scan[
          class |-> With[ { admissible = Select[ class,
              atom |-> separatingQ @ NestWhileList[ First @ VertexOutComponent[ atom[ "Graph" ], { # }, { 1 } ] &, p,
                VertexOutDegree[ atom[ "Graph" ], # ] > 0 & ] ] },
            If[ admissible =!= { }, Throw[ #[ "Graph" ] & /@ admissible ] ] ],
          Values @ KeySort @ GroupBy[ atoms, #[ "Length" ] & ] ],
        Null -> { } ] },
    (* certified when the local graph is planar and the seam cut the band open -- a non-empty pool, nothing outside, or a shell with no cycle at all; off that class the cycles through p are swept by length, and since a refusal costs nothing on an empty family the message fires only when circles exist that the carrier could not hold *)
    { carrier = If[ PlanarGraphQ @ localG && ( pool =!= { } || outside === { } || AcyclicGraphQ @ shell ), pool,
        With[ { cycles = Replace[
            Catch @ Scan[
              k |-> With[ { found = Select[ First /@ # & /@ FindCycle[ shell, { k }, All ], MemberQ[ #, p ] && separatingQ[ # ] & ] },
                If[ found =!= { }, Throw @ found ] ],
              Range[ 3, VertexCount @ shell ] ],
            Null -> { } ] },
          If[ cycles =!= { }, Message[ InfraCircle::uncertified, band, center, p ] ];
          PathGraph[ RotateLeft[ #, FirstPosition[ #, p ][[ 1 ]] - 1 ], DirectedEdges -> True ] & /@ cycles ] ] },
    (* one orientation for the union: two atoms sharing a vertex off p agree on its position or on its mirror image, a 2-colouring of the atoms; where neither holds the atoms stay as built *)
    { positions = AssociationThread[ VertexList @ #, GraphDistance[ #, p ] ] & /@ carrier, n = Length @ carrier },
    { circumference = If[ carrier === { }, 0, Max[ Values @ First @ positions ] + 1 ] },
    { constraints = Catch @ Flatten[ Table[
        With[ { shared = DeleteCases[ Intersection[ Keys @ positions[[ i ]], Keys @ positions[[ j ]] ], p ] },
          Which[
            shared === { }, { },
            AllTrue[ shared, positions[[ i ]][ # ] == positions[[ j ]][ # ] & ],
              { UndirectedEdge[ { i, 1 }, { j, 1 } ], UndirectedEdge[ { i, -1 }, { j, -1 } ] },
            AllTrue[ shared, positions[[ i ]][ # ] == circumference - positions[[ j ]][ # ] & ],
              { UndirectedEdge[ { i, 1 }, { j, -1 } ], UndirectedEdge[ { i, -1 }, { j, 1 } ] },
            True, Throw[ $Failed ] ] ],
        { i, n }, { j, i + 1, n } ], 2 ] },
    { components = If[ constraints === $Failed, $Failed,
        ConnectedComponents @ Graph[ Flatten[ Table[ { i, s }, { i, n }, { s, { 1, -1 } } ], 1 ], constraints ] ] },
    { signs = If[ components === $Failed || AnyTrue[ components, Length @ DeleteDuplicates[ First /@ # ] < Length @ # & ],
        ConstantArray[ 1, n ],
        Lookup[ Association @ Catenate[ Map[ component |-> ( First @ # -> Last @ # ) & /@ component,
            Select[ components, MemberQ[ #, { Min[ First /@ # ], 1 } ] & ] ] ], Range @ n, 1 ] ] },
    { oriented = MapThread[
        { atom, sign } |-> If[ sign == 1, atom,
          Graph[ VertexList @ atom, Join[ DeleteCases[ Reverse /@ EdgeList @ atom, DirectedEdge[ _, p ] ],
            DirectedEdge[ p, # ] & /@ Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ] ] ] ],
        { carrier, signs } ] },
    { closing = Catenate @ Map[ atom |-> DirectedEdge[ #, p ] & /@ Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ], oriented ] },
    InfraCircle @ <|
      "Atoms"  -> Map[ Graph[ Sort @ VertexList @ #, Sort @ EdgeList @ # ] &, Select[ oriented, EdgeCount[ # ] > 0 & ] ],
      "Center" -> center, "Point" -> p, "Band" -> band, "Closed" -> True,
      "Graph"  -> Graph[ Union @@ ( VertexList /@ oriented ), Union[ Catenate[ EdgeList /@ oriented ], closing ] ] |> ]


(* ===================== The InfraCircle object ===================== *)

(* the object protocol, one copy per head so that InfraCircle stands on its own: the atoms are geodesic DAGs whose source-to-sink paths are exactly the realisations, sorted so that the depth-first descent lists them in one lexicographic order.  Part enumerates on demand and the properties read the path-count DP off the atoms *)

InfraCircle[ data_Association ][ "Graph" ] :=
  Lookup[ data, "Graph",
    Graph[ Union @@ ( VertexList /@ data[ "Atoms" ] ), Union @@ ( EdgeList /@ data[ "Atoms" ] ) ] ]

(* the number of realisations: the occupation of an atom's source counts its source-to-sink paths *)
InfraCircle[ data_Association ][ "Multiplicity" ] := Total[ Max @ GeodesicOccupation @ # & /@ data[ "Atoms" ] ]

(* the occupation <| v -> m |>: the realisations through v *)
InfraCircle[ data_Association ][ "InfraDensity" ] := KeySort @ Merge[ GeodesicOccupation /@ data[ "Atoms" ], Total ]

(* the edge occupation keyed by the sorted vertex pair; the closing edges of the circles carry the paths that end at their sink *)
InfraCircle[ data_Association ][ "EdgeDensity" ] :=
  KeySort @ Merge[ Join[
      KeyMap[ Sort[ List @@ # ] &, GeodesicEdgeOccupation @ # ] & /@ data[ "Atoms" ],
      Map[ atom |-> With[ { occupation = GeodesicOccupation @ atom },
          Association[ Sort[ { #, data[ "Point" ] } ] -> occupation[ # ] & /@
            Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ] ] ],
        data[ "Atoms" ] ] ],
    Total ]

(* the realisation length: one number when every realisation shares it, the sorted list of the lengths present otherwise *)
InfraCircle[ data_Association ][ "Length" ] :=
  Replace[
    Union @@ Map[ atom |-> With[ { source = First @ Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] },
        Union[ GraphDistance[ atom, source, # ] & /@ Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ] ] + 1 ],
      data[ "Atoms" ] ],
    { one_ } :> one ]

InfraCircle[ data_Association ][ "VertexList" ] := Union @@ ( VertexList /@ data[ "Atoms" ] )

InfraCircle[ data_Association ][ "Realizations" ] := InfraCircle[ data ][[ All ]]
InfraCircle[ data_Association ][ "Realizations", n : ( _Integer | All ) ] := InfraCircle[ data ][[ 1 ;; n ]]
InfraCircle[ data_Association ][ "Realizations", UpTo[ n_Integer ] ] := InfraCircle[ data ][[ 1 ;; n ]]

InfraCircle[ data_Association ][ "Properties" ] :=
  Union[ Keys @ data, { "Graph", "Length", "Multiplicity", "InfraDensity", "EdgeDensity", "Realizations", "VertexList", "Properties" } ]

InfraCircle[ data_Association ][ prop_String ] := Lookup[ data, prop, Missing[ "KeyAbsent", prop ] ]

InfraCircle /: Part[ obj : InfraCircle[ _Association ], prop_String ] := obj[ prop ]

(* obj[[i]], obj[[i ;; j]], obj[[All]]: the realisations in canonical order -- atom by atom, and within an atom the depth-first descent of its sorted edges -- streamed only as far as asked *)
InfraCircle /: Part[ obj : InfraCircle[ data_Association ], spec : ( _Integer | _Span | All ) ] :=
  With[ { n = obj[ "Multiplicity" ] },
    { range = Replace[ spec, {
        All -> { 1, n, 1 },
        i_Integer :> { If[ i < 0, n + 1 + i, i ], If[ i < 0, n + 1 + i, i ], 1 },
        Span[ a_, b_, s_ : 1 ] :> { Replace[ a, k_Integer /; k < 0 :> n + 1 + k ],
                                   Replace[ b, { All -> n, k_Integer /; k < 0 :> n + 1 + k } ], s } } ] },
    { paths = Module[ { found = { }, descend },
        descend[ out_, path_ ] := With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
          If[ nexts === { },
            ( AppendTo[ found, path ]; If[ Length @ found >= range[[ 2 ]], Throw[ found, InfraCircle ] ] ),
            Scan[ descend[ out, Append[ path, # ] ] &, nexts ] ] ];
        Catch[
          Scan[ atom |-> With[ { out = GroupBy[ List @@@ EdgeList @ atom, First -> Last ] },
              Scan[ descend[ out, { # } ] &, Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] ] ],
            data[ "Atoms" ] ];
          found, InfraCircle ] ] },
    Which[
      ! IntegerQ @ spec,
        Graph[ #, DirectedEdge @@@ Partition[ #, 2, 1, 1 ] ] & /@ Take[ paths, { range[[ 1 ]], Min[ range[[ 2 ]], Length @ paths ], range[[ 3 ]] } ],
      1 <= range[[ 1 ]] <= n,
        Graph[ #, DirectedEdge @@@ Partition[ #, 2, 1, 1 ] ] & @ paths[[ range[[ 1 ]] ]],
      True,
        Message[ Part::partw, spec, obj ]; $Failed ] ]

InfraCircle /: Normal[ obj : InfraCircle[ _Association ] ] := obj[[ All ]]
InfraCircle /: Length[ obj : InfraCircle[ _Association ] ] := obj[ "Multiplicity" ]
InfraCircle /: First[ obj : InfraCircle[ _Association ] ] := obj[[ 1 ]]
InfraCircle /: VertexList[ obj : InfraCircle[ _Association ] ] := obj[ "VertexList" ]
InfraCircle /: HighlightGraph[ graph_Graph, obj : InfraCircle[ data_Association ], rest___ ] := HighlightGraph[ graph, data[ "Atoms" ], rest ]

InfraCircle /: MakeBoxes[ obj : InfraCircle[ data_Association ], fmt_ ] :=
  BoxForm`ArrangeSummaryBox[ InfraCircle, obj,
    Graphics[ { $InfraCircleColor, AbsoluteThickness[ 1.5 ], AbsolutePointSize[ 4 ], Circle[ { 0, 0 }, 1 ], Point[ { { 0, 0 }, { 1, 0 } } ] },
      PlotRange -> { { -1.4, 1.4 }, { -1.4, 1.4 } }, AspectRatio -> 1, Background -> None,
      ImageSize -> Dynamic[ { Automatic, 3.5 CurrentValue[ "FontCapHeight" ] / AbsoluteCurrentValue[ Magnification ] } ] ],
    Join[
      KeyValueMap[ { key, value } |-> BoxForm`SummaryItem[ { ToLowerCase[ key ] <> ": ", value } ],
        KeyDrop[ data, { "Atoms", "Graph", "Closed", "Band" } ] ],
      { BoxForm`SummaryItem[ { "multiplicity: ", obj[ "Multiplicity" ] } ],
        BoxForm`SummaryItem[ { "length: ", obj[ "Length" ] } ] } ],
    Join[
      KeyValueMap[ { key, value } |-> BoxForm`SummaryItem[ { ToLowerCase[ key ] <> ": ", value } ], KeyTake[ data, { "Band" } ] ],
      { BoxForm`SummaryItem[ { "vertices: ", Length @ obj[ "VertexList" ] } ],
        BoxForm`SummaryItem[ { "atoms: ", Length @ data[ "Atoms" ] } ] } ],
    fmt, "Interpretable" -> Automatic ]


(* ===================== InfraArc ===================== *)

(* the arc around c from p to q as an object: the shortest paths from p to q inside the band { v : r - tIn <= d(c, v) <= r + tOut }, r = d(c, p), as one geodesic DAG with source p and sink q -- InfraArc[graph, c, p, q] evaluates to InfraArc[<| "Atoms" -> {dag}, "Center" -> c, "Endpoints" -> {p, q}, "Band" -> {rmin, rmax} |>], empty when q leaves the band or the band disconnects them.  The same protocol as InfraSegment: arc[[i]], Normal, "Multiplicity", "InfraDensity", "EdgeDensity", "Length", "Graph", "VertexList" *)

Options[ InfraArc ] = { "Tolerance" -> 0 };

InfraArc[ graph_Graph, center_, p_, q_, OptionsPattern[] ] :=
  With[ { r = GraphDistance[ graph, center, p ],
          tolerance = Replace[ OptionValue[ "Tolerance" ], t : Except[ _List ] :> { t, t } ],
          dist = AssociationThread[ VertexList @ graph, GraphDistance[ graph, center ] ] },
    { band = { Max[ 1, r - First @ tolerance ], r + Last @ tolerance } },
    { shellVs = Select[ VertexList @ graph, First @ band <= dist[ # ] <= Last @ band & ] },
    { atom = If[ p =!= q && MemberQ[ shellVs, p ] && MemberQ[ shellVs, q ],
        GeodesicIntervalGraph[ Subgraph[ graph, shellVs ], p, q ], Graph[ { }, { } ] ] },
    InfraArc @ <|
      "Atoms" -> If[ EdgeCount @ atom > 0, { Graph[ Sort @ VertexList @ atom, Sort @ EdgeList @ atom ] }, { } ],
      "Center" -> center, "Endpoints" -> { p, q }, "Band" -> band |> ]


(* ===================== The InfraArc object ===================== *)

(* the object protocol, one copy per head so that InfraArc stands on its own: the atoms are geodesic DAGs whose source-to-sink paths are exactly the realisations, sorted so that the depth-first descent lists them in one lexicographic order.  Part enumerates on demand and the properties read the path-count DP off the atoms *)

InfraArc[ data_Association ][ "Graph" ] :=
  Graph[ Union @@ ( VertexList /@ data[ "Atoms" ] ), Union @@ ( EdgeList /@ data[ "Atoms" ] ) ]

(* the number of realisations: the occupation of an atom's source counts its source-to-sink paths *)
InfraArc[ data_Association ][ "Multiplicity" ] := Total[ Max @ GeodesicOccupation @ # & /@ data[ "Atoms" ] ]

(* the occupation <| v -> m |>: the realisations through v *)
InfraArc[ data_Association ][ "InfraDensity" ] := KeySort @ Merge[ GeodesicOccupation /@ data[ "Atoms" ], Total ]

(* the edge occupation keyed by the sorted vertex pair *)
InfraArc[ data_Association ][ "EdgeDensity" ] :=
  KeySort @ Merge[ KeyMap[ Sort[ List @@ # ] &, GeodesicEdgeOccupation @ # ] & /@ data[ "Atoms" ], Total ]

(* the realisation length: one number when every realisation shares it, the sorted list of the lengths present otherwise *)
InfraArc[ data_Association ][ "Length" ] :=
  Replace[
    Union @@ Map[ atom |-> With[ { source = First @ Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] },
        Union[ GraphDistance[ atom, source, # ] & /@ Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ] ] ],
      data[ "Atoms" ] ],
    { one_ } :> one ]

InfraArc[ data_Association ][ "VertexList" ] := Union @@ ( VertexList /@ data[ "Atoms" ] )

InfraArc[ data_Association ][ "Realizations" ] := InfraArc[ data ][[ All ]]
InfraArc[ data_Association ][ "Realizations", n : ( _Integer | All ) ] := InfraArc[ data ][[ 1 ;; n ]]
InfraArc[ data_Association ][ "Realizations", UpTo[ n_Integer ] ] := InfraArc[ data ][[ 1 ;; n ]]

InfraArc[ data_Association ][ "Properties" ] :=
  Union[ Keys @ data, { "Graph", "Length", "Multiplicity", "InfraDensity", "EdgeDensity", "Realizations", "VertexList", "Properties" } ]

InfraArc[ data_Association ][ prop_String ] := Lookup[ data, prop, Missing[ "KeyAbsent", prop ] ]

InfraArc /: Part[ obj : InfraArc[ _Association ], prop_String ] := obj[ prop ]

(* obj[[i]], obj[[i ;; j]], obj[[All]]: the realisations in canonical order -- atom by atom, and within an atom the depth-first descent of its sorted edges -- streamed only as far as asked *)
InfraArc /: Part[ obj : InfraArc[ data_Association ], spec : ( _Integer | _Span | All ) ] :=
  With[ { n = obj[ "Multiplicity" ] },
    { range = Replace[ spec, {
        All -> { 1, n, 1 },
        i_Integer :> { If[ i < 0, n + 1 + i, i ], If[ i < 0, n + 1 + i, i ], 1 },
        Span[ a_, b_, s_ : 1 ] :> { Replace[ a, k_Integer /; k < 0 :> n + 1 + k ],
                                   Replace[ b, { All -> n, k_Integer /; k < 0 :> n + 1 + k } ], s } } ] },
    { paths = Module[ { found = { }, descend },
        descend[ out_, path_ ] := With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
          If[ nexts === { },
            ( AppendTo[ found, path ]; If[ Length @ found >= range[[ 2 ]], Throw[ found, InfraArc ] ] ),
            Scan[ descend[ out, Append[ path, # ] ] &, nexts ] ] ];
        Catch[
          Scan[ atom |-> With[ { out = GroupBy[ List @@@ EdgeList @ atom, First -> Last ] },
              Scan[ descend[ out, { # } ] &, Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] ] ],
            data[ "Atoms" ] ];
          found, InfraArc ] ] },
    Which[
      ! IntegerQ @ spec,
        PathGraph[ #, DirectedEdges -> True ] & /@ Take[ paths, { range[[ 1 ]], Min[ range[[ 2 ]], Length @ paths ], range[[ 3 ]] } ],
      1 <= range[[ 1 ]] <= n,
        PathGraph[ #, DirectedEdges -> True ] & @ paths[[ range[[ 1 ]] ]],
      True,
        Message[ Part::partw, spec, obj ]; $Failed ] ]

InfraArc /: Normal[ obj : InfraArc[ _Association ] ] := obj[[ All ]]
InfraArc /: Length[ obj : InfraArc[ _Association ] ] := obj[ "Multiplicity" ]
InfraArc /: First[ obj : InfraArc[ _Association ] ] := obj[[ 1 ]]
InfraArc /: VertexList[ obj : InfraArc[ _Association ] ] := obj[ "VertexList" ]
InfraArc /: HighlightGraph[ graph_Graph, obj : InfraArc[ data_Association ], rest___ ] := HighlightGraph[ graph, data[ "Atoms" ], rest ]

InfraArc /: MakeBoxes[ obj : InfraArc[ data_Association ], fmt_ ] :=
  BoxForm`ArrangeSummaryBox[ InfraArc, obj,
    Graphics[ { $InfraCircleColor, AbsoluteThickness[ 1.5 ], AbsolutePointSize[ 4 ], Circle[ { 0, 0 }, 1, { Pi / 6, 5 Pi / 6 } ], Point[ { { 0, 0 }, { Cos[ Pi / 6 ], Sin[ Pi / 6 ] }, { -Cos[ Pi / 6 ], Sin[ Pi / 6 ] } } ] },
      PlotRange -> { { -1.4, 1.4 }, { -1.4, 1.4 } }, AspectRatio -> 1, Background -> None,
      ImageSize -> Dynamic[ { Automatic, 3.5 CurrentValue[ "FontCapHeight" ] / AbsoluteCurrentValue[ Magnification ] } ] ],
    Join[
      KeyValueMap[ { key, value } |-> BoxForm`SummaryItem[ { ToLowerCase[ key ] <> ": ", value } ],
        KeyDrop[ data, { "Atoms", "Graph", "Closed", "Band" } ] ],
      { BoxForm`SummaryItem[ { "multiplicity: ", obj[ "Multiplicity" ] } ],
        BoxForm`SummaryItem[ { "length: ", obj[ "Length" ] } ] } ],
    Join[
      KeyValueMap[ { key, value } |-> BoxForm`SummaryItem[ { ToLowerCase[ key ] <> ": ", value } ], KeyTake[ data, { "Band" } ] ],
      { BoxForm`SummaryItem[ { "vertices: ", Length @ obj[ "VertexList" ] } ],
        BoxForm`SummaryItem[ { "atoms: ", Length @ data[ "Atoms" ] } ] } ],
    fmt, "Interpretable" -> Automatic ]


(* ===================== FindInfraCircle ===================== *)

(* a circle of radius r around c is a simple cycle in the level surface at distance ~r from c, returned as a directed cycle graph on the substrate vertices; the count-less call is one circle, a bounded count and All a List of them -- closed walks have no acyclic union to carry them, so All enumerates.
   On the default Properties, a single anchor and an integer band the family is carried internally by the circle pool (circlePool), polynomial in |V| however large the family is, and a bounded count streams circles off its atoms in candidate ("Greedy", "Exhaustive") or random ("RandomGreedy") order; otherwise by the FindCycle length sweep, which materialises every shorter cycle first.  One class under every Method *)

FindInfraCircle::badproperty = "Property `1` is not supported by FindInfraCircle.";
FindInfraCircle::badmethod   = "Method `1` is not supported by FindInfraCircle.";
FindInfraCircle::uncertified = "The circle pool of the band `1` around `2` is not certified exact; the family comes from the cycle sweep instead, so it is enumerated rather than carried.";

Options[ FindInfraCircle ] = {
  Properties -> { "Separating", "Shortest" },
  Method     -> Automatic
};

FindInfraCircle[ graph_Graph, p_, r_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Catch @ With[
    { properties = OptionValue[ FindInfraCircle, { opts }, Properties ],
      methodSpec = resolveMethod[ OptionValue[ FindInfraCircle, { opts }, Method ], count ],
      anchors = Tuples[ { Keys @ toDensity[ graph, p ], infraSpread @ r } ] },
    { methodHead = methodName @ methodSpec },
    If[ ! MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ],
      Message[ FindInfraCircle::badmethod, methodSpec ]; Throw[ $Failed ] ];
    With[
      { branch = greedyBranch[ methodHead /. "Exhaustive" -> "Greedy" ],
        pruning = Replace[ methodSpec,
          { { "Exhaustive", subs___ } :> ( "Pruning" /. { subs } /. "Pruning" -> Infinity ), _ :> Infinity } ],
        pool = If[ Length @ anchors === 1 && Sort @ properties === { "Separating", "Shortest" },
          circlePool[ graph, Sequence @@ First @ anchors ], Null ] },
      If[ pool === Null || pool === $Failed,
        (* a refusal costs nothing on an empty family, so ::uncertified fires only when circles exist that the carrier could not hold *)
        With[ { swept = spreadFind[ geodesicCycleGraph, count,
                  findCircleSweep[ graph, ##, properties, count, branch, pruning ] &, toDensity[ graph, p ], r ] },
          If[ pool === $Failed && swept =!= { } && swept =!= $Failed,
            Message[ FindInfraCircle::uncertified, r, p ] ];
          swept ],
        countTake[
          geodesicCycleGraph /@ Fold[ { acc, dag } |-> If[ Length @ acc >= countLimit @ count, acc,
              Join[ acc, dagGeodesics[ dag, countLimit @ count - Length @ acc, branch ] ] ],
            { }, branch @ pool ],
          count ]
      ] ] ]


(* a radial seam P -- one geodesic from c to just outside the band, kept inside it -- meets every separating cycle and cuts the annulus into a disk; an atom is a contiguous arc S of P with a pair (u, v) of cut-shell vertices flanking its ends, carrying the cycles S ++ (a v-u geodesic of the shell minus P).
   $Failed when the carrier is not certified: separation is an atom invariant exactly when winding about c is defined, i.e. on a planar local graph, and an empty pool with a non-empty exterior is the signature of a band no radial seam cuts open, where minimum separating cycles need not be taut. *)

circlePool[ _Graph, _, r_ ] /;
  ! AllTrue[ Replace[ r, d_?NumericQ :> { d, d } ], IntegerQ ] := $Failed

circlePool[ graph_Graph, center_, r_ ] :=
  With[
    { band = Replace[ r, d_?NumericQ :> { d, d } ] },
    { localG = NeighborhoodGraph[ graph, center, Last @ band + 2 ] },
    { dist = AssociationThread[ VertexList @ localG, GraphDistance[ localG, center ] ] },
    { outside = Select[ VertexList @ localG, Lookup[ dist, Key @ # ] === Last @ band + 1 & ],
      shellVs = Select[ VertexList @ localG,
        First @ band <= Lookup[ dist, Key @ # ] <= Last @ band & ] },
    { shell = Subgraph[ localG, shellVs ],
      seam = If[ outside === { }, { },
        Take[ FindShortestPath[ localG, center, First @ outside ],
          { First @ band + 1, Last @ band + 1 } ] ] },
    { cut = VertexDelete[ shell, seam ], cutSet = Complement[ shellVs, seam ] },
    { dags = Catenate @ Map[
        arc |-> Map[
          ends |-> With[ { interval = GeodesicIntervalGraph[ cut, Last @ ends, First @ ends ] },
            Graph[ Join[ arc, VertexList @ interval ],
              Join[ DirectedEdge @@@ Partition[ Append[ arc, Last @ ends ], 2, 1 ],
                    EdgeList @ interval ] ] ],
          Select[
            If[ Length @ arc === 1,
              Subsets[ Intersection[ AdjacencyList[ shell, First @ arc ], cutSet ], { 2 } ],
              Tuples[ Intersection[ AdjacencyList[ shell, # ], cutSet ] & /@
                { First @ arc, Last @ arc } ] ],
            GraphDistance[ cut, Last @ #, First @ # ] < Infinity & ] ],
        Catenate @ Table[ Take[ seam, { i, j } ],
          { i, Length @ seam }, { j, i, Length @ seam } ] ] },
    { separating = admissibleCircleVerts[ localG, center, Last @ band, { "Separating" } ] },
    { pool = Replace[
        Catch @ Scan[
          class |-> With[
            { admissible = Select[ class, separating @ First @ dagGeodesics[ #, 1 ] & ] },
            If[ admissible =!= { }, Throw @ admissible ] ],
          Values @ KeySort @ GroupBy[ dags, 1 + Max @ Values @ dagLayers @ # & ] ],
        Null -> { } ] },
    If[ PlanarGraphQ @ localG && ( pool =!= { } || outside === { } ), pool, $Failed ]
  ]


(* FindCycle by ascending length on the level subgraph, filtered by the Properties predicates: exact for every Properties value, exponential in the debris below the minimal separating length.  The first non-empty grade is certified only by exhausting the shorter ones, so every Method runs the same sweep and branch only orders the ties; pruning caps the cycles kept per length *)

findCircleSweep[ graph_Graph, center_, r_, properties_List, count_, branch_, pruning_ ] :=
  Module[ { unknown, range, localG, levelSet, radius, levelGraph,
            vertsTest, tied, needed, k, kMax, batch, matching, accumulated },
    Catch[
      unknown = Complement[ properties, { "Separating", "Shortest" } ];
      If[ unknown =!= { },
        Message[ FindInfraCircle::badproperty, First @ unknown ]; Throw[ $Failed ] ];
      range = Replace[ r, d_?NumericQ :> { d, d } ];
      localG = If[ NumericQ[ range[[ 2 ]] ],
                   NeighborhoodGraph[ graph, center, Ceiling[ range[[ 2 ]] ] + 2 ], graph ];
      levelSet = Select[ VertexList[ localG ],
        range[[ 1 ]] <= GraphDistance[ localG, center, # ] <= range[[ 2 ]] & ];
      radius = range[[ 2 ]];
      levelGraph = Subgraph[ localG, levelSet ];
      vertsTest  = admissibleCircleVerts[ localG, center, radius,
                     DeleteCases[ properties, "Shortest" ] ];
      tied = MemberQ[ properties, "Shortest" ];
      needed = countLimit @ count;
      kMax = VertexCount[ levelGraph ];
      accumulated = { };
      k = 3;
      While[ k <= kMax,
        batch    = branch @ applyPruning[ cycleToVertexSequence /@ FindCycle[ levelGraph, { k }, All ], pruning ];
        matching = Select[ batch, vertsTest ];
        If[ matching =!= { },
          accumulated = Join[ accumulated, matching ];
          If[ tied || Length[ accumulated ] >= needed, Break[ ] ]
        ];
        k++
      ];
      accumulated
    ]
  ]


admissibleCircleVerts[ localG_Graph, center_, radius_, properties_List ] :=
  With[ { tests = propertyPredicateCircle[ localG, center, radius, # ] & /@ properties },
    verts |-> AllTrue[ tests, # @ verts & ]
  ]


(* the shortest separating cycle hugs the inner edge rmin, with no clean cut at the mean -- which is why this differs from the SeparatingSetQ FindInfraShell uses *)
propertyPredicateCircle[ localG_Graph, center_, radius_, "Separating" ] :=
  verts |-> With[ { rem = VertexDelete[ localG, verts ] },
    { cc = SelectFirst[ ConnectedComponents[ rem ], MemberQ[ #, center ] & ] },
    cc =!= Missing[ "NotFound" ] &&
    AllTrue[ cc, GraphDistance[ localG, center, # ] <= radius & ] ]

propertyPredicateCircle[ _, _, _, other_ ] :=
  ( Message[ FindInfraCircle::badproperty, other ]; Throw[ $Failed ] )


(* ===================== FindInfraCycle ===================== *)


FindInfraCycle[ graph_Graph, n : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  FindInfraCycle[ graph, { 1, VertexCount[ graph ] }, n ]

FindInfraCycle[ graph_Graph, { k_Integer },
    n : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { cycles = cycleToVertexSequence /@ FindCycle[ graph, { k }, All ] },
    countTake[ geodesicCycleGraph /@ cycles, n ] ]

FindInfraCycle[ graph_Graph, { kMin_Integer, kMax_ },
    n : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { cycles = SortBy[ Length ] @ Flatten[
        cycleToVertexSequence /@ FindCycle[ graph, { # }, All ] & /@
          Range[ kMin, Min[ kMax, VertexCount[ graph ] ] ], 1 ] },
    countTake[ geodesicCycleGraph /@ cycles, n ] ]


(* ===================== InfraCircleQ ===================== *)

(* a metric circle iff consecutive vertices and the wrap-around are adjacent and the vertex set is a metric shell; a cycle graph is read as its closed walk *)

InfraCircleQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraCircleQ[ graph, # ] & ]

InfraCircleQ[ graph_Graph, w_Graph ] := AllTrue[ walkRealisations @ w, InfraCircleQ[ graph, # ] & ]

InfraCircleQ[ graph_Graph, cycle_List ] /; Length[ cycle ] >= 3 :=
  With[ {
      closed = If[ First @ cycle === Last @ cycle, cycle, Append[ cycle, First @ cycle ] ] },
    { verts = Most @ closed,
      pairs = Partition[ closed, 2, 1 ] },
    DuplicateFreeQ[ verts ] &&
    AllTrue[ pairs, EdgeQ[ graph, UndirectedEdge @@ # ] & ] &&
    InfraShellQ[ graph, verts ]
  ]

InfraCircleQ[ _Graph, cycle_List ] /; Length[ cycle ] < 3 := False

InfraCircleQ[ graph_Graph, obj : ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ _Association ] ] :=
  With[ { reps = Normal @ obj }, reps =!= { } && AllTrue[ reps, InfraCircleQ[ graph, # ] & ] ]


(* ===================== Scene-DSL constructor ===================== *)

dispatchConstruction[ graph_Graph, InfraCircle[ center_, r_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      walkSequence /@ FindInfraCircle[ graph, center, r, All ],
      "Select" /. { opts } /. "Select" -> None,
      True, <| "Center" -> center,
               "Radius" -> If[ NumericQ[ r ], r, Mean[ r ] ] |> ],
    extractBranches[ { opts } ] ]
