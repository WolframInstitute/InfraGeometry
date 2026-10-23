Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSphere *)

(* in the band B = { v != c : rmin <= d(c, v) <= rmax } a set separates when it meets every path from c to the exterior { v : d(c, v) > rmax };
   {"Separating"} gives the minimal separating subsets of B, {"Separating", "Connected"} the walls: the connected separating subsets of B
   with no proper connected separating subset; sorted vertex lists, the count-less call one, a count and All a List -- the band under {} *)

Options[ RandomInfraSphere ] = {
  Properties           -> { "Separating", "Connected" },
  "NextVertexFunction" -> Automatic,
  RandomSeeding        -> Automatic
}

RandomInfraSphere[ args___ ] /; FreeQ[ { args }, RandomSeeding -> None, { 1 } ] :=
  With[ { result = BlockRandom[
      RandomInfraSphere[ Sequence @@ DeleteCases[ { args }, RandomSeeding -> _ ], RandomSeeding -> None ],
      RandomSeeding -> FirstCase[ { args }, ( RandomSeeding -> seed_ ) :> seed, Automatic ] ] },
    result /; ! MatchQ[ result, HoldPattern[ RandomInfraSphere[ ___, RandomSeeding -> None ] ] ] ]

RandomInfraSphere[ graph_Graph, p_, r_,
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( ( VertexQ[ graph, p ] || ! MatchQ[ p, _InfraSphere ] ) &&
    SubsetQ[ First /@ Options[ RandomInfraSphere ], First /@ { opts } ] &&
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ RandomInfraSphere, { opts }, Properties ] ] &&
    ( count =!= All || OptionValue[ RandomInfraSphere, { opts }, "NextVertexFunction" ] =!= RandomChoice ) ) :=
  With[ {
      properties = OptionValue[ RandomInfraSphere, { opts }, Properties ],
      nextFn = Replace[ OptionValue[ RandomInfraSphere, { opts }, "NextVertexFunction" ],
        Automatic -> If[ count === All, Identity, RandomSample ] ],
      range = Replace[ r, d_?NumericQ :> { d, d } ] },
    { cap = Replace[ count, { All -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
    { results = Map[
        c |-> With[ { local = If[ NumericQ[ range[[ 2 ]] ], NeighborhoodGraph[ graph, c, Ceiling[ range[[ 2 ]] ] + 1 ], graph ] },
          { distances = AssociationThread[ VertexList[ local ], GraphDistance[ local, c ] ] },
          { band = Select[ VertexList[ local ], range[[ 1 ]] <= distances[ # ] <= range[[ 2 ]] & ],
            exterior = Select[ VertexList[ local ], distances[ # ] > range[[ 2 ]] & ] },
          { shell = DeleteCases[ band, c ] },
          Which[
            properties === { },
              { band },
            ! MemberQ[ properties, "Separating" ],
              If[ shell =!= { } && ConnectedGraphQ @ Subgraph[ graph, shell ], List /@ shell, { } ],
            MemberQ[ properties, "Connected" ],
              With[ { labels = VertexList[ local ], adjacency = Sign[ AdjacencyMatrix[ local ] + Transpose @ AdjacencyMatrix[ local ] ] },
                { size = Length[ labels ], source = VertexIndex[ local, c ], targets = VertexIndex[ local, # ] & /@ exterior },
                { indicator = set |-> Normal @ SparseArray[ Thread[ List /@ set -> 1 ], { size } ] },
                { component = { open, seeds } |-> FixedPoint[ reach |-> open Unitize[ reach + adjacency . reach ], open indicator[ seeds ] ] },
                { separatesQ = set |-> Total[ component[ 1 - indicator[ set ], { source } ][[ targets ]] ] == 0 },
                (* v can leave a candidate W iff W - v is connected (v is no cut vertex of W) and v does not join the side of c to the exterior *)
                { removable = set |-> With[ { open = 1 - indicator[ set ] },
                    { joins = Unitize[ adjacency . component[ open, { source } ] ] Unitize[ adjacency . component[ open, targets ] ],
                      cuts = set[[ Select[ Tally @ Catenate @ KVertexConnectedComponents[ AdjacencyGraph[ adjacency[[ set, set ]] ], 2 ],
                        Last @ # > 1 & ][[ All, 1 ]] ]] },
                    Select[ set, v |-> joins[[ v ]] == 0 && ! MemberQ[ cuts, v ] ] ] },
                { pick = list |-> First[ Replace[ nextFn @ list, chosen_ /; MemberQ[ list, Verbatim @ chosen ] :> { chosen } ], First @ list ] },
                { roots = Select[ Map[ part |-> Sort @ Lookup[ AssociationThread[ labels, Range[ size ] ], part ],
                    ConnectedComponents @ Subgraph[ local, shell ] ], separatesQ ] },
                (* a depth-first peel from the separating components of the band: each descent deletes removable vertices chosen by nextFn
                   until none is left, skipping the sets all of whose walls were found, and starts again at the band after each wall *)
                Map[ set |-> Sort @ labels[[ set ]],
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
              With[
                (* the exterior contracted to one vertex t; every component of the interior beyond c becomes a clique on its neighbours *)
                { aux = With[ { contracted = If[ Length[ exterior ] > 1, VertexContract[ local, exterior ], local ] },
                    { nodes = Union[ shell, { c }, Take[ exterior, UpTo[ 1 ] ] ] },
                    { components = ConnectedComponents @ Subgraph[ contracted, Complement[ VertexList[ contracted ], nodes ] ] },
                    { paired = Flatten[
                        ( comp |-> UndirectedEdge @@@ Subsets[
                            Intersection[ nodes, Union @@ ( AdjacencyList[ contracted, # ] & /@ comp ) ],
                            { 2 } ] ) /@ components, 1 ],
                      direct = Cases[ EdgeList[ contracted ],
                        ( UndirectedEdge | DirectedEdge )[ u_, v_ ] /;
                          MemberQ[ nodes, u ] && MemberQ[ nodes, v ] :> UndirectedEdge[ u, v ] ] },
                    SimpleGraph @ Graph[ nodes, Join[ paired, direct ] ] ] },
                (* the minimal c-t separators S of aux, generated from the one nearest c by S -> N(C(S) + x) cut down to the neighbours
                   of the component of t, for x in S, C(S) the component of c in aux - S (Berry, Bordat, Cogis 1999) *)
                { labels = VertexList[ aux ], adjacency = AdjacencyMatrix[ aux ] },
                { size = Length[ labels ], neighbours = Sort /@ adjacency[ "AdjacencyLists" ],
                  source = VertexIndex[ aux, c ], target = If[ exterior === { }, 0, VertexIndex[ aux, First @ exterior ] ] },
                { indicator = set |-> Normal @ SparseArray[ Thread[ List /@ set -> 1 ], { size } ] },
                { component = { open, seed } |-> FixedPoint[ reach |-> open Unitize[ reach + adjacency . reach ], open UnitVector[ size, seed ] ] },
                { nearest = { blocked, candidates } |-> With[ { far = component[ 1 - Unitize[ blocked ], target ] },
                    Pick[ candidates, Unitize[ ( adjacency . far )[[ candidates ]] ], 1 ] ] },
                { successors = separator |-> With[ { cut = indicator[ separator ] }, { side = component[ 1 - cut, source ] },
                    Map[ x |-> nearest[ side + cut + indicator[ neighbours[[ x ]] ],
                        Union[ DeleteCases[ separator, x ], Pick[ neighbours[[ x ]], ( side + cut )[[ neighbours[[ x ]] ]], 0 ] ] ],
                      Select[ separator, x |-> adjacency[[ x, target ]] == 0 ] ] ] },
                { separators = Sort @ Which[
                    exterior === { }, { { } },
                    adjacency[[ source, target ]] == 1, { },
                    True, With[ { start = nearest[ indicator[ Append[ neighbours[[ source ]], source ] ], neighbours[[ source ]] ] },
                      Map[ set |-> Sort @ labels[[ set ]], Keys @ First @ NestWhile[
                        state |-> With[ { seen = First @ state },
                          { next = Select[ DeleteDuplicates @ Catenate @ Map[ successors, Last @ state ], set |-> ! KeyExistsQ[ seen, set ] ] },
                          { Join[ seen, AssociationThread[ next, True ] ], next } ],
                        { <| start -> True |>, { start } }, Last @ # =!= { } & ] ] ] ] },
                If[ separators === { }, { },
                  Take[ Replace[ nextFn @ separators, chosen_ /; MemberQ[ separators, Verbatim @ chosen ] :> { chosen } ],
                    UpTo[ Min[ cap, Length @ separators ] ] ] ] ] ] ],
        Keys @ InfraMeasurement[ graph, p, "VertexDensity" ] ] },
    { spheres = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
    Switch[ count,
      Automatic, First[ spheres, { } ],
      All,       Sort @ spheres,
      _UpTo,     Take[ spheres, count ],
      _,         If[ Length @ spheres < count, { }, Take[ spheres, count ] ] ] ]

(* the sphere family's densities are the sums of its members' indicators, read off the exhaustive search *)

InfraMeasurement[ graph_Graph, InfraSphere[ center_, r_ ], "VertexDensity" ] :=
  KeySort @ Merge[ AssociationThread[ #, 1 ] & /@ RandomInfraSphere[ graph, center, r, All, RandomSeeding -> None ], Total ]

InfraMeasurement[ graph_Graph, InfraSphere[ center_, r_ ], "EdgeDensity" ] :=
  KeySort @ Merge[ AssociationThread[ EdgeList @ Subgraph[ graph, # ], 1 ] & /@
    RandomInfraSphere[ graph, center, r, All, RandomSeeding -> None ], Total ]

InfraMeasurement[ graph_Graph, InfraSphere[ center_, r_ ], "Cardinality" ] :=
  Length @ RandomInfraSphere[ graph, center, r, All, RandomSeeding -> None ]

InfraMeasurement[ graph_Graph, sphere : InfraSphere[ _, _ ], All ] :=
  InfraMeasurement[ graph, sphere,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

(* W is a wall iff W lies in the band, is connected, separates, and no single vertex can leave it: a connected separating W' inside W
   leaves a vertex of W - W' whose deletion keeps W connected, a leaf of a spanning tree of W with W' contracted *)

InfraMemberQ[ graph_Graph, InfraSphere[ center_, r_ ], vertices_List ] :=
  With[ { density = InfraMeasurement[ graph, center, "VertexDensity" ], set = Union @ vertices,
      range = Replace[ r, d_?NumericQ :> { d, d } ] },
    AnyTrue[ Keys @ density,
      c |-> With[ { distances = AssociationThread[ VertexList[ graph ], GraphDistance[ graph, c ] ] },
        { wallQ = part |-> ConnectedGraphQ @ Subgraph[ graph, part ] &&
            AllTrue[ VertexComponent[ VertexDelete[ graph, part ], c ], distances[ # ] <= range[[ 2 ]] & ] },
        AllTrue[ set, v |-> v =!= c && VertexQ[ graph, v ] && range[[ 1 ]] <= distances[ v ] <= range[[ 2 ]] ] &&
          wallQ[ set ] && NoneTrue[ set, v |-> wallQ[ DeleteCases[ set, v ] ] ] ] ] /; AssociationQ @ density ]

RandomInfraSphere[ graph_Graph, InfraSphere[ center_, radius_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraSphere ], First /@ { opts } ] ) :=
  RandomInfraSphere[ graph, center, radius, count, opts ]
