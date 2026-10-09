Package[ "WolframInstitute`InfraGeometry`" ]

(* WolframInstitute`InfraGeometry` :: EuclideanInfrageometry :: InfraSphere *)

(* the inclusion-minimal admissible subsets of the level surface { v : rmin <= d(c, v) <= rmax }, sorted vertex lists; the count-less call is one,
   a bounded count and All a List of them -- the level set itself under Properties -> {} *)

Options[ RandomInfraSphere ] = {
  Properties           -> { "Separating", "Connected" },
  "NextVertexFunction" -> Automatic
}

RandomInfraSphere[ graph_Graph, p_, r_,
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    SubsetQ[ { "Separating", "Connected" }, OptionValue[ RandomInfraSphere, { opts }, Properties ] ] &&
    ( count =!= All || OptionValue[ RandomInfraSphere, { opts }, "NextVertexFunction" ] =!= RandomChoice ) :=
  With[ {
      properties = OptionValue[ RandomInfraSphere, { opts }, Properties ],
      nextFn = If[ count === All &&
          OptionValue[ RandomInfraSphere, { opts }, "NextVertexFunction" ] === Automatic,
        Identity, OptionValue[ RandomInfraSphere, { opts }, "NextVertexFunction" ] ],
      range = Replace[ r, d_?NumericQ :> { d, d } ],
      radius = If[ NumericQ[ r ], r, Mean[ r ] ] },
    { cap = Replace[ count, { All | Infinity -> Infinity, Automatic -> 1, UpTo[ n_ ] :> n } ] },
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
                pick = cands |-> Which[
                  cands === { } || nextFn === Identity, cands,
                  nextFn === Automatic, RandomSample @ cands,
                  True, Replace[ nextFn @ cands,
                    chosen_ /; MemberQ[ cands, Verbatim @ chosen ] :> { chosen } ] ] },
              { descend = { self, state, T } |-> If[ Length @ First @ state >= cap || KeyExistsQ[ Last @ state, T ],
                  state,
                  With[ { marked = { First @ state, Append[ Last @ state, T -> True ] },
                          peelable = Select[ T, w |-> admissible[ DeleteCases[ T, w ] ] ] },
                    If[ peelable === { },
                      { Append[ First @ marked, T ], Last @ marked },
                      Fold[ { s, w } |-> self[ self, s, DeleteCases[ T, w ] ], marked, pick @ peelable ] ] ] ] },
              If[ ! admissible[ levelSet ], { }, First @ descend[ descend, { { }, <| |> }, levelSet ] ] ] ] ],
        Keys @ InfraDensity[ graph, p ] ] },
    { shells = DeleteDuplicates[ Union /@ DeleteDuplicates @ Flatten[ results, 1 ] ] },
    Switch[ count,
      Automatic, First[ shells, { } ],
      All,       shells,
      _UpTo,     Take[ shells, count ],
      _,         If[ Length @ shells < count, { }, Take[ shells, count ] ] ] ]

(* the sphere family's densities are the sums of its members' indicators, read off the exhaustive search *)

InfraMeasurement[ graph_Graph, InfraSphere[ center_, r_ ], "VertexDensity" ] :=
  KeySort @ Merge[ AssociationThread[ #, 1 ] & /@ RandomInfraSphere[ graph, center, r, All ], Total ]

InfraMeasurement[ graph_Graph, InfraSphere[ center_, r_ ], "EdgeDensity" ] :=
  KeySort @ Merge[ AssociationThread[ EdgeList @ Subgraph[ graph, # ], 1 ] & /@ RandomInfraSphere[ graph, center, r, All ], Total ]

InfraMeasurement[ graph_Graph, InfraSphere[ center_, r_ ], "Cardinality" ] :=
  Length @ RandomInfraSphere[ graph, center, r, All ]

InfraMeasurement[ _Graph, InfraSphere[ _, _ ], "Faithful" ] :=
  Undetermined

InfraMeasurement[ graph_Graph, sphere : InfraSphere[ _, _ ], All ] :=
  InfraMeasurement[ graph, sphere,
    { "Faithful", "Cardinality", "VertexDensity", "EdgeDensity", "Subgraph",
      "CountingMeasure", "RiemannianMeasure" } ]

RandomInfraRepresentative[ graph_Graph, InfraSphere[ center_, r_ ],
    count : ( _Integer | UpTo[ _Integer ] | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    ( OptionValue[ RandomInfraRepresentative, { opts }, "NextVertexFunction" ] =!= RandomChoice || count =!= All ) :=
  RandomInfraSphere[ graph, center, r, count,
    "NextVertexFunction" -> OptionValue[ RandomInfraRepresentative, { opts }, "NextVertexFunction" ] ]
