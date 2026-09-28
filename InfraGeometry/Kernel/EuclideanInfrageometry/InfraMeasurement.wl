Package["WolframInstitute`InfraGeometry`"]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraMeasurement *)


(* ===================== InfraMeasurement ===================== *)

(* the measurements of a Euclidean head, every one of them read off its graph, whose chains are the members: with alpha the forward and beta the backward chain count of the DAG, the number of members is the total of alpha over the sinks, the number through v is alpha(v) beta(v) and the number through v -> w is alpha(v) beta(w) (design Prop. count).  Over a List of graphs the counts add, because such a List is a List of alternatives -- two exceptions, the polylines InfraSegment[p1, ..., pk] and InfraArc[c, {p1, ..., pk}], whose Lists are the pieces of one member and whose own clauses multiply instead; they are excluded here by pattern, since a conditioned first argument and a head-shaped one cannot be ordered by specificity.  InfraCircle is excluded the same way from the three measurements that read a member as open: its necklaces are alternatives, but its members close over the arrow that opening a necklace left out.  The support of an object is the keys of its vertex density, which is what every volume and the subgraph read *)

InfraMeasurement[ graph_Graph, objs : { __ }, spec_ ] := InfraMeasurement[ graph, #, spec ] & /@ objs

InfraMeasurement[ graph_Graph, obj : Except[ _List ], props : { __String } ] :=
  AssociationMap[ InfraMeasurement[ graph, obj, # ] &, props ]

InfraMeasurement[ graph_Graph, obj : Except[ _List | InfraIntersection[ __ ] | InfraUnion[ __ ] ], All ] :=
  InfraMeasurement[ graph, obj,
    { "Graph", "Faithful", "Cardinality", "Length", "VertexDensity", "EdgeDensity", "Subgraph",
      "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" } ]


InfraMeasurement[ _Graph, ( InfraSegment | InfraRay | InfraLine )[ __ ], "Faithful" ] := True

InfraMeasurement[ _Graph, ( InfraCircle | InfraArc )[ __ ], "Faithful" ] := Undetermined


InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] ], "Cardinality" ] :=
  Total @ Map[
    dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ] },
      { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
              { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ],
          <| |>, TopologicalSort @ dag ] },
      Total @ Lookup[ alpha, Key /@ Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] ] ],
    Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ]


InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraIntersection[ __ ] | InfraUnion[ __ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] ], "VertexDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        AssociationMap[ Lookup[ alpha, Key @ # ] Lookup[ beta, Key @ # ] &, VertexList @ dag ] ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    Total ]


InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraCircle[ _, _, ___ ] |
                  InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] ], "EdgeDensity" ] :=
  KeySort @ Merge[
    Map[
      dag |-> With[ { inNbr = GroupBy[ EdgeList @ dag, Last -> First ],
                      outNbr = GroupBy[ EdgeList @ dag, First -> Last ],
                      order = TopologicalSort @ dag },
        { alpha = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ inNbr, Key @ w, { } ],
                { { } -> 1, ps_ :> Total @ Lookup[ a, Key /@ ps ] } ] ], <| |>, order ],
          beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ outNbr, Key @ w, { } ],
                { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ], <| |>, Reverse @ order ] },
        Association[ # -> Lookup[ alpha, Key @ First @ # ] Lookup[ beta, Key @ Last @ # ] & /@ EdgeList @ dag ] ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    Total ]


InfraMeasurement[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] |
                  InfraCircle[ _, _, ___ ] ], "Length" ] :=
  Replace[
    Union @@ Map[
      dag |-> DeleteCases[ Infinity ] @ Union @ Flatten @ Table[ GraphDistance[ dag, s, t ],
          { s, Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] },
          { t, Pick[ VertexList @ dag, VertexOutDegree @ dag, 0 ] } ],
      Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ] ],
    { one_ } :> one ]


InfraMeasurement[ graph_Graph, obj : Except[ _List ], "Subgraph" ] :=
  Subgraph[ graph, Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] ]


InfraMeasurement[ graph_Graph, obj : Except[ _List ], "Volume" ] :=
  Length @ InfraMeasurement[ graph, obj, "VertexDensity" ]


