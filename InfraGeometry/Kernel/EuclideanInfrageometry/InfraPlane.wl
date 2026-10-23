Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RandomInfraPlane ] = { Properties -> { "Separating" }, "NextVertexFunction" -> Automatic, RandomSeeding -> Automatic }

RandomInfraPlane[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraPlane[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraPlane[ ___, RandomSeeding -> None ] ] ] ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraPlane *)

(* the bisector slab B = { v : lo <= d(p1, v) - d(p2, v) <= hi }, a sorted vertex list; {"Separating"} gives the minimal subsets of B - {p1, p2}
   that separate p1 from p2, {"Separating", "Connected"} the walls: the connected separating subsets with no proper connected separating subset.
   On a non-bipartite graph the strict equidistant set may fail to separate, so widen the window to {-1, 1} to recover the parity-stranded band. *)

Options[ FindInfraBisectingHyperplane ] = {
  Properties           -> { },
  "NextVertexFunction" -> Identity
}

FindInfraBisectingHyperplane[ graph_Graph, p1_, p2_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ]/;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ FindInfraBisectingHyperplane, { opts }, Properties ] ] :=
  FindInfraBisectingHyperplane[ graph, p1, p2, { 0, 0 }, count, opts ]

FindInfraBisectingHyperplane[ graph_Graph, p1_, p2_,
    window : { _Integer, _Integer },
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
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
              (* the minimal q1-q2 separators S of aux, generated from the one nearest q1 by S -> N(C(S) + x) cut down to the neighbours
                 of the component of q2, for x in S, C(S) the component of q1 in aux - S (Berry, Bordat, Cogis 1999) *)
              { labels = VertexList[ aux ], adjacency = AdjacencyMatrix[ aux ],
                source = VertexIndex[ aux, q1 ], target = VertexIndex[ aux, q2 ] },
              { size = Length[ labels ], neighbours = Sort /@ adjacency[ "AdjacencyLists" ] },
              { indicator = set |-> Normal @ SparseArray[ Thread[ List /@ set -> 1 ], { size } ] },
              (* a component by sparse products: 1.7 s for the 3885 planes of a mesh slab {-1, 1} where VertexDelete + VertexComponent took 13.7 s *)
              { component = { open, seed } |-> FixedPoint[ reach |-> open Unitize[ reach + adjacency . reach ], open UnitVector[ size, seed ] ] },
              { nearest = { blocked, candidates } |-> With[ { far = component[ 1 - Unitize[ blocked ], target ] },
                  Pick[ candidates, Unitize[ ( adjacency . far )[[ candidates ]] ], 1 ] ] },
              { successors = separator |-> With[ { cut = indicator[ separator ] }, { side = component[ 1 - cut, source ] },
                  Map[ x |-> nearest[ side + cut + indicator[ neighbours[[ x ]] ],
                      Union[ DeleteCases[ separator, x ], Pick[ neighbours[[ x ]], ( side + cut )[[ neighbours[[ x ]] ]], 0 ] ] ],
                    Select[ separator, x |-> adjacency[[ x, target ]] == 0 ] ] ] },
              { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
              Which[
                ! MemberQ[ properties, "Separating" ],
                  If[ bisector =!= { } && ConnectedGraphQ @ Subgraph[ graph, bisector ], List /@ bisector, { } ],
                q1 === q2 || adjacency[[ source, target ]] == 1, { },
                MemberQ[ properties, "Connected" ],
                  With[ { vertices = VertexList[ graph ], symmetric = Sign[ AdjacencyMatrix[ graph ] + Transpose @ AdjacencyMatrix[ graph ] ] },
                    { order = Length[ vertices ], index = AssociationThread[ vertices, Range @ Length @ vertices ] },
                    { mark = set |-> Normal @ SparseArray[ Thread[ List /@ set -> 1 ], { order } ] },
                    { reach = { open, seeds } |-> FixedPoint[ front |-> open Unitize[ front + symmetric . front ], open mark[ seeds ] ] },
                    { separatesQ = set |-> reach[ 1 - mark[ set ], { index[ q1 ] } ][[ index[ q2 ] ]] == 0 },
                    (* v can leave a wall candidate W iff W - v is connected (v is no cut vertex of W) and v does not join the sides of q1 and q2 *)
                    { removable = set |-> With[ { open = 1 - mark[ set ] },
                        { joins = Unitize[ symmetric . reach[ open, { index[ q1 ] } ] ] Unitize[ symmetric . reach[ open, { index[ q2 ] } ] ],
                          cuts = set[[ Select[ Tally @ Catenate @ KVertexConnectedComponents[ AdjacencyGraph[ symmetric[[ set, set ]] ], 2 ],
                            Last @ # > 1 & ][[ All, 1 ]] ]] },
                        Select[ set, v |-> joins[[ v ]] == 0 && ! MemberQ[ cuts, v ] ] ] },
                    { pick = list |-> First[ Replace[ nextFn @ list, chosen_ /; MemberQ[ list, Verbatim @ chosen ] :> { chosen } ], First @ list ] },
                    { roots = Select[ Map[ part |-> Sort @ Lookup[ index, part ], ConnectedComponents @ Subgraph[ graph, bisector ] ], separatesQ ] },
                    (* a depth-first peel from the separating components of the slab: each descent deletes removable vertices chosen by nextFn
                       until none is left, skipping the sets all of whose walls were found, and starts again at the slab after each wall *)
                    Map[ set |-> Sort @ vertices[[ set ]],
                      If[ separatesQ[ { } ], { { } },
                        Lookup[ NestWhile[
                          state |-> If[ state[ "path" ] === { },
                            With[ { live = Select[ roots, root |-> ! KeyExistsQ[ state[ "exhausted" ], root ] ] },
                              If[ live === { }, Append[ state, "done" -> True ], Append[ state, "path" -> { pick @ live } ] ] ],
                            With[ { node = Last @ state[ "path" ] },
                              { free = Lookup[ state[ "removable" ], Key @ node, removable @ node ] },
                              { memo = Append[ state, "removable" -> Append[ state[ "removable" ], node -> free ] ] },
                              { live = Select[ free, v |-> ! KeyExistsQ[ state[ "exhausted" ], DeleteCases[ node, v ] ] ] },
                              Which[
                                free === { },
                                  Join[ memo, <| "walls" -> Append[ state[ "walls" ], node ],
                                    "exhausted" -> Append[ state[ "exhausted" ], node -> True ], "path" -> { } |> ],
                                live === { },
                                  Join[ memo, <| "exhausted" -> Append[ state[ "exhausted" ], node -> True ], "path" -> Most @ state[ "path" ] |> ],
                                True,
                                  Append[ memo, "path" -> Append[ state[ "path" ], DeleteCases[ node, pick @ live ] ] ] ] ] ],
                          <| "walls" -> { }, "exhausted" -> <| |>, "removable" -> <| |>, "path" -> { }, "done" -> False |>,
                          state |-> ! state[ "done" ] && Length @ state[ "walls" ] < cap ], "walls" ] ] ] ],
                True,
                  With[ { planes = Sort @ With[ { start = nearest[ indicator[ Append[ neighbours[[ source ]], source ] ], neighbours[[ source ]] ] },
                      Map[ set |-> Sort @ labels[[ set ]], Keys @ First @ NestWhile[
                        state |-> With[ { seen = First @ state },
                          { next = Select[ DeleteDuplicates @ Catenate @ Map[ successors, Last @ state ], set |-> ! KeyExistsQ[ seen, set ] ] },
                          { Join[ seen, AssociationThread[ next, True ] ], next } ],
                        { <| start -> True |>, { start } }, Last @ # =!= { } & ] ] ] },
                    If[ planes === { }, { },
                      Take[ Replace[ nextFn @ planes, chosen_ /; MemberQ[ planes, Verbatim @ chosen ] :> { chosen } ],
                        UpTo[ Min[ cap, Length @ planes ] ] ] ] ] ] ] ] ],
        Tuples[ { Keys @ InfraMeasurement[ graph, p1, "VertexDensity" ], Keys @ InfraMeasurement[ graph, p2, "VertexDensity" ] } ], { 1 } ] },
    With[ { reps = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
        Switch[ count,
          Automatic, First[ reps, { } ],
          All,       Sort @ reps,
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

RandomInfraPlane[ graph_Graph, InfraPlane[ p1_, p2_, opts___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, samplerOpts : OptionsPattern[] ] /; MemberQ[ Flatten @ { samplerOpts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraPlane ], First /@ { samplerOpts } ] ) :=
  RandomInfraPlane[ graph, InfraPlane[ p1, p2, { 0, 0 }, opts ], count, samplerOpts ]

RandomInfraPlane[ graph_Graph, InfraPlane[ p1_, p2_, window : { _Integer, _Integer }, opts___Rule ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, samplerOpts : OptionsPattern[] ] /; MemberQ[ Flatten @ { samplerOpts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraPlane ], First /@ { samplerOpts } ] &&
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ RandomInfraPlane, { samplerOpts }, Properties ] ] &&
    ( OptionValue[ RandomInfraPlane, { samplerOpts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) ) :=
  With[ { nextFn = OptionValue[ RandomInfraPlane, { samplerOpts }, "NextVertexFunction" ] },
    FindInfraBisectingHyperplane[ graph, p1, p2, window, count,
      "NextVertexFunction" -> If[ nextFn === Automatic, If[ count === All, Identity, RandomSample ], nextFn ],
      Properties -> OptionValue[ RandomInfraPlane, { samplerOpts }, Properties ] ] ]

RandomInfraPlane[ graph_Graph, p_, q_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ! MatchQ[ First @ { p, q }, _InfraPlane ] &&
    SubsetQ[ First /@ Options[ RandomInfraPlane ], First /@ { opts } ] ) :=
  RandomInfraPlane[ graph, InfraPlane[ p, q ], count,
    Properties -> OptionValue[ Properties ], "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ], RandomSeeding -> None ]

RandomInfraPlane[ graph_Graph, p_, q_, window : { _Integer, _Integer },
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ! MatchQ[ First @ { p, q, window }, _InfraPlane ] &&
    SubsetQ[ First /@ Options[ RandomInfraPlane ], First /@ { opts } ] ) :=
  RandomInfraPlane[ graph, InfraPlane[ p, q, window ], count,
    Properties -> OptionValue[ Properties ], "NextVertexFunction" -> OptionValue[ "NextVertexFunction" ], RandomSeeding -> None ]
