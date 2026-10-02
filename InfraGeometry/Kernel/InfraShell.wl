Package[ "WolframInstitute`InfraGeometry`" ]

(* a vertex subset of the level surface { v : rmin <= d(c, v) <= rmax }, a sorted vertex list; the count-less call is one shell, a bounded count and
   All a List of them -- the level set itself without Properties, the minimal admissible subsets under them *)

Options[ FindInfraShell ] = {
  Properties -> { },
  Method     -> Automatic
}

FindInfraShell[ graph_Graph, p_, r_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraShell, { opts }, Properties ] ] &&
      MatchQ[ OptionValue[ FindInfraShell, { opts }, Method ],
        Automatic | "Exhaustive" | "Greedy" | "RandomGreedy" | { "Exhaustive" | "Greedy" | "RandomGreedy", ___ } ] :=
  With[ {
      properties = OptionValue[ FindInfraShell, { opts }, Properties ],
      methodSpec = Replace[ OptionValue[ FindInfraShell, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ],
      range = Replace[ r, d_?NumericQ :> { d, d } ],
      radius = If[ NumericQ[ r ], r, Mean[ r ] ] },
    { methodHead = Replace[ methodSpec, { m_String, ___ } :> m ],
      pruning = Replace[ methodSpec, { { "Exhaustive", subs___ } :> ( "Pruning" /. { subs } /. "Pruning" -> Infinity ), _ :> Infinity } ],
      cap = Replace[ count, { All | Infinity -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { results = Map[
        p0 |-> With[ { localG = If[ NumericQ[ range[[ 2 ]] ], NeighborhoodGraph[ graph, p0, Ceiling[ range[[ 2 ]] ] + 1 ], graph ] },
          { levelSet = Select[ VertexList[ localG ], range[[ 1 ]] <= GraphDistance[ localG, p0, # ] <= range[[ 2 ]] & ] },
          If[ properties === { },
            { levelSet },
            With[ { tests = Replace[ properties, {
                    "Separating" -> ( t |-> With[ { rem = VertexDelete[ localG, t ] },
                      { centerComp = SelectFirst[ ConnectedComponents[ rem ], MemberQ[ #, p0 ] & ] },
                      centerComp =!= Missing[ "NotFound" ] &&
                      AllTrue[ centerComp, GraphDistance[ localG, p0, # ] <= radius & ] &&
                      AllTrue[ Complement[ VertexList[ rem ], centerComp ], GraphDistance[ localG, p0, # ] > radius & ] ] ),
                    "Connected"  -> ( t |-> t =!= { } && ConnectedGraphQ @ Subgraph[ localG, t ] ) }, { 1 } ] },
              { admissible = t |-> AllTrue[ tests, # @ t & ],
                pick = If[ methodHead === "Greedy", Identity, RandomSample ] },
              { descend = { self, state, T } |-> If[ Length @ First @ state >= cap || KeyExistsQ[ Last @ state, T ],
                  state,
                  With[ { marked = { First @ state, Append[ Last @ state, T -> True ] },
                          peelable = Select[ T, w |-> admissible[ DeleteCases[ T, w ] ] ] },
                    If[ peelable === { },
                      { Append[ First @ marked, T ], Last @ marked },
                      Fold[ { s, w } |-> self[ self, s, DeleteCases[ T, w ] ], marked, pick @ peelable ] ] ] ] },
              Which[
                ! admissible[ levelSet ], { },
                methodHead === "Exhaustive",
                  DeleteDuplicates @ Last @ NestWhile[
                    state |-> With[ { rows = Map[
                        T |-> With[ { removable = Select[ T, v |-> admissible[ DeleteCases[ T, v ] ] ] },
                          If[ removable === { },
                            { { T }, { } },
                            { { }, Map[ v |-> Sort @ DeleteCases[ T, v ], Switch[ pruning,
                                Infinity, removable,
                                _Integer, If[ Length[ removable ] <= pruning, removable, RandomSample[ removable, pruning ] ],
                                _,        With[ { kept = Select[ removable, RandomReal[ ] < pruning & ] },
                                            If[ kept === { }, RandomSample[ removable, 1 ], kept ] ] ] ] } ] ],
                        First @ state ] },
                      { DeleteDuplicates @ Catenate @ rows[[ All, 2 ]], Join[ Last @ state, Catenate @ rows[[ All, 1 ]] ] } ],
                    { { Sort @ levelSet }, { } },
                    First @ # =!= { } & ],
                True,
                  First @ descend[ descend, { { }, <| |> }, levelSet ] ] ] ] ],
        Keys @ InfraDensity[ graph, p ] ] },
    { shells = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
    Switch[ count,
      Automatic, First[ shells, { } ],
      All,       shells,
      _UpTo,     Take[ shells, count ],
      _,         If[ Length @ shells < count, { }, Take[ shells, count ] ] ] ]

(* for every c equidistant from all k window vertices at common distance r, the level set { v : d(c, v) == r } *)

Options[ FindInfraOsculatingShell ] = Options[ FindInfraShell ]

FindInfraOsculatingShell[ graph_Graph, path_, i_Integer, k_Integer,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[ ] ] /;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraOsculatingShell, { opts }, Properties ] ] &&
      MatchQ[ OptionValue[ FindInfraOsculatingShell, { opts }, Method ],
        Automatic | "Exhaustive" | "Greedy" | "RandomGreedy" | { "Exhaustive" | "Greedy" | "RandomGreedy", ___ } ] :=
  With[ {
      walksOf = w |-> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
          EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
          spelled,            { Last /@ SortBy[ vs, First ] },
          DirectedGraphQ @ w,
            Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
      vlist = VertexList @ graph,
      dm = GraphDistanceMatrix @ graph },
    { walks = Which[
        AssociationQ @ path,         Keys @ path,
        GraphQ @ path,               walksOf @ path,
        MatchQ[ path, { __Graph } ], Catenate[ walksOf /@ path ],
        path === { },                { },
        True,                        { path } ],
      vidx = AssociationThread[ vlist -> Range @ Length @ vlist ] },
    { pairs = SortBy[
        DeleteDuplicates @ Flatten[
          Map[
            walk |-> With[ {
                lo = Clip[ i - Floor[ ( k - 1 ) / 2 ], { 1, Length @ walk } ],
                hi = Clip[ i + Ceiling[ ( k - 1 ) / 2 ], { 1, Length @ walk } ] },
              { cols = Lookup[ vidx, walk[[ lo ;; hi ]] ] },
              MapThread[
                If[ SameQ @@ #2, { #1, First @ #2 }, Nothing ] &,
                { vlist, dm[[ All, cols ]] } ] ],
            walks ],
          1 ],
        { Last, First } ] },
    { sets = DeleteDuplicates @ Catenate[ FindInfraShell[ graph, #[[ 1 ]], #[[ 2 ]], All, opts ] & /@ pairs ] },
    Switch[ count,
      All,   sets,
      _UpTo, Take[ sets, count ],
      _,     If[ Length @ sets < count, { }, Take[ sets, count ] ] ] ]

Options[ FindInfraShellCenter ] = { Method -> "MaximalChordsBisectors" }

FindInfraShellCenter[ graph_Graph, fam_Association, opts : OptionsPattern[] ] :=
  FindInfraShellCenter[ graph, Keys @ fam, opts ]

FindInfraShellCenter[ graph_Graph, vs_List, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ FindInfraShellCenter, { opts }, Method ],
      "MaximalChordsBisectors" | "EquidistantPoints" | { "EquidistantPoints", ___ } |
        ( { "MaximalChordsBisectors", o___ } /; MatchQ[ Lookup[ { o }, "Maximality", "PerVertex" ], "PerVertex" | "Diameter" ] &&
          MatchQ[ Lookup[ { o }, "Distance", "Extrinsic" ], "Extrinsic" | "Intrinsic" ] &&
          MatchQ[ Lookup[ { o }, "Parity", All ], All | "Even" | "Odd" ] ) ] :=
  With[ { spec = OptionValue[ Method ] },
    { mopts = Replace[ spec, { { _String, o___ } :> { o }, _ -> { } } ] },
    { maximality = Lookup[ mopts, "Maximality", "PerVertex" ],
      distance   = Lookup[ mopts, "Distance", "Extrinsic" ],
      parity     = Lookup[ mopts, "Parity", All ] },
    Switch[ Replace[ spec, { m_String, ___ } :> m ],
      "MaximalChordsBisectors",
            With[ { dm  = GraphDistanceMatrix[ graph ],
                    idx = AssociationThread[ VertexList[ graph ] -> Range @ VertexCount @ graph ] },
              { dsel = If[ distance === "Intrinsic",
                         With[ { subg = Subgraph[ graph, vs ] },
                           { rows = Lookup[ AssociationThread[ VertexList[ subg ] -> Range @ VertexCount @ subg ], vs ] },
                           GraphDistanceMatrix[ subg ][[ rows, rows ]] ],
                         dm[[ Lookup[ idx, vs ], Lookup[ idx, vs ] ]] ] },
              { chords = Switch[ maximality,
                  "Diameter",
                    With[ { dmax = Max @ Select[ Flatten @ dsel, Positive[ # ] && # =!= Infinity & ] },
                      { vs[[ #[[ 1 ]] ]], vs[[ #[[ 2 ]] ]] } & /@
                        Select[ Subsets[ Range @ Length @ vs, { 2 } ], dsel[[ #[[ 1 ]], #[[ 2 ]] ]] == dmax & ] ],
                  "PerVertex",
                    DeleteDuplicates[ Sort /@ Flatten[
                      Table[
                        With[ { row = ReplacePart[ dsel[[ i ]], i -> Infinity ] },
                          { ecc = Max @ Select[ row, # =!= Infinity & ] },
                          { vs[[ i ]], # } & /@ Pick[ vs, Thread[ row == ecc ], True ] ],
                        { i, Length[ vs ] } ], 1 ] ] ] },
              { kept = Select[ chords,
                  With[ { d = dm[[ idx @ #[[ 1 ]], idx @ #[[ 2 ]] ]] },
                    Switch[ parity, All, True, "Even", EvenQ[ d ], "Odd", OddQ[ d ] ] ] & ] },
              { radiiBins = GroupBy[ Catenate[ Map[
                  chord |-> With[ { ab = Sort @ chord, verts = Keys @ idx },
                    { ia = idx @ ab[[ 1 ]], ib = idx @ ab[[ 2 ]] },
                    { d = dm[[ ia, ib ]] },
                    { half = { Floor[ d/2 ], Ceiling[ d/2 ] } },
                    Cases[ Transpose @ { verts, dm[[ ia ]], dm[[ All, ib ]] },
                      { v_, da_, db_ } /; da + db == d && MemberQ[ half, da ] :> { v, da } ] ],
                  kept ] ], Last -> First ] },
              KeyValueMap[ { r, vlist } |-> { KeySort @ Counts @ vlist, r }, KeySort @ radiiBins ] ],
      "EquidistantPoints",
        With[ { ds = AssociationThread[ VertexList[ graph ], GraphDistance[ graph, First @ vs ] ] },
          { centers = Select[ FindInfraEquidistantSet[ graph, vs ], c |-> 0 < ds[ c ] < Infinity ] },
          KeyValueMap[ { r, cs } |-> { KeySort @ AssociationMap[ 1 &, cs ], r }, KeySort @ GroupBy[ centers, ds ] ] ] ] ]

(* vs is a metric shell iff some c is equidistant from all of vs at a common finite radius r and vs is exactly { v : d(c, v) == r } *)

InfraShellQ[ graph_Graph, fam_Association ] :=
  InfraShellQ[ graph, Keys @ fam ]

InfraShellQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraShellQ[ graph, # ] & ]

InfraShellQ[ graph_Graph, vs_List ] :=
  AnyTrue[ VertexList[ graph ],
    c |-> With[ { ds = GraphDistance[ graph, c, # ] & /@ vs },
      SameQ @@ ds && First[ ds ] =!= Infinity &&
      Sort @ Select[ VertexList[ graph ], GraphDistance[ graph, c, # ] === First[ ds ] & ] === Sort[ vs ]
    ] ]

SeparatesQ[ graph_Graph, vs_List, u_, v_ ] :=
  If[ MemberQ[ vs, u ] || MemberQ[ vs, v ], False,
    GraphDistance[ VertexDelete[ graph, vs ], u, v ] === Infinity
  ]

(* the shell { v : r <= d(v, C) <= s } with d(v, C) = min_{c in C} d(v, c), the complement of the ball of radius s by the open ball of radius r *)

InfraMeasurement[ graph_Graph, InfraShell[ center_, { r_, s_ } ], "VertexDensity" ] :=
  With[ { centers = Keys @ InfraDensity[ graph, center ], n = VertexCount @ graph },
    { far = VertexList @ NeighborhoodGraph[ graph, centers, Floor @ Min[ s, n ] ],
      near = If[ r > 0, VertexList @ NeighborhoodGraph[ graph, centers, Min[ Ceiling[ r ] - 1, n ] ], { } ] },
    AssociationThread[ Complement[ far, near ], 1 ] ]

InfraMeasurement[ graph_Graph, InfraShell[ center_, r : Except[ _List ] ], "VertexDensity" ] :=
  InfraMeasurement[ graph, InfraShell[ center, { r, r } ], "VertexDensity" ]

InfraMeasurement[ graph_Graph, shell : InfraShell[ _, _ ], "EdgeDensity" ] :=
  AssociationThread[ EdgeList @ Subgraph[ graph, Keys @ InfraMeasurement[ graph, shell, "VertexDensity" ] ], 1 ]

InfraMeasurement[ _Graph, InfraShell[ _, _ ], "Cardinality" ] :=
  1

InfraMeasurement[ _Graph, InfraShell[ _, _ ], "Faithful" ] :=
  True

InfraMeasurement[ graph_Graph, shell : InfraShell[ _, _ ], All ] :=
  InfraMeasurement[ graph, shell,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" } ]

FindInfraRepresentative[ graph_Graph, shell : InfraShell[ _, _ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  takeRepresentatives[ { Keys @ InfraMeasurement[ graph, shell, "VertexDensity" ] }, count, mods ]

FindInfraRepresentative[ graph_Graph, InfraShell[ center_, r_, opts__Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  FindInfraShell[ graph, center, r, count,
    Sequence @@ searchMethod[ mods ], Sequence @@ FilterRules[ { opts }, Options[ FindInfraShell ] ] ]
