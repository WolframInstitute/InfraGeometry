Package["WolframInstitute`InfraGeometry`"]


(* ===================== FindInfraRevolution ===================== *)

(* each axis path is extended by the vertices v adjacent to its endpoint with d(v, path[[k]]) = k (left) or n - k + 1 (right) for every k, i.e. those prolonging the axis as a geodesic *)

Options[ FindInfraRevolution ] = { "Form" -> "Solid", Method -> "Voronoi" };

FindInfraRevolution[ graph_Graph, axis_, profile_, opts : OptionsPattern[ ] ] :=
  With[
    { walksOf = w |-> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
          EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
          spelled,            { Last /@ SortBy[ vs, First ] },
          DirectedGraphQ @ w,
            Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ] },
    { axisPaths = Which[
        GraphQ @ axis,                        walksOf @ axis,
        MatchQ[ axis, { __Graph } ],          Catenate[ walksOf /@ axis ],
        MatchQ[ axis, { _List, ___List } ],   axis,
        True,                                 { axis } ] },
    { n = Length @ First @ axisPaths,
      origPositions = DeleteDuplicates /@ Transpose @ axisPaths,
      surface = OptionValue[ "Form" ] === "Surface",
      method = OptionValue[ Method ] },
    { radii = Round /@ Which[ NumericQ @ profile, ConstantArray[ profile, n ], ListQ @ profile, profile, True, profile /@ Range[ n ] ] },
    If[ method === "Balls",
      (* "Balls": the sublevel set { v : min_i (d(v, c_i) - r_i) <= 0 } of the varying-radius tube function; no geodesic extension, so cyclic and non-extendable axes work too *)
      With[
        { candidates = VertexList @ NeighborhoodGraph[ graph, Union @@ origPositions, Max @ radii ],
          slack = v |-> Min @ MapThread[
            { posVerts, r } |-> Min[ GraphDistance[ graph, v, # ] & /@ posVerts ] - r,
            { origPositions, radii } ] },
        (* constant radius: the r-neighborhood of the axis IS the union of balls, so the candidate set is already the answer *)
        Union @ If[ ! surface && Equal @@ radii,
          candidates,
          Select[ candidates, If[ surface, slack[ # ] == 0, slack[ # ] <= 0 ] & ] ] ],
      (* the right extension of a path is the left extension of its reverse *)
      With[
        { extension = paths |-> If[ n == 1, { },
            Union @@ ( path |-> Select[ AdjacencyList[ graph, First @ path ],
              v |-> ! MemberQ[ path, v ] &&
                    AllTrue[ Range @ Length @ path, GraphDistance[ graph, v, path[[ # ]] ] === # & ] ] ) /@ paths ] },
        { leftExt  = extension @ axisPaths,
          rightExt = extension[ Reverse /@ axisPaths ] },
        { positions = Join[ If[ leftExt === { }, { }, { leftExt } ], origPositions, If[ rightExt === { }, { }, { rightExt } ] ],
          origRange = Range @ n + If[ leftExt === { }, 0, 1 ] },
        Union @@ MapThread[
          { posVerts, r, i } |->
            Select[ VertexList @ NeighborhoodGraph[ graph, posVerts, r ],
              v |-> With[ { dists = Min[ GraphDistance[ graph, v, # ] & /@ # ] & /@ positions },
                If[ surface, dists[[ i ]] == r, dists[[ i ]] <= r ] && Switch[ method,
                  "Voronoi",                dists[[ i ]] === Min @ dists,
                  "PerpendicularBisector",
                    If[ i == 1 || i == Length @ positions, dists[[ i ]] === Min @ dists, dists[[ i - 1 ]] === dists[[ i + 1 ]] ] ] ] ],
          { origPositions, radii, origRange } ] ] ] ]


(* ===================== FindInfraCylinder ===================== *)

Options[ FindInfraCylinder ] = Join[ FilterRules[ Options[ FindInfraRevolution ], Except[ Method ] ], { Method -> "Balls" } ];

FindInfraCylinder[ graph_Graph, axis_, radius_, opts : OptionsPattern[ ] ] :=
  FindInfraRevolution[ graph, axis, radius, Method -> OptionValue[ Method ],
    FilterRules[ { opts }, Except[ Method ] ] ]


(* ===================== FindInfraCone ===================== *)

Options[ FindInfraCone ] = Join[ Options[ FindInfraRevolution ], { "Apex" -> First } ];

FindInfraCone[ graph_Graph, axis_, slope_, opts : OptionsPattern[ ] ] :=
  With[
    { walksOf = w |-> With[ { vs = VertexList @ w },
        { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
          scan = v |-> Reap[ DepthFirstScan[ w, v, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
        Which[
          ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
            { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
          EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
          spelled,            { Last /@ SortBy[ vs, First ] },
          DirectedGraphQ @ w,
            Catenate @ Catenate @ Table[ FindPath[ w, s, t, Infinity, All ],
              { s, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { t, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
          True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
      apex = OptionValue[ "Apex" ] },
    { n = Length @ First @ Which[
        GraphQ @ axis,                        walksOf @ axis,
        MatchQ[ axis, { __Graph } ],          Catenate[ walksOf /@ axis ],
        MatchQ[ axis, { _List, ___List } ],   axis,
        True,                                 { axis } ] },
    FindInfraRevolution[ graph, axis,
      slope * If[ apex === Last, Range[ n - 1, 0, -1 ], Range[ 0, n - 1 ] ],
      FilterRules[ { opts }, Options[ FindInfraRevolution ] ] ]
  ]


(* ===================== InfraRevolutionQ ===================== *)

InfraRevolutionQ[ graph_Graph, vs_List, axis_, profile_, opts : OptionsPattern[ FindInfraRevolution ] ] :=
  Union @ vs === FindInfraRevolution[ graph, axis, profile, opts ]

InfraRevolutionQ[ graph_Graph, o_Association, axis_, profile_,
    opts : OptionsPattern[ FindInfraRevolution ] ] :=
  InfraRevolutionQ[ graph, Keys @ o, axis, profile, opts ]


(* ===================== Scene-DSL constructor ===================== *)

dispatchConstruction[ graph_Graph, InfraRevolution[ axis_, profile_, opts___Rule ] ] :=
  capBranches[
    applySelectOption[ graph,
      { FindInfraRevolution[ graph, axis, profile,
          Sequence @@ FilterRules[ { opts }, Options[ FindInfraRevolution ] ] ] },
      "Select" /. { opts } /. "Select" -> None,
      False, <| "Axis" -> axis, "Profile" -> profile |> ],
    extractBranches[ { opts } ] ]
