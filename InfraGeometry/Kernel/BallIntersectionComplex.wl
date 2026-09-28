Package["WolframInstitute`InfraGeometry`"]


(*** Order-k ball-intersection complexes (Vietoris-Rips <-> Cech) ***)

(* Convention: closed balls B(x, r), equal radii. Two meet iff d(x_i, x_j) <= 2 r,
   so BallIntersectionComplex[data, r, 2] = VietorisRipsComplex[data, 2 r]. For equal
   radii a common intersection point exists iff the smallest enclosing ball of the
   centres has radius <= r, so the Cech filtration value is the miniball radius. *)

(* radius of the smallest ball containing the points *)
MiniballRadius[pts_List] := BoundingRegion[N @ pts, "MinBall"][[2]]

(* sigma admitted iff every k-subset of its balls has a common point;
   k = 2 is Vietoris-Rips (pairwise), k = Infinity is Cech (full nerve). *)
Options[BallIntersectionComplex] = {"Metric" -> Automatic, "IntersectionTest" -> Automatic, "MaxDimension" -> Infinity};
BallIntersectionComplex[data_List, r_ ? NumericQ, k : (_Integer | Infinity) : Infinity, OptionsPattern[]] :=
    Module[
        {n = Length[data], metric, itest, maxDim, rows, radius, qualify, admitted, prev, prevQ, m, cands},
        metric = Replace[OptionValue["Metric"], Automatic -> EuclideanDistance];
        itest = OptionValue["IntersectionTest"];
        maxDim = OptionValue["MaxDimension"];
        (* on a graph a common point may be any vertex, so the rows range over V while the columns track the centres *)
        rows = Which[
            metric === EuclideanDistance, None,
            GraphQ[metric], GraphDistanceMatrix[metric][[ Flatten[FirstPosition[VertexList[metric], #] & /@ data] ]],
            MatrixQ[metric], metric,
            True, Outer[metric, data, data, 1]
        ];
        radius = Which[
            metric === EuclideanDistance, s |-> MiniballRadius[data[[s]]],
            GraphQ[metric], s |-> Min[Max /@ Transpose[rows[[s]]]],
            True, s |-> Min[Max /@ rows[[All, s]]]
        ];
        qualify = If[itest === Automatic,
            s |-> radius[s] <= r,
            s |-> TrueQ[itest[RegionIntersection @@ (Ball[data[[#]], r] & /@ s)]]
        ];
        admitted = {List /@ Range[n]};
        m = 2;
        While[Last[admitted] =!= {} && m <= maxDim + 1,
            prev = Last[admitted];
            prevQ = AssociationThread[prev -> True];
            cands = DeleteDuplicates @ Map[Sort,
                Catenate[(s |-> (Append[s, #] & /@ Complement[Range[n], s])) /@ prev]
            ];
            cands = Select[cands, AllTrue[Subsets[#, {m - 1}], KeyExistsQ[prevQ, #] &] &];
            AppendTo[admitted, If[m <= k, Select[cands, qualify], cands]];
            m++
        ];
        Catenate[admitted]
    ]

(* the nerve: a simplex iff all its balls share a common point *)
CechComplex[data_List, r_ ? NumericQ, opts : OptionsPattern[BallIntersectionComplex]] :=
    BallIntersectionComplex[data, r, Infinity, opts]

(* birth radius of sigma in C^(k): max miniball over its k-subsets (its own
   miniball when |sigma| <= k), monotone under faces. *)
Options[BallIntersectionFiltrationValue] = {"Metric" -> Automatic};
BallIntersectionFiltrationValue[data_List, sigma_List, k : (_Integer | Infinity) : Infinity, OptionsPattern[]] :=
    With[
        {metric = Replace[OptionValue["Metric"], Automatic -> EuclideanDistance]},
        {rows = Which[
            metric === EuclideanDistance, None,
            GraphQ[metric], GraphDistanceMatrix[metric][[ Flatten[FirstPosition[VertexList[metric], #] & /@ data] ]],
            MatrixQ[metric], metric,
            True, Outer[metric, data, data, 1]
        ]},
        {radius = Which[
            metric === EuclideanDistance, s |-> MiniballRadius[data[[s]]],
            GraphQ[metric], s |-> Min[Max /@ Transpose[rows[[s]]]],
            True, s |-> Min[Max /@ rows[[All, s]]]
        ]},
        If[Length[sigma] <= k, radius[sigma], Max[radius /@ Subsets[sigma, {k}]]]
    ]

(* association r -> C^(k)_r over the (sorted) radii, ready for PersistenceIntervals *)
BallIntersectionFiltration[data_List, radii : {__ ? NumericQ}, k : (_Integer | Infinity) : Infinity, opts : OptionsPattern[BallIntersectionComplex]] :=
    With[{rs = Sort[radii]}, AssociationThread[rs -> (BallIntersectionComplex[data, #, k, opts] & /@ rs)]]

CechFiltration[data_List, radii : {__ ? NumericQ}, opts : OptionsPattern[BallIntersectionComplex]] :=
    BallIntersectionFiltration[data, radii, Infinity, opts]

(* the (r, k) object: association k -> (association r -> complex). For fixed r the
   nesting C^(k) contains C^(k+1) runs as k grows, saturating to Cech at k = d + 1
   (Helly) when the balls are convex. *)
BallIntersectionBifiltration[data_List, radii : {__ ? NumericQ}, orders : {__}, opts : OptionsPattern[BallIntersectionComplex]] :=
    AssociationMap[BallIntersectionFiltration[data, radii, #, opts] &, orders]

(* index-keyed data associations *)
BallIntersectionComplex[data_Association, r_, k : (_Integer | Infinity) : Infinity, opts : OptionsPattern[]] := BallIntersectionComplex[Values[data], r, k, opts]
CechComplex[data_Association, r_, opts : OptionsPattern[]] := CechComplex[Values[data], r, opts]
BallIntersectionFiltration[data_Association, radii_List, k : (_Integer | Infinity) : Infinity, opts : OptionsPattern[]] := BallIntersectionFiltration[Values[data], radii, k, opts]