(* the vertices of the support with a neighbour outside it *)
InfraMeasurement[ graph_Graph, obj : Except[ _List ], "BoundaryVolume" ] :=
  With[ { support = Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ] },
    { inside = AssociationThread[ support, True ] },
    Count[ support, v_ /; AnyTrue[ AdjacencyList[ graph, v ], ! TrueQ @ Lookup[ inside, Key @ # ] & ] ] ]


InfraMeasurement[ graph_Graph, obj : Except[ _List ], "InteriorVolume" ] :=
  InfraMeasurement[ graph, obj, "Volume" ] - InfraMeasurement[ graph, obj, "BoundaryVolume" ]


(* the Ehrhart-corrected count |S| - |dS| / 2 *)
InfraMeasurement[ graph_Graph, obj : Except[ _List ], "HalfBoundaryVolume" ] :=
  InfraMeasurement[ graph, obj, "Volume" ] - InfraMeasurement[ graph, obj, "BoundaryVolume" ] / 2


(* ===================== InfraVertexList ===================== *)

(* the members of a head, each as a vertex list: a walk on its graph from a source to a sink, in lexicographic order under a count, drawn with probability beta(w) / beta(v) at each arrow under "RandomChoice" -- so every member is drawn with probability 1 / N (design Proposal uniform) -- and thinned by a random fraction q of the candidates at each step under "Pruning" -> q *)

InfraVertexList[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, mods___ ] :=
  Module[ { acc = { }, descend, draw },
    With[ {
        cap     = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ],
        prune   = Lookup[ Association @ Cases[ { mods }, _Rule ], "Pruning", 0 ],
        randomQ = MemberQ[ { mods }, "RandomChoice" ],
        dags    = Select[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ], VertexCount[ # ] > 0 & ] },
      { engines = Map[
          dag |-> With[ { out = GroupBy[ List @@@ EdgeList @ dag, First -> Last ] },
            { beta = Fold[ { a, w } |-> Append[ a, w -> Replace[ Lookup[ out, Key @ w, { } ],
                    { { } -> 1, qs_ :> Total @ Lookup[ a, Key /@ qs ] } ] ],
                <| |>, Reverse @ TopologicalSort @ dag ] },
            { out, beta, Sort @ Pick[ VertexList @ dag, VertexInDegree @ dag, 0 ] } ],
          dags ] },
      descend[ out_, path_ ] := With[ { nexts = Sort @ Lookup[ out, Key @ Last @ path, { } ] },
        If[ nexts === { },
          AppendTo[ acc, path ]; If[ Length @ acc >= cap, Throw[ Null, descend ] ],
          Scan[ descend[ out, Append[ path, # ] ] &,
            If[ prune > 0, Select[ nexts, RandomReal[ ] >= prune & ], nexts ] ] ] ];
      draw[ { out_, beta_, sources_ } ] :=
        NestWhile[
          path |-> With[ { nexts = Lookup[ out, Key @ Last @ path, { } ] },
            Append[ path, RandomChoice[ Lookup[ beta, Key /@ nexts ] -> nexts ] ] ],
          { RandomChoice[ Lookup[ beta, Key /@ sources ] -> sources ] },
          path |-> Lookup[ out, Key @ Last @ path, { } ] =!= { } ];
      With[ { members = If[ randomQ && cap < Infinity && engines =!= { },
            Table[ draw @ RandomChoice[ ( Total @ Lookup[ #[[ 2 ]], Key /@ #[[ 3 ]] ] & /@ engines ) -> engines ], cap ],
            Catch[ Scan[ e |-> Scan[ descend[ e[[ 1 ]], { # } ] &, e[[ 3 ]] ], engines ]; Null, descend ]; acc ] },
        Switch[ count,
          Automatic, First[ members, { } ],
          All,       members,
          _UpTo,     Take[ members, count ],
          _,         If[ Length @ members < count, $Failed, Take[ members, count ] ] ] ] ] ]


(* ===================== InfraMemberQ ===================== *)

(* a vertex list is a member when it is a source-to-sink chain of one of the object's graphs *)

InfraMemberQ[ graph_Graph,
    obj : Except[ _List | InfraSegment[ _, _, __ ] | InfraArc[ _, { _, _, __ }, ___ ] |
                  InfraCircle[ _, _, ___ ] ], path_List ] :=
  path =!= { } &&
  AnyTrue[ Replace[ InfraMeasurement[ graph, obj, "Graph" ], dag_Graph :> { dag } ],
    dag |-> VertexQ[ dag, First @ path ] && VertexInDegree[ dag, First @ path ] == 0 &&
      VertexQ[ dag, Last @ path ] && VertexOutDegree[ dag, Last @ path ] == 0 &&
      AllTrue[ Partition[ path, 2, 1 ], EdgeQ[ dag, DirectedEdge @@ # ] & ] ]


(* ===================== InfraSubgraph ===================== *)

(* the substrate induced on the support of an object, thickened by t steps in the arrow form *)

InfraSubgraph[ graph_Graph, obj_ -> t_Integer ] :=
  Subgraph[ graph,
    VertexList @ NeighborhoodGraph[ graph, Keys @ InfraMeasurement[ graph, obj, "VertexDensity" ], t ] ]

InfraSubgraph[ graph_Graph, obj : Except[ _Rule | _RuleDelayed ] ] := InfraMeasurement[ graph, obj, "Subgraph" ]


(* ===================== InfraIntersection / InfraUnion ===================== *)

(* heads on heads: the support of the intersection is the common vertices and its density the product occ1(v) occ2(v), the number of pairs of members meeting at v, while the union takes the whole support and the sum.  A meeting point is diffuse or multiple exactly when that density has several clusters, and picking one cluster is a choice at the call site *)

InfraMeasurement[ graph_Graph, InfraIntersection[ objs__ ], "VertexDensity" ] :=
  With[ { densities = InfraMeasurement[ graph, #, "VertexDensity" ] & /@ { objs } },
    KeySort @ KeyTake[ Merge[ densities, Apply[ Times ] ], Intersection @@ ( Keys /@ densities ) ] ]

InfraMeasurement[ graph_Graph, InfraUnion[ objs__ ], "VertexDensity" ] :=
  KeySort @ Merge[ InfraMeasurement[ graph, #, "VertexDensity" ] & /@ { objs }, Total ]

InfraMeasurement[ graph_Graph, obj : ( InfraIntersection | InfraUnion )[ __ ], All ] :=
  InfraMeasurement[ graph, obj,
    { "VertexDensity", "Subgraph", "Volume", "BoundaryVolume", "InteriorVolume", "HalfBoundaryVolume" } ]
