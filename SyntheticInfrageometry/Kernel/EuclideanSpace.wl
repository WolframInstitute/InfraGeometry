Package["WolframInstitute`SyntheticInfrageometry`"]


(* ===================== InfraScalarProduct ===================== *)

(* "Alexandrov": <u, v>_o = d(o, u) d(o, v) cos theta_k with theta_k the comparison angle at o in M_k^2; k = 0 collapses to (d(o,u)^2 + d(o,v)^2 - d(u,v)^2) / 2.
   "Parallelogram": the polarisation (||u + v||_o^2 - ||u - v||_o^2) / 4 over realisations of u + v and u - v on the substrate. *)

InfraScalarProduct::badmethod = "Method `1` is not supported by InfraScalarProduct.";

Options[ InfraScalarProduct ] = { Method -> "Alexandrov" };

InfraScalarProduct[ graph_Graph, o_, u_, v_, OptionsPattern[] ] :=
  Switch[ Replace[ OptionValue[ Method ], { m_String, ___ } :> m ],
    "Alexandrov",
      With[ { k = Lookup[ Replace[ OptionValue[ Method ], { { _String, opt___ } :> { opt }, _ -> { } } ], "Curvature", 0 ],
              d = { a, b } |-> GraphDistance[ graph, a, b ] },
        { s = Sqrt @ Abs @ k },
        If[ k === 0,
          ( d[ o, u ]^2 + d[ o, v ]^2 - d[ u, v ]^2 ) / 2,
          d[ o, u ] d[ o, v ] Which[
            k == 0, ( d[ o, u ]^2 + d[ o, v ]^2 - d[ u, v ]^2 ) / ( 2 d[ o, u ] d[ o, v ] ),
            k > 0,  ( Cos[ d[ u, v ] s ] - Cos[ d[ o, u ] s ] Cos[ d[ o, v ] s ] ) / ( Sin[ d[ o, u ] s ] Sin[ d[ o, v ] s ] ),
            k < 0,  ( Cosh[ d[ o, u ] s ] Cosh[ d[ o, v ] s ] - Cosh[ d[ u, v ] s ] ) / ( Sinh[ d[ o, u ] s ] Sinh[ d[ o, v ] s ] ) ]
        ]
      ],
    "Parallelogram",
      With[ { plus  = FindInfraLinearCombination[
                graph, o, { { 1, u }, {  1, v } }, All, "ScaleMethod" -> "Line" ],
              minus = FindInfraLinearCombination[
                graph, o, { { 1, u }, { -1, v } }, All, "ScaleMethod" -> "Line" ] },
        If[ plus === { } || minus === { }, $Failed,
          With[ { vals = DeleteDuplicates @ Flatten @ Outer[
                ( GraphDistance[ graph, o, #1 ]^2 - GraphDistance[ graph, o, #2 ]^2 ) / 4 &,
                plus, minus ] },
            If[ Length[ vals ] == 1, First @ vals, vals ]
          ]
        ]
      ],
    _, Message[ InfraScalarProduct::badmethod, OptionValue[ Method ] ]; $Failed
  ]


(* ===================== FindInfraLinearCombination ===================== *)

(* Sum_i lambda_i u_i from o: each scaled term lambda u, the partial sums composed pairwise left-to-right *)

Options[ FindInfraLinearCombination ] = {
  "ScaleMethod" -> Automatic,
  "SumMethod"   -> "Metric"
};

FindInfraLinearCombination[ graph_Graph, o_, terms_List,
    count : ( _Integer | UpTo[ _Integer ] | All ) : All, opts : OptionsPattern[] ] :=
  Module[ { asList, bsList, mids },
    With[ { lambdas = terms[[ All, 1 ]], us = terms[[ All, 2 ]],
            scaleM = OptionValue[ "ScaleMethod" ], sumM = OptionValue[ "SumMethod" ],
            walksOf = w |-> With[ { vs = VertexList @ w },
              { spelled = AllTrue[ vs, MatchQ[ { _Integer, _ } ] ] && Sort[ First /@ vs ] === Range @ Length @ vs,
                scan = root |-> Reap[ DepthFirstScan[ w, root, { "PrevisitVertex" -> ( Sow[ #1 ] & ) } ] ][[ 2, 1 ]] },
              Which[
                ! LoopFreeGraphQ @ w || ! AcyclicGraphQ @ w,
                  { If[ First @ # === Last @ #, #, Append[ #, First @ # ] ] & @
                      If[ spelled, Last /@ SortBy[ vs, First ], scan @ First @ vs ] },
                EdgeCount @ w == 0, List /@ If[ spelled, Last /@ vs, vs ],
                spelled,            { Last /@ SortBy[ vs, First ] },
                DirectedGraphQ @ w,
                  Catenate @ Catenate @ Table[ FindPath[ w, a, b, Infinity, All ],
                    { a, Select[ vs, VertexInDegree[ w, # ] == 0 & ] }, { b, Select[ vs, VertexOutDegree[ w, # ] == 0 & ] } ],
                True, { scan @ SelectFirst[ vs, VertexDegree[ w, # ] == 1 &, First @ vs ] } ] ],
            (* the midpoints of a, b: the vertices at distance d(a, b)/2 from both, none when d(a, b) is odd *)
            midpoint = { a, b } |->
              With[ { r = GraphDistance[ graph, a, b ] },
                If[ EvenQ[ r ],
                  Select[ VertexList[ graph ],
                    GraphDistance[ graph, a, # ] == r/2 &&
                    GraphDistance[ graph, b, # ] == r/2 & ],
                  { } ] ] },
      { spread = x |-> Which[
          AssociationQ @ x,         Keys @ x,
          GraphQ @ x,               walksOf @ x,
          MatchQ[ x, { __Graph } ], Catenate[ walksOf /@ x ],
          x === { },                { },
          True,                     { x } ] },
      (* lambda * u from o: "Metric" the vertex collinear with o, u at distance |lambda| r, "Line" the index snap along FindInfraLine, "Midpoint" dyadic bisection for lambda in [0, 1] *)
      { scale = { o0, u, lambda } |-> With[
          { method = Replace[ scaleM, Automatic :> Which[
              IntegerQ[ lambda ], "Metric",
              Element[ Rationalize[ lambda, 0 ], Rationals ] &&
                IntegerQ[ Log2 @ Denominator @ Rationalize[ lambda, 0 ] ] &&
                0 <= lambda <= 1, "Midpoint",
              True, "Line" ] ] },
          Which[
            lambda === 0, { o0 },
            lambda === 1, { u },
            method === "Metric",
              With[ { r = GraphDistance[ graph, o0, u ] },
                If[ r === Infinity, { },
                  DeleteDuplicates @ Select[ VertexList[ graph ],
                    GraphDistance[ graph, o0, # ] == Abs[ lambda ] r &&
                    If[ lambda > 0,
                      GraphDistance[ graph, o0, # ] + GraphDistance[ graph, #, u ] == r ||
                        r + GraphDistance[ graph, u, # ] == GraphDistance[ graph, o0, # ],
                      GraphDistance[ graph, #, o0 ] + r == GraphDistance[ graph, #, u ]
                    ] & ] ] ],
            method === "Line",
              If[ GraphDistance[ graph, o0, u ] === Infinity, { },
                DeleteDuplicates @ Flatten @ ( ( line |->
                  With[ { oIdx = First @ FirstPosition[ line, o0, { 0 } ],
                          uIdx = First @ FirstPosition[ line, u, { 0 } ] },
                    { targetIdx = oIdx + Round[ lambda ( uIdx - oIdx ) ] },
                    If[ oIdx > 0 && uIdx > 0 && 1 <= targetIdx <= Length[ line ],
                      { line[[ targetIdx ]] }, { } ]
                  ] ) /@ FindInfraLine[ graph, o0, u, All ] ) ],
            method === "Midpoint" && 0 < lambda < 1,
              With[ { rational = Rationalize[ lambda, 0 ] },
                { depth = If[ Element[ rational, Rationals ] && IntegerQ[ Log2 @ Denominator[ rational ] ],
                    Log2 @ Denominator[ rational ], 8 ] },
                asList = { o0 };
                bsList = { u };
                Do[
                  mids = DeleteDuplicates @ Flatten @ Outer[ midpoint, asList, bsList, 1 ];
                  If[ mids === { }, Break[ ] ];
                  If[ bit == 0, bsList = mids, asList = mids ],
                  { bit, IntegerDigits[ Round[ lambda 2^depth ], 2, depth ] } ];
                asList ] ] ],
        (* u + v from o: "Metric" { w : d(u, w) == d(o, v), d(v, w) == d(o, u), w != o }, "Parallel" the intersection of the parallels through u and through v *)
        sum = { o0, u, v } |-> Switch[ sumM,
          "Metric",
            With[ { rU = GraphDistance[ graph, o0, u ], rV = GraphDistance[ graph, o0, v ] },
              DeleteDuplicates @ Select[ VertexList[ graph ],
                GraphDistance[ graph, u, # ] == rV &&
                GraphDistance[ graph, v, # ] == rU &&
                # =!= o0 & ] ],
          "Parallel",
            With[ { parallelsAtU = Catenate[ spread @ FindInfraParallel[ graph, #, u, All ] & /@ FindInfraLine[ graph, o0, v, All ] ],
                    parallelsAtV = Catenate[ spread @ FindInfraParallel[ graph, #, v, All ] & /@ FindInfraLine[ graph, o0, u, All ] ] },
              DeleteDuplicates @ DeleteCases[
                Flatten @ Outer[ Intersection, parallelsAtU, parallelsAtV, 1 ],
                o0 | u | v ] ] ] },
      { reps = DeleteDuplicates @ Flatten[
          Map[ tuple |-> With[ { thisO = First @ tuple },
              { scaled = MapThread[ scale[ thisO, #2, #1 ] &, { lambdas, Rest @ tuple } ] },
              If[ Length[ scaled ] == 0,
                { thisO },
                Fold[
                  { acc, next } |->
                    DeleteDuplicates @ Flatten @ Outer[ sum[ thisO, #1, #2 ] &, acc, next, 1 ],
                  First @ scaled, Rest @ scaled ] ] ],
            Tuples[ spread /@ Prepend[ us, o ] ] ], 1 ] },
      Switch[ count,
        All,   reps,
        _UpTo, Take[ reps, count ],
        _,     If[ Length @ reps < count, $Failed, Take[ reps, count ] ] ] ] ]


(* ===================== InfraAngle ===================== *)

(* "Arclength": remove the open ball B(p, min(d(p, q1), d(p, q2))) and normalise d(q1, q2) in the rest by the radius, a synthetic radian measure of the detour around p.
   "Alexandrov": the comparison-triangle angle in M_k^2. *)

InfraAngle::badmethod = "Method `1` is not supported by InfraAngle.";

Options[ InfraAngle ] = { Method -> "Arclength" };

InfraAngle[ graph_Graph, triple : { _, _, _ }, opts : OptionsPattern[] ] /;
    ! FreeQ[ triple, _Association ] :=
  InfraAngle[ graph, triple /. fam_Association :> First @ Keys @ fam, opts ]

InfraAngle[ graph_Graph, { q1_, p_, q2_ }, OptionsPattern[] ] :=
  Switch[ Replace[ OptionValue[ Method ], { m_String, ___ } :> m ],
    "Arclength",
      With[ { radius = Min[ GraphDistance[ graph, p, q1 ], GraphDistance[ graph, p, q2 ] ] },
        { rem = VertexDelete[ graph,
            Select[ VertexList[ graph ], GraphDistance[ graph, p, # ] < radius & ] ] },
        GraphDistance[ rem, q1, q2 ] / radius
      ],
    "Alexandrov",
      With[ { k = Lookup[ Replace[ OptionValue[ Method ], { { _String, opt___ } :> { opt }, _ -> { } } ], "Curvature", 0 ],
              a = GraphDistance[ graph, q1, q2 ], b = GraphDistance[ graph, p, q1 ], c = GraphDistance[ graph, p, q2 ] },
        { s = Sqrt @ Abs @ k },
        ArcCos @ Which[
          k == 0, ( b^2 + c^2 - a^2 ) / ( 2 b c ),
          k > 0,  ( Cos[ a s ] - Cos[ b s ] Cos[ c s ] ) / ( Sin[ b s ] Sin[ c s ] ),
          k < 0,  ( Cosh[ b s ] Cosh[ c s ] - Cosh[ a s ] ) / ( Sinh[ b s ] Sinh[ c s ] ) ]
      ],
    _, Message[ InfraAngle::badmethod, OptionValue[ Method ] ]; $Failed
  ]


(* ===================== InfraMetricTensor ===================== *)

(* T[v, w] = d(p, u) / d(p, v) with u the vertex of I(p, w) closest to v; in Euclidean space clamp(cos theta, 0, |w|/|v|), on a shell max(0, cos theta) (Euclid II.12-13) *)

Options[ InfraMetricTensor ] = { "SelectCoordinate" -> Min };

InfraMetricTensor[ graph_Graph, p_, r : ( _Integer | All ) : All, OptionsPattern[] ] :=
  With[ { verts = VertexList @ graph, sel = OptionValue[ "SelectCoordinate" ] },
    { dp = GraphDistance[ graph, p ], vidx = AssociationThread[ verts, Range @ Length @ verts ] },
    { shell = If[ r === All, verts, Sort @ Pick[ verts, dp, r ] ] },
    { dS = If[ r === All, GraphDistanceMatrix @ graph, GraphDistance[ graph, # ] & /@ shell ] },
    { dpS = dp[[ Lookup[ vidx, shell ] ]] },
    Transpose @ MapThread[
      { dw, k } |-> With[ { iw = Pick[ Range @ Length @ verts, dp + dw, k ] },
        { idx = dp[[ iw ]], M = dS[[ All, iw ]] },
        { tie = 1 - Unitize[ M - Min /@ M ] },
        { tied = tie ConstantArray[ idx, Length @ tie ] },
        Switch[ sel,
          Min,  Min /@ ( tied + ( 1 - tie ) k ),
          Max,  Max /@ tied,
          Mean, Total[ tied, { 2 } ] / Total[ tie, { 2 } ],
          All,  Pick[ idx, #, 1 ] & /@ tie,
          _,    sel @ Pick[ idx, #, 1 ] & /@ tie ] ],
      { dS, dpS } ] / Clip[ dpS, { 1, Infinity } ]
  ]
