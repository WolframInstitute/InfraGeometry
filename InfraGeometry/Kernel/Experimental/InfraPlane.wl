Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: Experimental :: InfraPlane *)

(* the bisector slab B = { v : lo <= d(p1, v) - d(p2, v) <= hi }, a sorted vertex list; under Properties the minimal admissible subsets of the slab,
   one per instance.  On a non-bipartite graph the strict equidistant set may fail to separate, so widen the window to {-1, 1} to recover the
   parity-stranded band. *)

Options[ FindInfraBisectingHyperplane ] = {
  Properties           -> { },
  "NextVertexFunction" -> Identity
}

FindInfraBisectingHyperplane[ graph_Graph, p1_, p2_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ]/;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraBisectingHyperplane, { opts }, Properties ] ] :=
  FindInfraBisectingHyperplane[ graph, p1, p2, { 0, 0 }, count, opts ]

FindInfraBisectingHyperplane[ graph_Graph, p1_, p2_,
    window : { _Integer, _Integer },
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraBisectingHyperplane, { opts }, Properties ] ] :=
  With[ {
      properties = OptionValue[ FindInfraBisectingHyperplane, { opts }, Properties ],
      nextFn     = OptionValue[ FindInfraBisectingHyperplane, { opts }, "NextVertexFunction" ] },
    { results = Apply[
        { q1, q2 } |-> With[ {
            bisector = Complement[
              Pick[ VertexList[ graph ],
                MapThread[ { x, y } |-> window[[ 1 ]] <= x - y <= window[[ 2 ]],
                  { GraphDistance[ graph, q1 ], GraphDistance[ graph, q2 ] } ] ],
              { q1, q2 } ] },
          If[ properties === { },
            { bisector },
            With[
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
                    "Connected",  T |-> T =!= { } && ConnectedGraphQ @ Subgraph[ graph, T ] ],
                  properties ] },
              { admissible = T |-> AllTrue[ tests, # @ T & ] },
              { pick = cands |-> Replace[ nextFn @ cands, chosen_ /; MemberQ[ cands, Verbatim @ chosen ] :> { chosen } ],
                cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
              { descend = { self, state, T } |-> If[ Length @ First @ state >= cap || KeyExistsQ[ Last @ state, T ],
                  state,
                  With[ { marked = { First @ state, Append[ Last @ state, T -> True ] },
                          peelable = Select[ T, w |-> admissible[ DeleteCases[ T, w ] ] ] },
                    If[ peelable === { },
                      { Append[ First @ marked, T ], Last @ marked },
                      Fold[ { s, w } |-> self[ self, s, DeleteCases[ T, w ] ], marked, pick @ peelable ] ] ] ] },
              If[ ! admissible[ bisector ], { }, First @ descend[ descend, { { }, <| |> }, bisector ] ] ] ] ],
        Tuples[ { Keys @ InfraDensity[ graph, p1 ], Keys @ InfraDensity[ graph, p2 ] } ], { 1 } ] },
    With[ { reps = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          Automatic, First[ reps, { } ],
          All,       reps,
          _UpTo,     Take[ reps, count ],
          _,         If[ Length @ reps < count, { }, Take[ reps, count ] ] ] ] ]

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

RandomInfraRepresentative[ graph_Graph, InfraPlane[ p1_, p2_, opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, samplerOpts : OptionsPattern[] ] :=
  RandomInfraRepresentative[ graph, InfraPlane[ p1, p2, { 0, 0 }, opts ], count, samplerOpts ]

RandomInfraRepresentative[ graph_Graph, InfraPlane[ p1_, p2_, window : { _Integer, _Integer }, opts___Rule ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, samplerOpts : OptionsPattern[] ] /;
    ( OptionValue[ RandomInfraRepresentative, { samplerOpts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  With[ { nextFn = OptionValue[ RandomInfraRepresentative, { samplerOpts }, "NextVertexFunction" ] },
    FindInfraBisectingHyperplane[ graph, p1, p2, window, count,
      "NextVertexFunction" -> If[ nextFn === Automatic, If[ count === All, Identity, RandomSample ], nextFn ],
      Properties -> { "Separating" } ] ]
