Package[ "WolframInstitute`InfraGeometry`" ]

Options[ RectilinearCoordinates ] = { "Axes" -> Automatic, "SelectCoordinate" -> Min }

RectilinearCoordinates[ graph_Graph, frame : { origin_, __ }, opts : OptionsPattern[] ] /;
    SimpleGraphQ[ graph ] && UndirectedGraphQ[ graph ] && ! WeightedGraphQ[ graph ] && ! EdgeTaggedGraphQ[ graph ] &&
    ConnectedGraphQ[ graph ] &&
    DuplicateFreeQ[ frame ] && AllTrue[ frame, VertexQ[ graph, # ] & ] &&
    MemberQ[ { Min, Max, First, Last }, OptionValue[ RectilinearCoordinates, { opts }, "SelectCoordinate" ] ] &&
    With[ { axes = OptionValue[ RectilinearCoordinates, { opts }, "Axes" ] },
      axes === Automatic || ListQ[ axes ] && Length[ axes ] == Length[ frame ] - 1 &&
        And @@ MapThread[ { axis, direction } |->
          ListQ[ axis ] && DuplicateFreeQ[ axis ] && AllTrue[ axis, VertexQ[ graph, # ] & ] &&
          MemberQ[ axis, Verbatim[ origin ] ] && MemberQ[ axis, Verbatim[ direction ] ] &&
          First @ FirstPosition[ axis, Verbatim[ origin ], { }, { 1 } ] <
            First @ FirstPosition[ axis, Verbatim[ direction ], { }, { 1 } ] &&
          GraphDistance[ graph, First[ axis ], Last[ axis ] ] == Length[ axis ] - 1 &&
          AllTrue[ Partition[ axis, 2, 1 ], EdgeQ[ graph, UndirectedEdge @@ # ] & ], { axes, Rest[ frame ] } ] ] :=
  With[ { axes = Replace[ OptionValue[ "Axes" ], Automatic :> FindInfraCoordinateAxes[ graph, frame ] ] },
    OrthogonalCoordinates[ graph, origin, axes, "SelectCoordinate" -> OptionValue[ "SelectCoordinate" ] ]
  ]

FindInfraCoordinateAxes[ graph_Graph, frame : { origin_, __ } ] /;
    SimpleGraphQ[ graph ] && UndirectedGraphQ[ graph ] && ! WeightedGraphQ[ graph ] && ! EdgeTaggedGraphQ[ graph ] &&
    ConnectedGraphQ[ graph ] &&
    DuplicateFreeQ[ frame ] && AllTrue[ frame, VertexQ[ graph, # ] & ] :=
  With[
    { vertices = VertexList[ graph ], distances = GraphDistanceMatrix[ graph ] },
    { index = AssociationThread[ vertices, Range[ Length[ vertices ] ] ],
      neighbors = SortBy[ #, vertex |-> vertices[[ vertex ]] ] & /@ AdjacencyList[ IndexGraph[ graph ] ] },
    Map[
      direction |-> With[
        { seed = Lookup[ index, Key /@ RandomInfraSegment[ graph, origin, direction,
            "NextVertexFunction" -> Identity, RandomSeeding -> None ] ] },
        { excess = Count[ distances[[ First[ seed ] ]] + distances[[ Last[ seed ] ]], Length[ seed ] - 1 ] - Length[ seed ] },
        vertices[[ First @ FixedPoint[
          state |-> With[
            { path = First[ state ], added = Last[ state ] },
            { ends = path[[ { 1, -1 } ]] },
            { candidates = Table[
                Select[ neighbors[[ ends[[ side ]] ]], vertex |->
                  distances[[ vertex, ends[[ 3 - side ]] ]] == Length[ path ] &&
                    Count[ distances[[ vertex ]] + distances[[ ends[[ 3 - side ]] ]], Length[ path ] ] - Length[ path ] - 1 == excess ],
                { side, 2 } ] },
            { order = If[ added[[ 1 ]] <= added[[ 2 ]], { 1, 2 }, { 2, 1 } ] },
            { side = SelectFirst[ order, candidates[[ # ]] =!= { } &, 0 ] },
            If[ side == 0, state,
              { If[ side == 1, Prepend[ path, First[ candidates[[ 1 ]] ] ], Append[ path, First[ candidates[[ 2 ]] ] ] ],
                added + UnitVector[ 2, side ] } ] ],
          { seed, { 0, 0 } } ] ]] ],
      Rest[ frame ] ]
  ]
