Package["WolframInstitute`SyntheticInfrageometry`"]

PackageScope[findSegmentCore]
PackageScope[extensionPool]
PackageScope[seedBundles]

(* WolframInstitute`SyntheticInfrageometry` :: EuclideanInfrageometry :: InfraSegment *)


(* ===================== InfraSegment ===================== *)

(* the geodesic interval I(p, q) as an object.  InfraSegment[graph, p, q] evaluates to InfraSegment[<| "Atoms" -> {dag}, "Endpoints" -> {p, q} |>] and stands for every geodesic from p to q at once -- one geodesic DAG per endpoint pair the anchors spread to, the carrier FindInfraSegment[graph, p, q, All] builds -- so the family is never enumerated unless asked: seg[[i]] is the i-th geodesic in canonical order, seg[[i ;; j]] a List of them, Normal all, and seg["Multiplicity"], seg["InfraDensity"], seg["EdgeDensity"], seg["Length"], seg["Graph"], seg["VertexList"] are read off the DAG.  Without the graph, InfraSegment[p, q] is the InfraScene token *)

InfraSegment[ graph_Graph, p_, q : Except[ _Rule | _RuleDelayed ] ] :=
  InfraSegment @ <|
    "Atoms" -> Map[ Graph[ Sort @ VertexList @ #, Sort @ EdgeList @ # ] &,
      Select[ Replace[ FindInfraSegment[ graph, p, q, All ], dag_Graph :> { dag } ], GraphQ[ # ] && EdgeCount[ # ] > 0 & ] ],
    "Endpoints" -> { p, q } |>


(* ===================== The InfraSegment object ===================== *)

(* the object protocol, one copy per head so that InfraSegment stands on its own: the atoms are geodesic DAGs whose source-to-sink paths are exactly the realisations, sorted so that the depth-first descent lists them in one lexicographic order.  Part enumerates on demand and the properties read the path-count DP off the atoms *)

InfraSegment[ data_Association ][ "Graph" ] :=
  Graph[ Union @@ ( VertexList /@ data[ "Atoms" ] ), Union @@ ( EdgeList /@ data[ "Atoms" ] ) ]

(* the number of realisations: the occupation of an atom's source counts its source-to-sink paths *)
InfraSegment[ data_Association ][ "Multiplicity" ] := Total[ Max @ GeodesicOccupation @ # & /@ data[ "Atoms" ] ]

(* the occupation <| v -> m |>: the realisations through v *)
InfraSegment[ data_Association ][ "InfraDensity" ] := KeySort @ Merge[ GeodesicOccupation /@ data[ "Atoms" ], Total ]

(* the edge occupation keyed by the sorted vertex pair *)
InfraSegment[ data_Association ][ "EdgeDensity" ] :=
  KeySort @ Merge[ KeyMap[ Sort[ List @@ # ] &, GeodesicEdgeOccupation @ # ] & /@ data[ "Atoms" ], Total ]

(* the realisation length: one number when every realisation shares it, the sorted list of the lengths present otherwise *)
InfraSegment[ data_Association ][ "Length" ] :=
  Replace[
    Union @@ Map[ atom |-> With[ { source = First @ Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] },
        Union[ GraphDistance[ atom, source, # ] & /@ Select[ VertexList @ atom, VertexOutDegree[ atom, # ] == 0 & ] ] ],
      data[ "Atoms" ] ],
    { one_ } :> one ]

InfraSegment[ data_Association ][ "VertexList" ] := Union @@ ( VertexList /@ data[ "Atoms" ] )

InfraSegment[ data_Association ][ "Realizations" ] := InfraSegment[ data ][[ All ]]
InfraSegment[ data_Association ][ "Realizations", n : ( _Integer | All ) ] := InfraSegment[ data ][[ 1 ;; n ]]
InfraSegment[ data_Association ][ "Realizations", UpTo[ n_Integer ] ] := InfraSegment[ data ][[ 1 ;; n ]]

InfraSegment[ data_Association ][ "Properties" ] :=
  Union[ Keys @ data, { "Graph", "Length", "Multiplicity", "InfraDensity", "EdgeDensity", "Realizations", "VertexList", "Properties" } ]

InfraSegment[ data_Association ][ prop_String ] := Lookup[ data, prop, Missing[ "KeyAbsent", prop ] ]

InfraSegment /: Part[ obj : InfraSegment[ _Association ], prop_String ] := obj[ prop ]

(* obj[[i]], obj[[i ;; j]], obj[[All]]: the realisations in canonical order -- atom by atom, and within an atom the depth-first descent of its sorted edges -- streamed only as far as asked *)
InfraSegment /: Part[ obj : InfraSegment[ data_Association ], spec : ( _Integer | _Span | All ) ] :=
  With[ { n = obj[ "Multiplicity" ] },
    { range = Replace[ spec, {
        All -> { 1, n, 1 },
        i_Integer :> { If[ i < 0, n + 1 + i, i ], If[ i < 0, n + 1 + i, i ], 1 },
        Span[ a_, b_, s_ : 1 ] :> { Replace[ a, k_Integer /; k < 0 :> n + 1 + k ],
                                   Replace[ b, { All -> n, k_Integer /; k < 0 :> n + 1 + k } ], s } } ] },
    { paths = Module[ { found = { }, descend },
        descend[ out_, path_ ] := With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
          If[ nexts === { },
            ( AppendTo[ found, path ]; If[ Length @ found >= range[[ 2 ]], Throw[ found, InfraSegment ] ] ),
            Scan[ descend[ out, Append[ path, # ] ] &, nexts ] ] ];
        Catch[
          Scan[ atom |-> With[ { out = GroupBy[ List @@@ EdgeList @ atom, First -> Last ] },
              Scan[ descend[ out, { # } ] &, Select[ VertexList @ atom, VertexInDegree[ atom, # ] == 0 & ] ] ],
            data[ "Atoms" ] ];
          found, InfraSegment ] ] },
    Which[
      ! IntegerQ @ spec,
        PathGraph[ #, DirectedEdges -> True ] & /@ Take[ paths, { range[[ 1 ]], Min[ range[[ 2 ]], Length @ paths ], range[[ 3 ]] } ],
      1 <= range[[ 1 ]] <= n,
        PathGraph[ #, DirectedEdges -> True ] & @ paths[[ range[[ 1 ]] ]],
      True,
        Message[ Part::partw, spec, obj ]; $Failed ] ]

InfraSegment /: Normal[ obj : InfraSegment[ _Association ] ] := obj[[ All ]]
InfraSegment /: Length[ obj : InfraSegment[ _Association ] ] := obj[ "Multiplicity" ]
InfraSegment /: First[ obj : InfraSegment[ _Association ] ] := obj[[ 1 ]]
InfraSegment /: VertexList[ obj : InfraSegment[ _Association ] ] := obj[ "VertexList" ]
InfraSegment /: HighlightGraph[ graph_Graph, obj : InfraSegment[ data_Association ], rest___ ] := HighlightGraph[ graph, data[ "Atoms" ], rest ]

InfraSegment /: MakeBoxes[ obj : InfraSegment[ data_Association ], fmt_ ] :=
  BoxForm`ArrangeSummaryBox[ InfraSegment, obj,
    Graphics[ { $InfraSegmentColor, AbsoluteThickness[ 1.5 ], AbsolutePointSize[ 4 ], Line[ { { -1, 0 }, { 1, 0 } } ], Point[ { { -1, 0 }, { 1, 0 } } ] },
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


(* ===================== FindInfraSegment ===================== *)

(* a geodesic (p1 = v0, v1, ..., vk = p2) with k = d(p1, p2), returned as a directed path graph on the substrate vertices.  The count-less call is one geodesic, a bounded count a List of them, and All the geodesic interval DAG: the bundle IS the union of its walks, so it is not a separate return type.  Anchors spreading to several endpoint pairs give one DAG per pair -- a multi-source / multi-sink union of intervals is not acyclic in general.  No Properties axis: a rule narrowing the geodesic bundle is a local law at an infra-scale, hence a FindInfraGeodesic call *)

FindInfraSegment::badproperty = "Property `1` is not supported by FindInfraSegment; local rules on the geodesic bundle moved to FindInfraGeodesic[graph, p1, p2, scale].";
FindInfraSegment::badmethod   = "Method `1` is not supported by FindInfraSegment.";

Options[ FindInfraSegment ] = {
  Method -> Automatic
};

(* count = All with the exhaustive method gives the DAG form, one GeodesicIntervalGraph atom per endpoint pair; any bounded count gives the enumerated paths, lazily via the DAG's bounded DFS.  The endpoints are point-shaped anchors, so each is read through the anchor rule: a vertex, a vertex list, a density or a walk all spread over their support *)

FindInfraSegment[ graph_Graph, p1_, p2_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  If[ ! FreeQ[ { opts }, Properties ],
    Message[ FindInfraSegment::badproperty, Properties /. { opts } ]; $Failed,
    If[ count === All &&
        methodName[ resolveMethod[ OptionValue[ FindInfraSegment, { opts }, Method ], count ] ] === "Exhaustive",
      loneBundle @ DeleteDuplicates[ GeodesicIntervalGraph[ graph, #[[ 1 ]], #[[ 2 ]] ] & /@
        Select[ Tuples[ Keys @ toDensity[ graph, # ] & /@ { p1, p2 } ],
          #[[ 1 ]] =!= #[[ 2 ]] && VertexQ[ graph, #[[ 1 ]] ] && VertexQ[ graph, #[[ 2 ]] ] & ] ],
      geodesicFind[ count, findSegmentCore[ graph, ##, count, opts ] &,
        toDensity[ graph, p1 ], toDensity[ graph, p2 ] ]
    ]
  ]


findSegmentCore[ _Graph, p1_, p1_, ___ ] := { }

findSegmentCore[ graph_Graph, p1_, p2_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[ FindInfraSegment ] ] :=
  With[ { methodSpec = resolveMethod[ OptionValue[ FindInfraSegment, { opts }, Method ], count ] },
    Switch[ methodName @ methodSpec,
      "Exhaustive",
        If[ countLimit @ count === 1,
          With[ { path = FindShortestPath[ graph, p1, p2 ] },
            If[ path === { }, { }, { path } ] ],
          With[ { d = GraphDistance[ graph, p1, p2 ] },
            If[ d === Infinity, { },
              FindPath[ graph, p1, p2, { d }, count /. UpTo[ k_ ] :> k ] ] ]
        ],
      (* the pool structure already IS the lazy descent: the DAG's bounded DFS
         stops at `count` geodesics, so the greedy branch is complete and exact *)
      "Greedy",
        dagGeodesics[ GeodesicIntervalGraph[ graph, p1, p2 ], count ],
      "RandomGreedy",
        With[ { dag = GeodesicIntervalGraph[ graph, p1, p2 ] },
          greedyFrontierSweep[ dag, p1, p2,
            { d, w } |-> DeleteCases[ VertexOutComponent[ d, { Last @ w }, 1 ], Last @ w ],
            True &, Infinity, count, RandomSample ] ],
      _,
        Message[ FindInfraSegment::badmethod, methodSpec ]; $Failed
    ]
  ]


(* ===================== ExtendInfraSegment ===================== *)

(* the geodesics containing a geodesic bundle from p1 to p2, extended past its ends by at most kspec edges per free side and inextensible within that budget: kspec Infinity gives the lines through the bundle (FindInfraLine), kspec 0 the bundle itself.  The seed is a walk, a geodesic DAG extended as one object, or anything spreading to walks; the 6-ary form is Tarski A4 *)

ExtendInfraSegment::badproperty  = "Property `1` is not supported by ExtendInfraSegment; local rules on the extension moved to ExtendInfraGeodesic[graph, seed, scale, kspec].";
ExtendInfraSegment::badmethod    = "Method `1` is not supported by ExtendInfraSegment.";
ExtendInfraSegment::baddirection = "Direction `1` is not supported by ExtendInfraSegment.";

Options[ ExtendInfraSegment ] = {
  Properties  -> { },
  Method      -> Automatic,
  "Direction" -> "BothSides"
};

ExtendInfraSegment[ graph_Graph, seed_,
    kspec : ( _Integer | UpTo[ _Integer ] | { _Integer } | { _Integer, _Integer } | Infinity ) : Infinity,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ { pools = extensionPool[ ExtendInfraSegment, graph, #, kspec, count, opts ] & /@ seedBundles @ seed },
    If[ MemberQ[ pools, $Failed ], $Failed, geodesicTake[ Catenate @ pools, count ] ] ]


(* the bundles a seed stands for, one DAG each: a substrate DAG or path graph is one bundle, a list of them several, and anything else -- a vertex list, a density, a position-spelled walk -- spreads to its walks *)

seedBundles[ dag_Graph ] /; ! positionSpelledQ[ dag ]                 := { dag }
seedBundles[ dags : { __Graph } ] /; NoneTrue[ dags, positionSpelledQ ] := dags
seedBundles[ other_ ]                                                  := geodesicGraph /@ infraSpread @ other


(* Tarski A4: find x with B(a, b, x) and d(b, x) == d(c, d); the last vertex slot excludes rules so an optioned 3-argument call never lands here *)

ExtendInfraSegment[ graph_Graph, a_, b_, c_, d : Except[ _Rule | _RuleDelayed ],
    count : ( _Integer | UpTo[ _Integer ] | All ) : All ] :=
  With[ { target = GraphDistance[ graph, c, d ] },
    { vs = If[ target === Infinity, { },
        Select[ VertexList[ graph ],
          x |-> BetweennessQ[ graph, a, b, x ] && GraphDistance[ graph, b, x ] === target ] ] },
    countTake[ vs, count ]
  ]


(* ===================== Extension pool ===================== *)

(* the pool of geodesics containing a bundle from p1 to p2 (a DAG with source p1 and sink p2) and extended by at most kmax edges per free side, read off the distance matrix.  The two extension graphs hold the candidate ends, layered by the distance from p1 resp. p2; a pair (s, e) is admissible iff jointly geodesic -- d(s, e) == d(s, p1) + d(p1, p2) + d(p2, e), whichever geodesics are used -- with the larger layer passing kspec (k or UpTo[k]: at most k, {k}: exactly k, {lo, hi}: in range) and each free side either at the budget or inextensible, and its atom is I(p1, s) reversed, the bundle, and I(p2, e), cut out of the extension graphs.  "Exhaustive" with All is the pool itself; every bounded count streams geodesics off the admissible pairs in candidate ("Greedy", "Exhaustive") or random ("RandomGreedy") order, so the class is the same under every Method.  head is the calling symbol, read for its options and messages *)

extensionPool[ _, _Graph, bundle_Graph, _, _, OptionsPattern[] ] /; VertexCount[ bundle ] == 0 := { }

extensionPool[ head_, graph_Graph, bundle_Graph, kspec_, count_, opts : OptionsPattern[] ] :=
  Catch @ With[ {
      properties = OptionValue[ head, { opts }, Properties ],
      methodHead = methodName @ resolveMethod[ OptionValue[ head, { opts }, Method ], count ],
      direction  = OptionValue[ head, { opts }, "Direction" ],
      kmax   = Replace[ kspec, { { _, hi_ } :> hi, { k_ } :> k, UpTo[ k_ ] :> k } ],
      stepsQ = Replace[ kspec, { Infinity :> ( True & ), { k_ } :> ( # == k & ),
                                 { lo_, hi_ } :> ( lo <= # <= hi & ), UpTo[ k_ ] :> ( # <= k & ),
                                 k_Integer :> ( # <= k & ) } ],
      p1 = First @ Select[ VertexList @ bundle, VertexInDegree[ bundle, # ] == 0 & ],
      p2 = First @ Select[ VertexList @ bundle, VertexOutDegree[ bundle, # ] == 0 & ],
      verts = VertexList @ graph },
    If[ properties =!= { }, Message[ MessageName[ head, "badproperty" ], properties ]; Throw[ $Failed ] ];
    If[ ! MatchQ[ direction, "Forward" | "Backward" | "BothSides" ],
      Message[ MessageName[ head, "baddirection" ], direction ]; Throw[ $Failed ] ];
    If[ ! MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ],
      Message[ MessageName[ head, "badmethod" ], methodHead ]; Throw[ $Failed ] ];
    With[ { dm = GraphDistanceMatrix[ graph ], vidx = AssociationThread[ verts, Range @ Length @ verts ],
            leftExt  = GeodesicExtensionGraph[ graph, { p2, p1 } ],
            rightExt = GeodesicExtensionGraph[ graph, { p1, p2 } ] },
      { dist = dm[[ vidx @ #1, vidx @ #2 ]] & },
      { d = dist[ p1, p2 ],
        pairs = Tuples[ {
          If[ direction === "Forward",  { p1 }, Select[ VertexList @ leftExt,  dist[ p1, # ] <= kmax & ] ],
          If[ direction === "Backward", { p2 }, Select[ VertexList @ rightExt, dist[ p2, # ] <= kmax & ] ] } ] },
      { admissibleQ = { s, e } |-> dist[ s, e ] == dist[ s, p1 ] + d + dist[ p2, e ] &&
          stepsQ @ Max[ dist[ p1, s ], dist[ p2, e ] ] &&
          ( direction === "Forward"  || dist[ p1, s ] == kmax ||
            NoneTrue[ AdjacencyList[ graph, s ], dist[ #, e ] == dist[ s, e ] + 1 & ] ) &&
          ( direction === "Backward" || dist[ p2, e ] == kmax ||
            NoneTrue[ AdjacencyList[ graph, e ], dist[ s, # ] == dist[ s, e ] + 1 & ] ),
        atom = { s, e } |-> Graph @ Sort @ Join[
          EdgeList @ ReverseGraph @ Subgraph[ leftExt,
            Select[ VertexList @ leftExt, dist[ p1, # ] + dist[ #, s ] == dist[ p1, s ] & ] ],
          EdgeList @ bundle,
          EdgeList @ Subgraph[ rightExt,
            Select[ VertexList @ rightExt, dist[ p2, # ] + dist[ #, e ] == dist[ p2, e ] & ] ] ] },
      If[ methodHead === "Exhaustive" && count === All,
        atom @@@ Select[ pairs, admissibleQ @@ # & ],
        With[ { cap = countLimit @ count, branch = greedyBranch[ methodHead /. "Exhaustive" -> "Greedy" ] },
          Fold[ { acc, pair } |-> If[ Length @ acc >= cap || ! admissibleQ @@ pair, acc,
              Join[ acc, greedyFrontierSweep[ atom @@ pair, First @ pair, Last @ pair,
                { dag, walk } |-> DeleteCases[ VertexOutComponent[ dag, { Last @ walk }, 1 ], Last @ walk ],
                True &, Infinity, cap - Length @ acc, branch ] ] ],
            { }, branch @ pairs ] ] ]
    ]
  ]


(* ===================== Scene-DSL constructor ===================== *)

(* InfraSegment survives only here, as the scene-language token; the scene engine binds the vertex sequences *)

dispatchConstruction[ graph_Graph, InfraSegment[ p1_, p2_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      infraSpread @ FindInfraSegment[ graph, p1, p2, All,
        Sequence @@ FilterRules[ { opts }, Options[ FindInfraSegment ] ] ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { p1, p2 } |> ],
    extractBranches[ { opts } ] ]


(* ===================== InfraWalkQ ===================== *)

(* consecutive vertices adjacent, revisits allowed: InfraWalkQ superset InfraSegmentQ superset InfraLineQ *)

InfraWalkQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraWalkQ[ graph, # ] & ]

InfraWalkQ[ graph_Graph, w_Graph ] := AllTrue[ walkRealisations @ w, InfraWalkQ[ graph, # ] & ]

InfraWalkQ[ graph_Graph, path_List ] /; Length[ path ] >= 2 :=
  AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ]

InfraWalkQ[ _Graph, path_List ] /; Length[ path ] < 2 := False

InfraWalkQ[ graph_Graph, obj : ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ _Association ] ] :=
  With[ { reps = Normal @ obj }, reps =!= { } && AllTrue[ reps, InfraWalkQ[ graph, # ] & ] ]


(* ===================== InfraSegmentQ ===================== *)

(* consecutive vertices adjacent and the total edge count equal to d(v0, vk); a graph -- one path or a DAG -- passes iff every walk it stands for does *)

InfraSegmentQ[ graph_Graph, ws : { __Graph } ] := AllTrue[ ws, InfraSegmentQ[ graph, # ] & ]

InfraSegmentQ[ graph_Graph, w_Graph ] := AllTrue[ walkRealisations @ w, InfraSegmentQ[ graph, # ] & ]

InfraSegmentQ[ graph_Graph, segment_List ] /; Length[ segment ] >= 2 :=
  GraphDistance[ graph, First[ segment ], Last[ segment ] ] == Length[ segment ] - 1 &&
  AllTrue[ Partition[ segment, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ]

InfraSegmentQ[ _Graph, segment_List ] /; Length[ segment ] < 2 := False

InfraSegmentQ[ graph_Graph, obj : ( InfraSegment | InfraRay | InfraLine | InfraCircle | InfraArc )[ _Association ] ] :=
  With[ { reps = Normal @ obj }, reps =!= { } && AllTrue[ reps, InfraSegmentQ[ graph, # ] & ] ]


(* ===================== UniqueInfraSegmentQ ===================== *)

(* a geodetic graph: every vertex pair admits a unique geodesic *)

UniqueInfraSegmentQ[ graph_Graph, u_, v_ ] := GeodesicMultiplicity[ graph, u, v ] == 1

UniqueInfraSegmentQ[ graph_Graph ] :=
  AllTrue[ Subsets[ VertexList[ graph ], { 2 } ],
    pair |-> UniqueInfraSegmentQ[ graph, pair[[ 1 ]], pair[[ 2 ]] ] ]
