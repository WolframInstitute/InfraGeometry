Package["WolframInstitute`SyntheticInfrageometry`"]

(* WolframInstitute`SyntheticInfrageometry` :: EuclideanInfrageometry :: InfraRay *)


(* ===================== InfraRay ===================== *)

(* the rays from o through v as an object.  InfraRay[graph, o, v] evaluates to InfraRay[<| "Atoms" -> {dag}, "Origin" -> o, "Direction" -> v |>] and stands for every ray from o through v at once -- the o -> v interval glued at v to the geodesic extensions beyond it, one DAG with source o per anchor pair, the carrier FindInfraRay[graph, o, v, All] builds, whose o -> sink paths are exactly the rays; InfraRay[graph, o] is the pencil, every ray from o.  ray[[i]] is the i-th ray in canonical order, ray[[i ;; j]] a List, Normal all; "Multiplicity", "InfraDensity", "EdgeDensity", "Length" (the lengths present, since rays end on several layers), "Graph" and "VertexList" are read off the DAG.  Without the graph, InfraRay[o, v] is the InfraScene token *)

InfraRay[ graph_Graph, origin_, v : Except[ _Rule | _RuleDelayed ] ] :=
  InfraRay @ <|
    "Atoms" -> Map[ Graph[ Sort @ VertexList @ #, Sort @ EdgeList @ # ] &,
      Select[ Replace[ FindInfraRay[ graph, origin, v, All ], dag_Graph :> { dag } ], GraphQ[ # ] && EdgeCount[ # ] > 0 & ] ],
    "Origin" -> origin, "Direction" -> v |>

InfraRay[ graph_Graph, origin_ ] :=
  InfraRay @ <|
    "Atoms" -> Map[ Graph[ Sort @ VertexList @ #, Sort @ EdgeList @ # ] &,
      Select[ Replace[ FindInfraRay[ graph, origin, origin, All ], dag_Graph :> { dag } ], GraphQ[ # ] && EdgeCount[ # ] > 0 & ] ],
    "Origin" -> origin, "Direction" -> None |>


(* ===================== The InfraRay object ===================== *)

(* the object protocol, one copy per head so that InfraRay stands on its own: the atoms are geodesic DAGs whose source-to-sink paths are exactly the realisations, sorted so that the depth-first descent lists them in one lexicographic order.  Part enumerates on demand and the properties read the path-count DP off the atoms *)

InfraRay[ data_Association ][ "Graph" ] :=
  Graph[ Union @@ ( VertexList /@ data[ "Atoms" ] ), Union @@ ( EdgeList /@ data[ "Atoms" ] ) ]

(* the number of realisations: the occupation of an atom's source counts its source-to-sink paths *)
InfraRay[ data_Association ][ "Multiplicity" ] := Total[ Max @ GeodesicOccupation @ # & /@ data[ "Atoms" ] ]

(* the occupation <| v -> m |>: the realisations through v *)
InfraRay[ data_Association ][ "InfraDensity" ] := KeySort @ Merge[ GeodesicOccupation /@ data[ "Atoms" ], Total ]

(* the edge occupation keyed by the sorted vertex pair *)
InfraRay[ data_Association ][ "EdgeDensity" ] :=
  KeySort @ Merge[ KeyMap[ Sort[ List @@ # ] &, GeodesicEdgeOccupation @ # ] & /@ data[ "Atoms" ], Total ]

(* the realisation length: one number when every realisation shares it, the sorted list of the lengths present otherwise *)
InfraRay[ data_Association ][ "Length" ] :=
  Replace[
    Union @@ Map[ atom |-> With[ { source = First @ Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] },
        Union[ GraphDistance[ atom, source, # ] & /@ Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ] ] ],
      data[ "Atoms" ] ],
    { one_ } :> one ]

InfraRay[ data_Association ][ "VertexList" ] := Union @@ ( VertexList /@ data[ "Atoms" ] )

InfraRay[ data_Association ][ "Realizations" ] := InfraRay[ data ][[ All ]]
InfraRay[ data_Association ][ "Realizations", n : ( _Integer | All ) ] := InfraRay[ data ][[ 1 ;; n ]]
InfraRay[ data_Association ][ "Realizations", UpTo[ n_Integer ] ] := InfraRay[ data ][[ 1 ;; n ]]

InfraRay[ data_Association ][ "Properties" ] :=
  Union[ Keys @ data, { "Graph", "Length", "Multiplicity", "InfraDensity", "EdgeDensity", "Realizations", "VertexList", "Properties" } ]

InfraRay[ data_Association ][ prop_String ] := Lookup[ data, prop, Missing[ "KeyAbsent", prop ] ]

InfraRay /: Part[ obj : InfraRay[ _Association ], prop_String ] := obj[ prop ]

(* obj[[i]], obj[[i ;; j]], obj[[All]]: the realisations in canonical order -- atom by atom, and within an atom the depth-first descent of its sorted edges -- streamed only as far as asked *)
InfraRay /: Part[ obj : InfraRay[ data_Association ], spec : ( _Integer | _Span | All ) ] :=
  With[ { n = obj[ "Multiplicity" ] },
    { range = Replace[ spec, {
        All -> { 1, n, 1 },
        i_Integer :> { If[ i < 0, n + 1 + i, i ], If[ i < 0, n + 1 + i, i ], 1 },
        Span[ a_, b_, s_ : 1 ] :> { Replace[ a, k_Integer /; k < 0 :> n + 1 + k ],
                                   Replace[ b, { All -> n, k_Integer /; k < 0 :> n + 1 + k } ], s } } ] },
    { paths = Module[ { found = { }, descend },
        descend[ out_, path_ ] := With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
          If[ nexts === { },
            ( AppendTo[ found, path ]; If[ Length @ found >= range[[ 2 ]], Throw[ found, InfraRay ] ] ),
            Scan[ descend[ out, Append[ path, # ] ] &, nexts ] ] ];
        Catch[
          Scan[ atom |-> With[ { out = GroupBy[ List @@@ EdgeList @ atom, First -> Last ] },
              Scan[ descend[ out, { # } ] &, Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] ] ],
            data[ "Atoms" ] ];
          found, InfraRay ] ] },
    Which[
      ! IntegerQ @ spec,
        PathGraph[ #, DirectedEdges -> True ] & /@ Take[ paths, { range[[ 1 ]], Min[ range[[ 2 ]], Length @ paths ], range[[ 3 ]] } ],
      1 <= range[[ 1 ]] <= n,
        PathGraph[ #, DirectedEdges -> True ] & @ paths[[ range[[ 1 ]] ]],
      True,
        Message[ Part::partw, spec, obj ]; $Failed ] ]

InfraRay /: Normal[ obj : InfraRay[ _Association ] ] := obj[[ All ]]
InfraRay /: Length[ obj : InfraRay[ _Association ] ] := obj[ "Multiplicity" ]
InfraRay /: First[ obj : InfraRay[ _Association ] ] := obj[[ 1 ]]
InfraRay /: VertexList[ obj : InfraRay[ _Association ] ] := obj[ "VertexList" ]
InfraRay /: HighlightGraph[ graph_Graph, obj : InfraRay[ data_Association ], rest___ ] := HighlightGraph[ graph, data[ "Atoms" ], rest ]

InfraRay /: MakeBoxes[ obj : InfraRay[ data_Association ], fmt_ ] :=
  BoxForm`ArrangeSummaryBox[ InfraRay, obj,
    Graphics[ { $InfraRayColor, AbsoluteThickness[ 1.5 ], AbsolutePointSize[ 4 ], Arrowheads[ 0.5 ], Arrow[ { { -1, 0 }, { 1, 0 } } ], Point[ { { -1, 0 } } ] },
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


(* ===================== FindInfraRay ===================== *)

(* a ray from o through v: a geodesic o ... v ... e with d(o, e) == d(o, v) + d(v, e) and no neighbour of e one step farther from o -- the InfraRayQ class under every Method; the longest ones are SelectInfraWalk[graph, rays, All, "From" -> "MaxLength"].  The count-less call is one ray as a substrate path graph, a bounded count a List of them, All the pool: one DAG with source o, the o -> v geodesic bundle glued at v to the extension graph beyond v, whose o -> sink paths are exactly the rays -- a sink has no neighbour one step farther from o, which is InfraRayQ's far-end test.  "Exhaustive" with All is the pool itself, and every bounded count streams rays off it in candidate ("Greedy", "Exhaustive") or random ("RandomGreedy") order *)

FindInfraRay::badmethod = "Method `1` is not supported by FindInfraRay.";

Options[ FindInfraRay ] = { Method -> Automatic };

FindInfraRay[ graph_Graph, origin_, v_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ {
      method = Replace[ OptionValue[ FindInfraRay, { opts }, Method ],
                 { Automatic :> If[ count === All, "Exhaustive", "Greedy" ], { m_String, ___ } :> m } ],
      cap    = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { branch = If[ method === "RandomGreedy", RandomSample, Identity ] },
    If[ ! MatchQ[ method, "Exhaustive" | "Greedy" | "RandomGreedy" ],
      Message[ FindInfraRay::badmethod, method ]; $Failed,
      With[ { rays = DeleteDuplicates[ If[ GraphQ @ #, #, PathGraph[ #, DirectedEdges -> True ] ] & /@ DeleteDuplicates @ Catenate[
          ( { o, w } |-> With[ {
                pool = Graph @ Sort @ Join[ EdgeList @ GeodesicIntervalGraph[ graph, o, w ],
                                            EdgeList @ GeodesicExtensionGraph[ graph, { o, w } ] ] },
              { sources = Select[ VertexList @ pool, VertexInDegree[ pool, # ] == 0 & ] },
              Which[
                EdgeCount @ pool == 0,                    { },
                method === "Exhaustive" && count === All, { pool },
                count === All,
                  Catenate @ Catenate @ Table[ FindPath[ pool, s, t, Infinity, All ],
                    { s, sources }, { t, Select[ VertexList @ pool, VertexOutDegree[ pool, # ] == 0 & ] } ],
                (* the lazy descent of the pool from its source, stopping at cap rays *)
                True,
                  Module[ { acc = { }, out = GroupBy[ List @@@ EdgeList @ pool, First -> Last ], descend },
                    descend[ path_ ] := With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
                      If[ nexts === { },
                        AppendTo[ acc, path ]; If[ Length @ acc >= cap, Throw[ acc, descend ] ],
                        Scan[ descend[ Append[ path, # ] ] &, branch @ nexts ] ] ];
                    Catch[ Scan[ descend[ { # } ] &, branch @ sources ]; acc, descend ] ] ] ] ) @@@
            Tuples[ Keys @ InfraDensity[ graph, # ] & /@ { origin, v } ] ] ] },
        Switch[ count,
          Automatic, First[ rays, { } ],
          All,       Replace[ rays, { one_Graph } :> one ],
          _UpTo,     Take[ rays, count ],
          _,         If[ Length @ rays < count, $Failed, Take[ rays, count ] ] ] ] ] ]


(* ===================== InfraRayQ ===================== *)

(* a geodesic inextensible at its far end only: the origin is an endpoint by fiat, which is what distinguishes a ray from a line *)

(* the graph rules first: a List of graphs is a family, and only a bare vertex list is one ray *)
InfraRayQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraRayQ[ graph, # ] & ]

InfraRayQ[ graph_Graph, w_Graph ] :=
  With[ { vs = VertexList @ w },
    { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
      scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
    AllTrue[
      Which[
        ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
          { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
              If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
        EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
        spelled,            { Last /@ SortBy[ vs, First ] },
        DirectedGraphQ @ w,
          Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
            { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ],
      InfraRayQ[ graph, # ] & ] ]

InfraRayQ[ graph_Graph, obj : ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ _Association ] ] :=
  With[ { reps = Normal @ obj }, reps =!= { } && AllTrue[ reps, InfraRayQ[ graph, # ] & ] ]

InfraRayQ[ graph_Graph, ray_List ] /; Length[ ray ] >= 2 :=
  InfraSegmentQ[ graph, ray ] &&
  NoneTrue[ AdjacencyList[ graph, Last @ ray ],
    GraphDistance[ graph, First @ ray, # ] == Length[ ray ] & ]

InfraRayQ[ _Graph, ray_List ] /; Length[ ray ] < 2 := False


(* ===================== PencilDirections / PencilCardinality ===================== *)

(* the pencil at O is the set of rays from O; a ray leaves O through exactly one neighbour, so the ray pools over the neighbours partition it, and the cardinality is their path count, read off the DP without enumeration *)

PencilDirections[ graph_Graph, origin_ ] :=
  Catenate[
    ( dag |-> With[ { paths = Catenate @ Catenate @ Table[ FindPath[ dag, src, snk, Infinity, All ],
          { src, Select[ VertexList @ dag, VertexInDegree[ dag, # ] == 0 & ] },
          { snk, Select[ VertexList @ dag, VertexOutDegree[ dag, # ] == 0 & ] } ] },
        If[ AllTrue[ VertexList @ dag, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ dag ] === Range @ VertexCount @ dag,
          Map[ Last, paths, { 2 } ], paths ] ] ) /@
      Catenate[ Replace[ FindInfraRay[ graph, origin, #, All ], dag_Graph :> { dag } ] & /@ AdjacencyList[ graph, origin ] ] ]

PencilCardinality[ graph_Graph, origin_ ] :=
  Total[
    ( dag |-> If[ AllTrue[ VertexList @ dag, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ VertexList @ dag ] === Range @ VertexCount @ dag, 1,
        With[ { occ = GeodesicOccupation @ dag }, If[ Length @ occ === 0, 1, Max @ Values @ occ ] ] ] ) /@
      Catenate[ Replace[ FindInfraRay[ graph, origin, #, All ], dag_Graph :> { dag } ] & /@ AdjacencyList[ graph, origin ] ] ]


(* ===================== Scene-DSL constructor ===================== *)

dispatchConstruction[ graph_Graph, InfraRay[ origin_, v_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      infraSpread @ FindInfraRay[ graph, origin, v, All,
        Sequence @@ FilterRules[ { opts }, Options[ FindInfraRay ] ] ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { origin, v } |> ],
    extractBranches[ { opts } ] ]
