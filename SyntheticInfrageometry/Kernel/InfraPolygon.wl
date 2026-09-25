Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== FindInfraPolygon ===================== *)

(* a polygon through the listed corners is its sides: one geodesic (p_i, p_{i+1 mod n}) per consecutive pair, each a directed path graph on the substrate vertices, consecutive sides sharing their corner and the last closing on the first.  The instance is the List of sides, since a corner is a fact about the polygon and not about the closed walk, which may even retrace a side; the count-less call is one polygon, a bounded count and All a List of them, and the Cartesian product over sides is the class *)

FindInfraPolygon::badmethod = "Method `1` is not supported by FindInfraPolygon.";

Options[ FindInfraPolygon ] = { Method -> Automatic };

(* "Exhaustive" with All forms the product; a bounded count streams that many geodesics per side, in candidate ("Greedy", "Exhaustive") or random ("RandomGreedy") order, and reads members of their product off its mixed-radix index *)

FindInfraPolygon[ graph_Graph, vertices_List /; Length[ vertices ] >= 3,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  Module[ { acc, descend },
    With[ { methodSpec = Replace[ OptionValue[ FindInfraPolygon, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ],
            cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
      { method = Replace[ methodSpec, { m_String, ___ } :> m ],
        (* a bounded count streams more geodesics per side than it needs: with one per side the product is a single tuple, and a witness has no room to avoid degeneracy *)
        sideCap = If[ count === All, Infinity, Max[ 8, 2 cap ] ] },
      If[ ! MatchQ[ method, "Exhaustive" | "Greedy" | "RandomGreedy" ],
        Message[ FindInfraPolygon::badmethod, methodSpec ]; $Failed,
        With[ { sides = Apply[ { a, b } |->
              With[ { dag = If[ method === "Exhaustive" || a === b, Null, GeodesicIntervalGraph[ graph, a, b ] ] },
                Which[
                  a === b, { },
                  method === "Exhaustive",
                    With[ { d = GraphDistance[ graph, a, b ] },
                      If[ d === Infinity, { }, FindPath[ graph, a, b, { d }, Replace[ sideCap, Infinity -> All ] ] ] ],
                  VertexCount @ dag == 0, { },
                  method === "Greedy" && count === All, FindPath[ dag, a, b, Infinity, All ],
                  (* the interval DAG is the pool, so its lazy descent is complete and exact: out-edges in edge order for "Greedy", shuffled at every vertex for "RandomGreedy" *)
                  True,
                    With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ] },
                      descend[ path_ ] := If[ Last @ path === b,
                        AppendTo[ acc, path ]; If[ Length @ acc >= sideCap, Throw[ acc, descend ] ],
                        Scan[ descend[ Append[ path, # ] ] &,
                          If[ method === "Greedy", Lookup[ out, Key @ Last @ path, { } ],
                            RandomSample @ DeleteCases[ VertexOutComponent[ dag, { Last @ path }, 1 ], Last @ path ] ] ] ];
                      acc = { };
                      Catch[ descend[ { a } ]; acc, descend ] ] ] ],
              Partition[ Append[ vertices, First @ vertices ], 2, 1 ], { 1 } ] },
          (* a bounded count takes the product's members in mixed-radix order, but a degenerate polygon -- one whose closed side sequence walks an edge twice, the 1-3-9 triangle of GridGraph[{3,3}] closing along 9-6-3-2-1 -- is a poor witness for a class that also holds honest ones.  The scan window is wide enough to pass over the degenerate prefix and still exact: it yields Min[n, |class|] polygons, degenerate ones only once the window is spent *)
          { polygons = Map[ PathGraph[ #, DirectedEdges -> True ] &,
              If[ count === All, Tuples @ sides,
                With[ { sizes = Length /@ sides,
                        retracesQ = tuple |-> ! DuplicateFreeQ[ Sort /@ Partition[ Join @@ Prepend[ Rest /@ Rest @ tuple, First @ tuple ], 2, 1 ] ] },
                  { total = Times @@ sizes },
                  { scanned = Table[
                      MapThread[ Part, { sides, 1 + IntegerDigits[ j, MixedRadix @ sizes, Length @ sides ] } ],
                      { j, 0, Min[ total, Max[ 200, 20 cap ] ] - 1 } ] },
                  Take[ Join[ Select[ scanned, ! retracesQ @ # & ], Select[ scanned, retracesQ ] ], UpTo[ Min[ cap, total ] ] ] ] ],
              { 2 } ] },
          Switch[ count,
            Automatic, First[ polygons, { } ],
            All,       polygons,
            _UpTo,     Take[ polygons, count ],
            _,         If[ Length @ polygons < count, $Failed, Take[ polygons, count ] ] ] ] ] ] ]


(* ===================== InfraPolygonQ ===================== *)

(* every side a geodesic and consecutive sides, cyclically, sharing their endpoint *)

InfraPolygonQ[ graph_Graph, polys : { { __Graph } .. } ] :=
  AllTrue[ polys, InfraPolygonQ[ graph, # ] & ]

InfraPolygonQ[ graph_Graph, sides : { __Graph } ] :=
  With[ { seqs = ( w |-> With[ { vs = VertexList @ w },
        If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          Last /@ SortBy[ vs, First ],
          Reap[ DepthFirstScan[ w,
            SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
            { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] ) /@ sides },
    AllTrue[ seqs, InfraSegmentQ[ graph, # ] & ] &&
    AllTrue[ Partition[ Append[ seqs, First @ seqs ], 2, 1 ], pair |-> Last[ pair[[ 1 ]] ] === First[ pair[[ 2 ]] ] ] ]

InfraPolygonQ[ _Graph, _ ] := False


(* ===================== FindInfraRegularPolygon ===================== *)

(* a regular n-gon w.r.t. the metric tuple As is a cyclic sequence v_1, ..., v_n with d(v_i, v_{i+k mod n}) satisfying As[[k]] for every i and k; a slot is an exact integer, a range {lo, hi} constant across i, or Automatic.  The instance is the polygon on those corners: its sides, one shortest path each.

   The family is carried by the FindCycle candidate sweep, filtered by the slot predicates.  The sweep is not lazy -- every n-cycle of the candidate graph is materialised before any is tested -- so "Greedy" and "RandomGreedy" here only order what the count takes, in candidate and random order respectively; the class is the same under all three *)

FindInfraRegularPolygon::badproperty = "Property `1` is not supported by FindInfraRegularPolygon.";
FindInfraRegularPolygon::badmethod   = "Method `1` is not supported by FindInfraRegularPolygon.";
FindInfraRegularPolygon::badcount    = "Diagonal tuple `1` has length exceeding Floor[n/2] for n = `2`.";

Options[ FindInfraRegularPolygon ] = {
  Properties -> { },
  Method     -> Automatic,
  "From"     -> All
};

FindInfraRegularPolygon[ graph_Graph, As_List, n_Integer /; n >= 3,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ {
      properties = OptionValue[ FindInfraRegularPolygon, { opts }, Properties ],
      methodSpec = Replace[ OptionValue[ FindInfraRegularPolygon, { opts }, Method ],
                     Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ],
      fromSpec   = OptionValue[ FindInfraRegularPolygon, { opts }, "From" ] },
    { methodHead = Replace[ methodSpec, { m_String, ___ } :> m ] },
    Which[
      properties =!= { },
        Message[ FindInfraRegularPolygon::badproperty, First @ properties ]; $Failed,
      Length[ As ] < 1 || Length[ As ] > Floor[ n / 2 ],
        Message[ FindInfraRegularPolygon::badcount, As, n ]; $Failed,
      ! MatchQ[ methodHead, "Exhaustive" | "Greedy" | "RandomGreedy" ],
        Message[ FindInfraRegularPolygon::badmethod, methodSpec ]; $Failed,
      True,
        With[ { normalize = a |-> Replace[ a, {
                  fam_Association :> Keys @ fam,
                  list_List /; AllTrue[ list, MatchQ[ _Association ] ] :> list[[ All, 1, 1 ]] } ] },
          { from = Replace[ fromSpec, {
              All -> { None, All },
              ( anchor_ -> r_Integer ) /; r >= 0 :> { normalize @ anchor, r },
              anchor : Except[ _Rule ] :> { normalize @ anchor, All } } ],
            pruning = "Pruning" /. Replace[ methodSpec, { { _String, o___ } :> { o }, _ -> { } } ] /. "Pruning" -> Infinity,
            dm = GraphDistanceMatrix @ graph,
            vs = VertexList @ graph },
          { anchor = First @ from, radius = Last @ from,
            idx = AssociationThread[ vs -> Range @ Length @ vs ] },
          { workGraph = If[ anchor === None || radius === All, graph, NeighborhoodGraph[ graph, anchor, radius ] ] },
          { workVs = VertexList @ workGraph },
          { workDm = If[ workGraph === graph, dm, dm[[ idx /@ workVs, idx /@ workVs ]] ] },
          { candidates = Map[ First, FindCycle[
              Replace[ First @ As, {
                Automatic -> workGraph,
                slot : ( _Integer | { _Integer, _Integer } ) :> With[
                  { mask = Boole @ Map[ If[ IntegerQ @ slot, # === slot &, slot[[ 1 ]] <= # <= slot[[ 2 ]] & ], workDm, { 2 } ] },
                  AdjacencyGraph[ workVs, mask - DiagonalMatrix @ Diagonal @ mask ] ] } ],
              { n }, All ], { 2 } ],
            slotQ = { k, slot, cyc } |-> With[
              { ds = Table[ dm[[ idx @ cyc[[ i ]], idx @ cyc[[ Mod[ i + k - 1, Length @ cyc ] + 1 ]] ]], { i, Length @ cyc } ] },
              Switch[ slot,
                _Integer,               AllTrue[ ds, # === slot & ],
                { _Integer, _Integer }, Length[ Union @ ds ] === 1 && slot[[ 1 ]] <= First @ ds <= slot[[ 2 ]],
                Automatic,              Length[ Union @ ds ] === 1 ] ] },
          (* a beam width (integer cap, random sampling if exceeded) or a Bernoulli keep probability, with a one-element floor so the bundle never dies by chance *)
          { ordered = If[ methodHead === "RandomGreedy", RandomSample, Identity ] @ Which[
              pruning === Infinity, candidates,
              IntegerQ[ pruning ] && pruning >= 1,
                If[ Length[ candidates ] <= pruning, candidates, RandomSample[ candidates, pruning ] ],
              NumericQ[ pruning ] && 0 < pruning < 1,
                If[ candidates === { }, { },
                  With[ { kept = Select[ candidates, RandomReal[ ] < pruning & ] },
                    If[ kept === { }, RandomSample[ candidates, 1 ], kept ] ] ] ] },
          { core = DeleteDuplicates @ Select[
              If[ anchor =!= None && radius === All,
                Select[ ordered, cyc |-> If[ ListQ @ anchor, IntersectingQ[ cyc, anchor ], MemberQ[ cyc, anchor ] ] ],
                ordered ],
              cyc |-> AllTrue[ Range @ Length @ As, slotQ[ #, As[[ # ]], cyc ] & ] ] },
          { polygons = Map[ cyc |-> MapThread[ { a, b } |-> PathGraph[ FindShortestPath[ graph, a, b ], DirectedEdges -> True ],
              { cyc, RotateLeft @ cyc } ], core ] },
          Switch[ count,
            Automatic, First[ polygons, { } ],
            All,       polygons,
            _UpTo,     Take[ polygons, count ],
            _,         If[ Length @ polygons < count, $Failed, Take[ polygons, count ] ] ] ] ] ]


(* ===================== InfraRegularPolygonQ ===================== *)

(* the corner cycle carries the test; a polygon is read at its corners, a cycle graph as its closed walk *)

InfraRegularPolygonQ[ graph_Graph, cycle_List, As_List ] /;
    Length[ cycle ] >= 3 && ! MatchQ[ cycle, { __Graph } | { { __Graph } .. } ] :=
  With[ { open = If[ First @ cycle === Last @ cycle, Most @ cycle, cycle ] },
    { n  = Length @ open,
      dm = GraphDistanceMatrix @ graph,
      vs = VertexList @ graph },
    { idx = AssociationThread[ vs -> Range @ Length @ vs ] },
    DuplicateFreeQ[ open ] &&
    Length[ As ] >= 1 && Length[ As ] <= Floor[ n / 2 ] &&
    AllTrue[ As, MatchQ[ _Integer | { _Integer, _Integer } | Automatic ] ] &&
    AllTrue[ Range @ Length @ As,
      k |-> With[ { ds = Table[ dm[[ idx @ open[[ i ]], idx @ open[[ Mod[ i + k - 1, n ] + 1 ]] ]], { i, n } ] },
        Switch[ As[[ k ]],
          _Integer,               AllTrue[ ds, # === As[[ k ]] & ],
          { _Integer, _Integer }, Length[ Union @ ds ] === 1 && As[[ k, 1 ]] <= First @ ds <= As[[ k, 2 ]],
          Automatic,              Length[ Union @ ds ] === 1 ] ] ]
  ]

InfraRegularPolygonQ[ _Graph, cycle_List, _List ] /;
    Length[ cycle ] < 3 && ! MatchQ[ cycle, { __Graph } | { { __Graph } .. } ] := False

InfraRegularPolygonQ[ graph_Graph, polys : { { __Graph } .. }, As_List ] :=
  AllTrue[ polys, InfraRegularPolygonQ[ graph, #, As ] & ]

InfraRegularPolygonQ[ graph_Graph, sides : { __Graph }, As_List ] :=
  With[ { seqs = ( w |-> With[ { vs = VertexList @ w },
          If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
            Last /@ SortBy[ vs, First ],
            Reap[ DepthFirstScan[ w,
              SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
              { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ] ) /@ sides },
    InfraRegularPolygonQ[ graph, Most @ Prepend[ Last /@ seqs, First @ First @ seqs ], As ] ]

InfraRegularPolygonQ[ graph_Graph, w_Graph, As_List ] :=
  InfraRegularPolygonQ[ graph,
    With[ { vs = VertexList @ w },
      If[ AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
        Last /@ SortBy[ vs, First ],
        Reap[ DepthFirstScan[ w,
          SelectFirst[ vs, If[ DirectedGraphQ @ w, VertexInDegree[ w, # ] == 0, VertexDegree[ w, # ] == 1 ] &, First @ vs ],
          { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] ] ],
    As ]


(* ===================== Scene-DSL constructors ===================== *)

(* the scene engine binds the closed corner sequence of a regular polygon and the closed vertex sequence of a polygon through corners *)

dispatchConstruction[ graph_Graph, InfraPolygon[ As_List, n_Integer, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      Most @* polylineToVertexSeq /@ FindInfraRegularPolygon[ graph, As, n, All,
        Sequence @@ FilterRules[ { opts }, Options[ FindInfraRegularPolygon ] ] ],
      "Select" /. { opts } /. "Select" -> None,
      True, <||> ],
    extractBranches[ { opts } ] ]

dispatchConstruction[ graph_Graph, InfraPolygon[ verts_List, opts___Rule ] ] :=
  capBranches[
    polylineToVertexSeq /@ FindInfraPolygon[ graph, verts, All,
      Sequence @@ FilterRules[ { opts }, Options[ FindInfraPolygon ] ] ],
    extractBranches[ { opts } ] ]
