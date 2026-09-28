Package["WolframInstitute`InfraGeometry`"]


(* ===================== FindInfraEllipticShell ===================== *)

(* the level set { v : cMin <= d(p1, v) + d(p2, v) <= cMax }, a sorted vertex list; under Properties its minimal admissible subsets, one per instance *)

FindInfraEllipticShell::badmethod   = "Method `1` is not supported by FindInfraEllipticShell.";
FindInfraEllipticShell::badproperty = "Property `1` is not supported by FindInfraEllipticShell.";

Options[ FindInfraEllipticShell ] = {
  Properties -> { },
  Method     -> Automatic
};

FindInfraEllipticShell[ graph_Graph, foci : { _, _ }, c_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
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
            Catch @ With[
              { nearVerts = Pick[ verts, Thread[ sums < range[[ 1 ]] ] ],
                farVerts  = Pick[ verts, Thread[ sums > range[[ 2 ]] ] ] },
              { tests = Map[
                  property |-> Switch[ property,
                    "Separating", t |-> nearVerts =!= { } && farVerts =!= { } &&
                                    SeparatesQ[ graph, t, First @ nearVerts, First @ farVerts ],
                    "Connected",  t |-> t =!= { } && ConnectedGraphQ @ Subgraph[ graph, t ],
                    _,            Message[ FindInfraEllipticShell::badproperty, property ]; Throw[ $Failed ] ],
                  properties ] },
              { admissible = t |-> AllTrue[ tests, # @ t & ] },
              (* admissible and the branch are held in Module locals, not inlined into descend's RHS: a closure's own parameter would be rewritten by a pattern variable of the same name on substitution *)
              Module[ { admitQ = admissible, pick = If[ methodHead === "Greedy", Identity, RandomSample ],
                        cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
                        acc = { }, seen = <||>, descend, frontier, next, removable, key },
                Switch[ methodHead,
                  (* breadth-first over the peel DAG with Sort @ T the canonical key; the pruning is a beam width or a Bernoulli keep probability with a one-element floor *)
                  "Exhaustive",
                    If[ ! admitQ[ levelSet ], { },
                      frontier = { Sort @ levelSet };
                      seen = <| Sort @ levelSet -> True |>;
                      While[ frontier =!= { },
                        next = { };
                        Do[
                          removable = Select[ T, v |-> admitQ[ DeleteCases[ T, v ] ] ];
                          If[ removable === { },
                            AppendTo[ acc, T ],
                            Do[
                              key = Sort @ DeleteCases[ T, v ];
                              If[ ! KeyExistsQ[ seen, key ],
                                seen[ key ] = True;
                                AppendTo[ next, key ] ],
                              { v, Replace[ pruning, {
                                  Infinity     :> removable,
                                  n_Integer    :> If[ Length @ removable <= n, removable, RandomSample[ removable, n ] ],
                                  p_?NumericQ  :> With[ { kept = Select[ removable, RandomReal[ ] < p & ] },
                                    If[ kept === { }, RandomSample[ removable, 1 ], kept ] ] } ] } ] ],
                          { T, frontier } ];
                        frontier = next ];
                      DeleteDuplicates @ acc ],
                  (* DeleteCases keeps the order of the set, so every state is canonical and is its own visited key *)
                  "Greedy" | "RandomGreedy",
                    If[ ! admitQ[ levelSet ], { },
                      descend[ T_ ] :=
                        If[ ! KeyExistsQ[ seen, T ],
                          seen[ T ] = True;
                          With[ { peelable = Select[ T, w |-> admitQ[ DeleteCases[ T, w ] ] ] },
                            If[ peelable === { },
                              AppendTo[ acc, T ];
                              If[ Length @ acc >= cap, Throw[ acc, descend ] ],
                              Scan[ descend[ DeleteCases[ T, # ] ] &, pick @ peelable ] ] ] ];
                      Catch[ descend[ levelSet ]; acc, descend ] ],
                  _,
                    Message[ FindInfraEllipticShell::badmethod, methodSpec ]; $Failed ] ] ] ] ],
        Tuples[ { { foci }, Replace[ c, { fam_Association :> Keys @ fam, other_ :> { other } } ] } ], { 1 } ] },
    If[ MemberQ[ results, $Failed ], $Failed,
      With[ { reps = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          Automatic, First[ reps, { } ],
          All,       reps,
          _UpTo,     Take[ reps, count ],
          _,         If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ] ] ]


(* ===================== InfraEllipticShellQ ===================== *)

(* vs is an elliptic shell iff there are foci p1, p2 and a constant c with vs == { v : d(p1, v) + d(p2, v) == c } *)

InfraEllipticShellQ[ graph_Graph, fam_Association ] := InfraEllipticShellQ[ graph, Keys @ fam ]

InfraEllipticShellQ[ graph_Graph, sets : { __List } ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraEllipticShellQ[ graph, # ] & ]

InfraEllipticShellQ[ graph_Graph, vs_List ] :=
  Module[ { verts, idx, dm },
    verts = VertexList[ graph ];
    idx   = AssociationThread[ verts, Range @ Length @ verts ];
    dm    = GraphDistanceMatrix[ graph ];
    AnyTrue[ Subsets[ verts, { 2 } ], fociPair |->
      With[ { sums = dm[[ idx @ fociPair[[ 1 ]] ]] + dm[[ idx @ fociPair[[ 2 ]] ]] },
        { c = sums[[ idx @ First @ vs ]] },
        Sort[ vs ] === Sort @ Pick[ verts, Thread[ sums == c ] ]
      ]
    ]
  ]
