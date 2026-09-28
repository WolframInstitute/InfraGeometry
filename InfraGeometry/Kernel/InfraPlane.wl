Package["WolframInstitute`InfraGeometry`"]


(* ===================== FindInfraBisectingHyperplane ===================== *)

(* the bisector slab B = { v : lo <= d(p1, v) - d(p2, v) <= hi }, a sorted vertex list; under Properties the minimal admissible subsets of the slab, one per instance.  On a non-bipartite graph the strict equidistant set may fail to separate, so widen the window to {-1, 1} to recover the parity-stranded band. *)

FindInfraBisectingHyperplane::badmethod   = "Method `1` is not supported by FindInfraBisectingHyperplane.";
FindInfraBisectingHyperplane::badproperty = "Property `1` is not supported by FindInfraBisectingHyperplane.";

Options[ FindInfraBisectingHyperplane ] = {
  Properties -> { },
  Method     -> Automatic
};

FindInfraBisectingHyperplane[ graph_Graph, p1_, p2_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  FindInfraBisectingHyperplane[ graph, p1, p2, { 0, 0 }, count, opts ]

FindInfraBisectingHyperplane[ graph_Graph, p1_, p2_,
    window : { _Integer, _Integer },
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] :=
  With[ {
      properties = OptionValue[ FindInfraBisectingHyperplane, { opts }, Properties ],
      methodSpec = Replace[ OptionValue[ FindInfraBisectingHyperplane, { opts }, Method ], Automatic :> If[ count === All, "Exhaustive", "Greedy" ] ] },
    { methodHead = Replace[ methodSpec, { m_String, ___ } :> m ],
      pruning    = Replace[ methodSpec, { { "Exhaustive", subs___ } :> ( "Pruning" /. { subs } /. "Pruning" -> Infinity ), _ :> Infinity } ] },
    { results = Apply[
        { q1, q2 } |-> With[ {
            bisector = Complement[
              Pick[ VertexList[ graph ],
                MapThread[ { x, y } |-> window[[1]] <= x - y <= window[[2]],
                  { GraphDistance[ graph, q1 ], GraphDistance[ graph, q2 ] } ] ],
              { q1, q2 } ] },
          If[ properties === { },
            { bisector },
            Catch @ With[
              (* aux graph on bisector + {q1, q2}: direct edges plus pairs joined through components of the complement *)
              { aux = With[ { nodes = Union[ bisector, { q1, q2 } ] },
                  { components = ConnectedComponents @ Subgraph[ graph,
                      Complement[ VertexList[ graph ], nodes ] ] },
                  { paired = Flatten[
                      ( comp |-> UndirectedEdge @@@ Subsets[
                          Intersection[ nodes, Union @@ ( AdjacencyList[ graph, # ] & /@ comp ) ],
                          { 2 } ] ) /@ components, 1 ],
                    direct = Cases[ EdgeList[ graph ],
                      ( UndirectedEdge | DirectedEdge )[ u_, v_ ] /;
                        MemberQ[ nodes, u ] && MemberQ[ nodes, v ] :> UndirectedEdge[ u, v ] ] },
                  Graph[ nodes, DeleteDuplicates[ Join[ paired, direct ] ] ] ] },
              { tests = Map[
                  property |-> Switch[ property,
                    "Separating", T |-> SeparatesQ[ aux, T, q1, q2 ],
                    "Connected",  T |-> T =!= { } && ConnectedGraphQ @ Subgraph[ graph, T ],
                    _,            Message[ FindInfraBisectingHyperplane::badproperty, property ]; Throw[ $Failed ] ],
                  properties ] },
              { admissible = T |-> AllTrue[ tests, # @ T & ] },
              (* admissible and the branch are held in Module locals, not inlined into descend's RHS: a closure's own parameter would be rewritten by a pattern variable of the same name on substitution *)
              Module[ { admitQ = admissible, pick = If[ methodHead === "Greedy", Identity, RandomSample ],
                        cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
                        acc = { }, seen = <||>, descend, frontier, next, removable, key },
                Switch[ methodHead,
                  (* breadth-first over the peel DAG with Sort @ T the canonical key; the pruning is a beam width or a Bernoulli keep probability with a one-element floor *)
                  "Exhaustive",
                    If[ ! admitQ[ bisector ], { },
                      frontier = { Sort @ bisector };
                      seen = <| Sort @ bisector -> True |>;
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
                    If[ ! admitQ[ bisector ], { },
                      descend[ T_ ] :=
                        If[ ! KeyExistsQ[ seen, T ],
                          seen[ T ] = True;
                          With[ { peelable = Select[ T, w |-> admitQ[ DeleteCases[ T, w ] ] ] },
                            If[ peelable === { },
                              AppendTo[ acc, T ];
                              If[ Length @ acc >= cap, Throw[ acc, descend ] ],
                              Scan[ descend[ DeleteCases[ T, # ] ] &, pick @ peelable ] ] ] ];
                      Catch[ descend[ bisector ]; acc, descend ] ],
                  _,
                    Message[ FindInfraBisectingHyperplane::badmethod, methodSpec ]; $Failed ] ] ] ] ],
        Tuples[ { Keys @ InfraDensity[ graph, p1 ], Keys @ InfraDensity[ graph, p2 ] } ], { 1 } ] },
    If[ MemberQ[ results, $Failed ], $Failed,
      With[ { reps = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          Automatic, First[ reps, { } ],
          All,       reps,
          _UpTo,     Take[ reps, count ],
          _,         If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ] ] ]


(* ===================== InfraPlaneQ ===================== *)

(* h sits inside the bisector slab and separates p1 from p2; the three-argument form is the inert scene assertion *)

InfraPlaneQ[ graph_Graph, fam_Association, p1_, p2_, window_ : 0 ] :=
  InfraPlaneQ[ graph, Keys @ fam, p1, p2, window ]

InfraPlaneQ[ graph_Graph, sets : { __List }, p1_, p2_, window_ : 0 ] /; ! AllTrue[ sets, VertexQ[ graph, # ] & ] :=
  AllTrue[ sets, InfraPlaneQ[ graph, #, p1, p2, window ] & ]

InfraPlaneQ[ graph_Graph, h_List, p1_, p2_, window_ : 0 ] :=
  With[ { bounds = If[ ListQ @ window, window, { -window, window } ] },
    SeparatesQ[ graph, h, p1, p2 ] &&
    AllTrue[ h,
      bounds[[ 1 ]] <= GraphDistance[ graph, p1, # ] - GraphDistance[ graph, p2, # ] <= bounds[[ 2 ]] & ]
  ]


(* ===================== Scene-DSL constructor ===================== *)

dispatchConstruction[ graph_Graph, InfraPlane[ p1_, p2_, opts___Rule ] ] :=
  dispatchConstruction[ graph, InfraPlane[ p1, p2, { 0, 0 }, opts ] ]

dispatchConstruction[ graph_Graph, InfraPlane[ p1_, p2_,
    window : { _Integer, _Integer }, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      FindInfraBisectingHyperplane[ graph, p1, p2, window, All, Properties -> { "Separating" } ],
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Endpoints" -> { p1, p2 } |> ],
    extractBranches[ { opts } ] ]
