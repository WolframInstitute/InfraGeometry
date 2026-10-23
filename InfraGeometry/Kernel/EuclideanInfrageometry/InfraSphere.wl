Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSphere *)

(* the minimal sets S in the band L = { v != c : rmin <= d(c, v) <= rmax } that separate c from the exterior { v : d(c, v) > rmax },
   sorted vertex lists; under "Connected" those S that are connected; the count-less call is one, a count and All a List of them --
   the band itself under Properties -> {} *)

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
    { results = Map[
        c |-> With[ { local = If[ NumericQ[ range[[ 2 ]] ], NeighborhoodGraph[ graph, c, Ceiling[ range[[ 2 ]] ] + 1 ], graph ] },
          { distances = AssociationThread[ VertexList[ local ], GraphDistance[ local, c ] ] },
          { band = Select[ VertexList[ local ], range[[ 1 ]] <= distances[ # ] <= range[[ 2 ]] & ],
            exterior = Select[ VertexList[ local ], distances[ # ] > range[[ 2 ]] & ] },
          { shell = DeleteCases[ band, c ] },
          If[ properties === { },
            { band },
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
              { spheres = Which[
                  ! MemberQ[ properties, "Separating" ],
                    If[ shell =!= { } && ConnectedGraphQ @ Subgraph[ graph, shell ], List /@ shell, { } ],
                  exterior === { }, { { } },
                  adjacency[[ source, target ]] == 1, { },
                  True, With[ { start = nearest[ indicator[ Append[ neighbours[[ source ]], source ] ], neighbours[[ source ]] ] },
                    Map[ set |-> Sort @ labels[[ set ]], Keys @ First @ NestWhile[
                      state |-> With[ { seen = First @ state },
                        { next = Select[ DeleteDuplicates @ Catenate @ Map[ successors, Last @ state ], set |-> ! KeyExistsQ[ seen, set ] ] },
                        { Join[ seen, AssociationThread[ next, True ] ], next } ],
                      { <| start -> True |>, { start } }, Last @ # =!= { } & ] ] ] ] },
              { admissible = Sort @ If[ MemberQ[ properties, "Connected" ],
                  Select[ spheres, set |-> set =!= { } && ConnectedGraphQ @ Subgraph[ graph, set ] ], spheres ] },
              { cap = Replace[ count, { All -> Length @ admissible, Automatic -> 1, UpTo[ n_ ] :> n } ] },
              If[ admissible === { }, { },
                Take[ Replace[ nextFn @ admissible, chosen_ /; MemberQ[ admissible, Verbatim @ chosen ] :> { chosen } ], UpTo[ cap ] ] ] ] ] ],
        Keys @ InfraMeasurement[ graph, p, "VertexDensity" ] ] },
    { spheres = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
    Switch[ count,
      Automatic, First[ spheres, { } ],
      All,       spheres,
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

InfraMemberQ[ graph_Graph, InfraSphere[ center_, r_ ], vertices_List ] :=
  With[ { members = RandomInfraSphere[ graph, center, r, All, RandomSeeding -> None ] },
    MemberQ[ members, Union @ vertices ] /; ListQ @ members ]

RandomInfraSphere[ graph_Graph, InfraSphere[ center_, radius_ ],
    count : ( _Integer?( n |-> n >= 0 ) | UpTo[ _Integer?( n |-> n >= 0 ) ] | All | Automatic ) : Automatic,
    opts : OptionsPattern[] ] /; MemberQ[ Flatten @ { opts }, RandomSeeding -> None ] &&
    ( SubsetQ[ First /@ Options[ RandomInfraSphere ], First /@ { opts } ] ) :=
  RandomInfraSphere[ graph, center, radius, count, opts ]
