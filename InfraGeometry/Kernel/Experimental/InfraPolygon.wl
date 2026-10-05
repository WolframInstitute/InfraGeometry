Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: InfraPolygon *)

(* a regular n-gon w.r.t. the metric tuple As is a cyclic sequence v_1, ..., v_n with d(v_i, v_{i+k mod n}) satisfying As[[k]] for every i and k; a
   slot is an exact integer, a range {lo, hi} constant across i, or Automatic.  The instance is the polygon on those corners: its sides, one shortest
   path each.

   The family is carried by the FindCycle candidate sweep, filtered by the slot predicates.  The sweep is not lazy -- every n-cycle of the candidate
   graph is materialised before any is tested -- so the next-vertex function only orders or thins what the count takes *)

Options[ FindInfraRegularPolygon ] = {
  Properties           -> { },
  "NextVertexFunction" -> Identity,
  "From"               -> All
}

FindInfraRegularPolygon[ graph_Graph, As_List, n_Integer /; n >= 3,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    1 <= Length[ As ] <= Floor[ n / 2 ] && OptionValue[ FindInfraRegularPolygon, { opts }, Properties ] === { } :=
  With[ {
      nextFn   = OptionValue[ FindInfraRegularPolygon, { opts }, "NextVertexFunction" ],
      fromSpec = OptionValue[ FindInfraRegularPolygon, { opts }, "From" ] },
    With[ { normalize = a |-> Replace[ a, {
                  fam_Association :> Keys @ fam,
                  list_List /; AllTrue[ list, MatchQ[ _Association ] ] :> list[[ All, 1, 1 ]] } ] },
          { from = Replace[ fromSpec, {
              All -> { None, All },
              ( anchor_ -> r_Integer ) /; r >= 0 :> { normalize @ anchor, r },
              anchor : Except[ _Rule ] :> { normalize @ anchor, All } } ],
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
          { ordered = Replace[ nextFn @ candidates, chosen_ /; MemberQ[ candidates, Verbatim @ chosen ] :> { chosen } ] },
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
            _,         If[ Length @ polygons < count, { }, Take[ polygons, count ] ] ] ] ]

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
    Length[ cycle ] < 3 && ! MatchQ[ cycle, { __Graph } | { { __Graph } .. } ] :=
  False

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

FindInfraRepresentative[ graph_Graph, InfraPolygon[ As_List, n_Integer, opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  Replace[
    FindInfraRegularPolygon[ graph, As, n, count,
      Sequence @@ searchMethod[ mods ], Sequence @@ FilterRules[ { opts }, Options[ FindInfraRegularPolygon ] ] ],
    { legs : { __Graph } :> Most @ polylineToVertexSeq @ legs, polygons_List :> Most @* polylineToVertexSeq /@ polygons } ]
