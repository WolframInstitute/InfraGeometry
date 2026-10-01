Package["WolframInstitute`InfraGeometry`"]

(* a vertex subset of the level surface { v : rmin <= d(c, v) <= rmax }, a sorted vertex list; the count-less call is one shell, a bounded count and All a List of them -- the level set itself without Properties, the minimal admissible subsets under them *)

Options[ FindInfraShell ] = {
  Properties -> { },
  Method     -> Automatic
};

FindInfraShell[ graph_Graph, p_, r_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ]/;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraShell, { opts }, Properties ] ] &&
      MatchQ[ OptionValue[ FindInfraShell, { opts }, Method ], Automatic | "Exhaustive" | "Greedy" | "RandomGreedy" | { "Exhaustive" | "Greedy" | "RandomGreedy", ___ } ] :=
  With[ { results = Map[
      p0 |-> Module[ { properties, methodSpec, methodHead, pruning, range, localG, levelSet, radius, admissible,
                       cap, acc, seen, pick, descend, frontier, minimals, next, removable, key },
        properties = OptionValue[ FindInfraShell, { opts }, Properties ];
        methodSpec = Replace[ OptionValue[ FindInfraShell, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ];
        methodHead = Replace[ methodSpec, { m_String, ___ } :> m ];
        pruning    = Replace[ methodSpec,
                      { { "Exhaustive", subs___ } :> ( "Pruning" /. { subs } /. "Pruning" -> Infinity ),
                        _ :> Infinity } ];
        range = Replace[ r, d_?NumericQ :> { d, d } ];
        localG = If[ NumericQ[ range[[ 2 ]] ],
                     NeighborhoodGraph[ graph, p0, Ceiling[ range[[ 2 ]] ] + 1 ], graph ];
        levelSet = Select[ VertexList[ localG ],
          range[[ 1 ]] <= GraphDistance[ localG, p0, # ] <= range[[ 2 ]] & ];
        radius = If[ NumericQ[ r ], r, Mean[ r ] ];
        If[ properties === { },
          { levelSet },
          admissible = With[ { tests = Replace[ properties, {
                  "Separating" -> ( t |-> With[ { rem = VertexDelete[ localG, t ] },
                    { centerComp = SelectFirst[ ConnectedComponents[ rem ], MemberQ[ #, p0 ] & ] },
                    centerComp =!= Missing[ "NotFound" ] &&
                    AllTrue[ centerComp, GraphDistance[ localG, p0, # ] <= radius & ] &&
                    AllTrue[ Complement[ VertexList[ rem ], centerComp ], GraphDistance[ localG, p0, # ] > radius & ] ] ),
                  "Connected"  -> ( t |-> t =!= { } && ConnectedGraphQ @ Subgraph[ localG, t ] ) }, { 1 } ] },
              t |-> AllTrue[ tests, # @ t & ] ];
            Switch[ methodHead,
              "Exhaustive",
                If[ ! admissible[ levelSet ], { },
                  frontier = { Sort @ levelSet };
                  seen = <| Sort @ levelSet -> True |>;
                  minimals = { };
                  While[ frontier =!= { },
                    next = { };
                    Do[
                      removable = Select[ T, v |-> admissible[ DeleteCases[ T, v ] ] ];
                      If[ removable === { },
                        AppendTo[ minimals, T ],
                        Do[
                          key = Sort @ DeleteCases[ T, v ];
                          If[ ! KeyExistsQ[ seen, key ],
                            seen[ key ] = True;
                            AppendTo[ next, key ] ],
                          { v, Switch[ pruning,
                              Infinity, removable,
                              _Integer, If[ Length[ removable ] <= pruning, removable, RandomSample[ removable, pruning ] ],
                              _,        With[ { kept = Select[ removable, RandomReal[ ] < pruning & ] },
                                          If[ kept === { }, RandomSample[ removable, 1 ], kept ] ] ] } ]
                      ],
                      { T, frontier } ];
                    frontier = next;
                  ];
                  DeleteDuplicates @ minimals
                ],
              "Greedy" | "RandomGreedy",
                If[ ! admissible[ levelSet ], { },
                  cap  = Replace[ count, { All | Infinity -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ];
                  acc  = { };
                  seen = <||>;
                  pick = If[ methodHead === "Greedy", Identity, RandomSample ];
                  descend[ T_ ] :=
                    If[ ! KeyExistsQ[ seen, T ],
                      seen[ T ] = True;
                      With[ { peelable = Select[ T, w |-> admissible[ DeleteCases[ T, w ] ] ] },
                        If[ peelable === { },
                          AppendTo[ acc, T ];
                          If[ Length @ acc >= cap, Throw[ acc, descend ] ],
                          Scan[ descend[ DeleteCases[ T, # ] ] &, pick @ peelable ] ] ] ];
                  Catch[ descend[ levelSet ]; acc, descend ]
                ]
            ]
        ]
      ], Keys @ InfraDensity[ graph, p ] ] },
    With[ { shells = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          Automatic, First[ shells, { } ],
          All,       shells,
          _UpTo,     Take[ shells, count ],
          _,         If[ Length @ shells < count, { }, Take[ shells, count ] ] ] ] ]

(* for every c equidistant from all k window vertices at common distance r, the level set { v : d(c, v) == r } *)

Options[ FindInfraOsculatingShell ] = Options[ FindInfraShell ];

FindInfraOsculatingShell[ graph_Graph, path_, i_Integer, k_Integer,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[ ] ]/;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraOsculatingShell, { opts }, Properties ] ] &&
      MatchQ[ OptionValue[ FindInfraOsculatingShell, { opts }, Method ], Automatic | "Exhaustive" | "Greedy" | "RandomGreedy" | { "Exhaustive" | "Greedy" | "RandomGreedy", ___ } ] :=
  Module[ { walksOf, walks, vlist, vidx, dm, pairs, sets },
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
        True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ];
    walks = Which[
      AssociationQ @ path,         Keys @ path,
      GraphQ @ path,               walksOf @ path,
      MatchQ[ path, { __Graph } ], Catenate[ walksOf /@ path ],
      path === { },                { },
      True,                        { path } ];
    vlist = VertexList @ graph;
    vidx  = AssociationThread[ vlist -> Range @ Length @ vlist ];
    dm    = GraphDistanceMatrix @ graph;
    pairs = SortBy[
      DeleteDuplicates @ Flatten[
        Map[
          walk |-> With[ {
              lo = Clip[ i - Floor[ ( k - 1 ) / 2 ], { 1, Length @ walk } ],
              hi = Clip[ i + Ceiling[ ( k - 1 ) / 2 ], { 1, Length @ walk } ] },
            { cols = Lookup[ vidx, walk[[ lo ;; hi ]] ] },
            MapThread[
              If[ SameQ @@ #2, { #1, First @ #2 }, Nothing ] &,
              { vlist, dm[[ All, cols ]] } ]
          ],
          walks ],
        1 ],
      { Last, First } ];
    sets = DeleteDuplicates @ Catenate[ FindInfraShell[ graph, #[[ 1 ]], #[[ 2 ]], All, opts ] & /@ pairs ];
    Switch[ count,
      All,   sets,
      _UpTo, Take[ sets, count ],
      _,     If[ Length @ sets < count, { }, Take[ sets, count ] ] ]
  ]

Options[ FindInfraShellCenter ] = { Method -> "MaximalChordsBisectors" };

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

InfraShellQ[ graph_Graph, fam_Association ] := InfraShellQ[ graph, Keys @ fam ]

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

dispatchConstruction[ graph_Graph, InfraShell[ center_, r_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      FindInfraShell[ graph, center, r, All,
        Sequence @@ FilterRules[ { opts }, Options[ FindInfraShell ] ] ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Center" -> center,
                "Radius" -> If[ NumericQ[ r ], r, Mean[ r ] ] |> ],
    extractBranches[ { opts } ] ]
