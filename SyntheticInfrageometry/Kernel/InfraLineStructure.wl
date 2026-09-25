Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== InfraLineStructure wrapper ===================== *)


InfraLineStructure[ lines_List ][ "Lines" ]        := lines
InfraLineStructure[ lines_List ][ "Realizations" ] := lines
InfraLineStructure[ lines_List ][ "First" ]        := First @ lines

InfraLineStructure[ lines_List ][ "Length" ] := ( Length[ # ] - 1 ) & /@ lines

(* consistency makes P(u, v) well-defined when the pair lies on several lines *)
InfraLineStructure[ lines_List ][ "Paths" ] :=
  Association @ Flatten @ Table[
    With[ { line = lines[[ k ]] },
      Table[
        With[ { seg = line[[ i ;; j ]] },
          Sort @ { line[[ i ]], line[[ j ]] } ->
            If[ OrderedQ @ { line[[ i ]], line[[ j ]] }, seg, Reverse @ seg ] ],
        { i, Length @ line - 1 }, { j, i + 1, Length @ line } ] ],
    { k, Length @ lines } ]

InfraLineStructure[ lines_List ][ "Incidence" ] :=
  Sort /@ KeySort @ GroupBy[
    Catenate @ MapIndexed[ { line, idx } |-> ( ( # -> First @ idx ) & /@ line ), lines ],
    First -> Last ]

InfraLineStructure[ lines_List ][ "Coordinates" ] :=
  Sort /@ KeySort @ GroupBy[
    Catenate @ MapIndexed[
      { line, idx } |-> MapIndexed[ ( #1 -> { First @ idx, First @ #2 - 1 } ) &, line ], lines ],
    First -> Last ]

InfraLineStructure[ lines_List ][ "Path", u_, v_ ] :=
  With[ { line = SelectFirst[ lines, ContainsAll[ #, { u, v } ] & ] },
    { i = First @ FirstPosition[ line, u ], j = First @ FirstPosition[ line, v ] },
    If[ i <= j, line[[ i ;; j ]], Reverse @ line[[ j ;; i ]] ] ]

InfraLineStructure /: Part[ InfraLineStructure[ lines_List ], i_Integer ] := lines[[ i ]]


(* ===================== FindLineStructure ===================== *)

(* a consistent geodesic path system: one shortest path P(u, v) per pair, subpath-closed.  Consistency comes from a single generically-independent edge weighting -- the unique min-weight path per pair is automatically consistent *)

Options[ FindLineStructure ] = { Method -> "Lexicographic" };

(* every Method reduces to an edge ranking e_1, ..., e_|E|, then w(e_i) = 1 + 2^(-i): distinct subset sums of {2^(-i)} make the min-weight path unique per pair (consistent), and total perturbation < 1 keeps hop-count dominant (true geodesics).
   Exact Rationals -- machine reals underflow near |E| ~ 50 and re-collide *)

FindLineStructure[ graph_Graph, opts : OptionsPattern[] ] :=
  With[
    { rank = Association @ MapIndexed[ #1 -> First[ #2 ] &,
        With[ { edges = EdgeList @ graph },
          Replace[ OptionValue[ Method ], {
            "Lexicographic" :> SortBy[ edges, Sort @* Apply[ List ] ],
            "Random"        :> RandomSample @ edges,
            (* resistance is only a ranking key, so machine PseudoInverse is fine; the 2^(-i) weights supply genericity *)
            "Resistance"    :> With[
              { lp = PseudoInverse @ N @ KirchhoffMatrix @ graph, idx = First /@ PositionIndex @ VertexList @ graph },
              SortBy[ edges,
                e |-> { With[ { a = idx[ First @ e ], b = idx[ Last @ e ] }, lp[[ a, a ]] + lp[[ b, b ]] - 2 lp[[ a, b ]] ],
                        Sort @ Apply[ List, e ] } ] ],
            (* sorted endpoints break w-ties, so the ranking is always a total order *)
            ( "Weight" -> w_ ) :> SortBy[ edges, e |-> { w[ e ], Sort @ Apply[ List, e ] } ] } ] ] ] },
    { wg = Graph[ graph, EdgeWeight -> ( ( 1 + 2^( -rank[ # ] ) ) & /@ EdgeList @ graph ) ] },
    { spf = FindShortestPath[ wg, All, All ] },
    { paths = DeleteCases[
        Association @ Map[ Sort[ # ] -> spf @@ # &, Subsets[ VertexList[ graph ], { 2 } ] ],
        { } ] },
    { cands = DeleteDuplicates[ First @ Sort @ { #, Reverse @ # } & /@ Values @ paths ] },
    (* maximal lines: chosen paths that are not a contiguous infix, either orientation, of a strictly longer chosen path *)
    InfraLineStructure @ Select[ cands,
      c |-> NoneTrue[ cands,
        o |-> o =!= c &&
          ( SequencePosition[ o, c, 1 ] =!= { } || SequencePosition[ Reverse @ o, c, 1 ] =!= { } ) ] ]
  ]


(* ===================== ConsistentPathSystemQ ===================== *)

(* consistent (subpath-closed) iff every contiguous stretch of a chosen path is itself the chosen path between its endpoints: Cizma-Linial consistency = Bellman's principle of optimality *)

ConsistentPathSystemQ[ graph_Graph, ls_InfraLineStructure ] :=
  ConsistentPathSystemQ[ graph, ls[ "Lines" ] ]

(* a line set is consistent iff no two lines induce conflicting stretches between a shared endpoint pair *)
ConsistentPathSystemQ[ graph_Graph, lines : { __List } ] :=
  AllTrue[
    GatherBy[
      Catenate @ Map[
        line |-> Catenate @ Table[
          Sort @ { line[[ i ]], line[[ j ]] } -> First @ Sort @ { line[[ i ;; j ]], Reverse @ line[[ i ;; j ]] },
          { i, Length @ line - 1 }, { j, i + 1, Length @ line } ],
        lines ],
      First ],
    grp |-> SameQ @@ Values @ grp ]

ConsistentPathSystemQ[ graph_Graph, paths_Association ] :=
  AllTrue[ Keys @ paths,
    key |-> With[ { p = paths[ key ] },
      AllTrue[ Subsets[ Range @ Length @ p, { 2 } ],
        ij |-> With[ { subkey = Sort @ { p[[ First @ ij ]], p[[ Last @ ij ]] } },
          KeyExistsQ[ paths, subkey ] &&
            First @ Sort @ { p[[ First @ ij ;; Last @ ij ]], Reverse @ p[[ First @ ij ;; Last @ ij ]] } ===
              First @ Sort @ { paths[ subkey ], Reverse @ paths[ subkey ] } ] ] ] ]
