Package["WolframInstitute`InfraGeometry`"]

(* the level set { v : cMin <= d(p1, v) + d(p2, v) <= cMax }, a sorted vertex list; under Properties its minimal admissible subsets, one per instance *)

Options[ FindInfraEllipticShell ] = {
  Properties -> { },
  Method     -> Automatic
};

FindInfraEllipticShell[ graph_Graph, foci : { _, _ }, c_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraEllipticShell, { opts }, Properties ] ] &&
      MatchQ[ OptionValue[ FindInfraEllipticShell, { opts }, Method ],
        Automatic | "Exhaustive" | "Greedy" | "RandomGreedy" | { "Exhaustive" | "Greedy" | "RandomGreedy", ___ } ] :=
  With[ {
      properties = OptionValue[ FindInfraEllipticShell, { opts }, Properties ],
      methodSpec = Replace[ OptionValue[ FindInfraEllipticShell, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] },
    { methodHead = Replace[ methodSpec, { m_String, ___ } :> m ],
      pruning    = Replace[ methodSpec,
                    { { "Exhaustive", subs___ } :> ( "Pruning" /. { subs } /. "Pruning" -> Infinity ),
                      _ :> Infinity } ] },
    { results = Apply[
        { foci0, c0 } |-> With[ {
            range = Replace[ c0, d_?NumericQ :> { d, d } ],
            verts = VertexList[ graph ],
            dm    = GraphDistanceMatrix[ graph ] },
          { idx = AssociationThread[ verts, Range @ Length @ verts ] },
          { sums = dm[[ idx @ foci0[[ 1 ]] ]] + dm[[ idx @ foci0[[ 2 ]] ]] },
          { levelSet = Pick[ verts, Thread[ range[[ 1 ]] <= sums <= range[[ 2 ]] ] ] },
          If[ properties === { },
            { levelSet },
            With[
              { nearVerts = Pick[ verts, Thread[ sums < range[[ 1 ]] ] ],
                farVerts  = Pick[ verts, Thread[ sums > range[[ 2 ]] ] ] },
              { tests = Map[
                  property |-> Switch[ property,
                    "Separating", t |-> nearVerts =!= { } && farVerts =!= { } &&
                                    SeparatesQ[ graph, t, First @ nearVerts, First @ farVerts ],
                    "Connected",  t |-> t =!= { } && ConnectedGraphQ @ Subgraph[ graph, t ] ],
                  properties ] },
              { admissible = t |-> AllTrue[ tests, # @ t & ] },
              { pick = If[ methodHead === "Greedy", Identity, RandomSample ],
                cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
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
                            { { }, Map[ v |-> Sort @ DeleteCases[ T, v ], Replace[ pruning, {
                                Infinity     :> removable,
                                n_Integer    :> If[ Length @ removable <= n, removable, RandomSample[ removable, n ] ],
                                p_?NumericQ  :> With[ { kept = Select[ removable, RandomReal[ ] < p & ] },
                                  If[ kept === { }, RandomSample[ removable, 1 ], kept ] ] } ] ] } ] ],
                        First @ state ] },
                      { DeleteDuplicates @ Catenate @ rows[[ All, 2 ]], Join[ Last @ state, Catenate @ rows[[ All, 1 ]] ] } ],
                    { { Sort @ levelSet }, { } },
                    First @ # =!= { } & ],
                True,
                  First @ descend[ descend, { { }, <||> }, levelSet ] ] ] ] ],
        Tuples[ { { foci }, Replace[ c, { fam_Association :> Keys @ fam, other_ :> { other } } ] } ], { 1 } ] },
    With[ { reps = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          Automatic, First[ reps, { } ],
          All,       reps,
          _UpTo,     Take[ reps, count ],
          _,         If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ] ]

(* vs is an elliptic shell iff there are foci p1, p2 and a constant c with vs == { v : d(p1, v) + d(p2, v) == c } *)

InfraEllipticShellQ[ graph_Graph, fam_Association ] := InfraEllipticShellQ[ graph, Keys @ fam ]

InfraEllipticShellQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraEllipticShellQ[ graph, # ] & ]

InfraEllipticShellQ[ graph_Graph, vs_List ] :=
  With[ { verts = VertexList[ graph ], dm = GraphDistanceMatrix[ graph ] },
    { idx = AssociationThread[ verts, Range @ Length @ verts ] },
    AnyTrue[ Subsets[ verts, { 2 } ], fociPair |->
      With[ { sums = dm[[ idx @ fociPair[[ 1 ]] ]] + dm[[ idx @ fociPair[[ 2 ]] ]] },
        { c = sums[[ idx @ First @ vs ]] },
        Sort[ vs ] === Sort @ Pick[ verts, Thread[ sums == c ] ] ] ] ]
