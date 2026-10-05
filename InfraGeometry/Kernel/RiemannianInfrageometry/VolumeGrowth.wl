Package[ "WolframInstitute`InfraGeometry`" ]

LogDifferenceQuotients[ w_List ] :=
  Log[ Ratios[ Range[ Length[ w ] ] ], Ratios[ N[ w ] ] ]

(* the Bishop-Gromov regression of the log-difference quotient q(r) on x = r (r + 1), the squared geometric-mean radius, for two probes:
     the ball,   V(r) the measure of B_r(v):                    q -> d - R/(3 (d + 2)) x,  so R = -3 (d + 2) slope;
     the sphere, A(r) the counting measure of the shell S_r(v): q -> (n - 1) - S/(3 n) x,  so n = intercept + 1, S = -3 n slope
   (Gray: Area(S_r) = sigma_(n-1) r^(n-1) (1 - S/(6 n) r^2)).  The per-radius curvatures compare with the Euclidean ball and sphere,
   R(v, r) = 6 (d + 2)/r^2 (1 - V(r)/V_E(d, r)) and S(v, r) = 6 n/r^2 (1 - A(r)/A_E(n, r)); the mean curvature d Log A/dr is the
   Raychaudhuri expansion.  The Automatic window is the longest one whose least-squares residual stays within twice the noise floor,
   the sphere window capped at the peak of A(r), which falls on a finite graph *)

Options[ VolumeGrowthObservables ] = { "Measure" -> "RiemannianMeasure", "Dimension" -> Automatic }

VolumeGrowthObservables[ g_Graph, opts : OptionsPattern[] ] :=
  VolumeGrowthObservables[ g, All, Automatic, opts ]

VolumeGrowthObservables[ g_Graph, vertices : Except[ _Rule | _RuleDelayed ],
    window : ( { _Integer, _Integer } | All | Automatic ) : Automatic, opts : OptionsPattern[] ] /;
    MatchQ[ OptionValue[ VolumeGrowthObservables, { opts }, "Measure" ], "CountingMeasure" | "RiemannianMeasure" ] :=
  With[ {
      listed = vertices === All || ListQ[ vertices ] && ! MemberQ[ VertexList @ g, vertices ],
      measure = OptionValue[ "Measure" ],
      dimOpt = OptionValue[ "Dimension" ],
      radialQuotients = f |-> Table[ ( Log[ N @ f[[ r + 2 ]] ] - Log[ N @ f[[ r + 1 ]] ] ) / ( Log[ r + 1. ] - Log[ r ] ),
        { r, 1, Length @ f - 2 } ] },
    { windowedFit = { q, probe } |-> With[ { r = Range @ Length @ q, x = N[ Range[ Length @ q ] ( Range[ Length @ q ] + 1 ) ] },
        { sel = Which[
            window === All,  r,
            ListQ @ window,  Select[ r, window[[ 1 ]] <= # <= window[[ 2 ]] & ],
            Length @ q < 5,  r,
            True,            Range @@ With[ { qc = Replace[ q, Around[ m_, _ ] :> m, { 1 } ], k = Length @ q, k0 = 5 },
              { sx = Prepend[ Accumulate @ x, 0. ], sxx = Prepend[ Accumulate[ x^2 ], 0. ],
                sq = Prepend[ Accumulate @ qc, 0. ], sqq = Prepend[ Accumulate[ qc^2 ], 0. ], sxq = Prepend[ Accumulate[ x qc ], 0. ] },
              { rse = { i, j } |-> With[ {
                    m = N[ j - i + 1 ],
                    ax = sx[[ j + 1 ]] - sx[[ i ]], axx = sxx[[ j + 1 ]] - sxx[[ i ]],
                    aq = sq[[ j + 1 ]] - sq[[ i ]], aqq = sqq[[ j + 1 ]] - sqq[[ i ]], axq = sxq[[ j + 1 ]] - sxq[[ i ]] },
                  { b = ( m axq - ax aq ) / ( m axx - ax^2 ) },
                  Sqrt[ Max[ aqq - ( aq - b ax ) aq / m - b axq, 0. ] / ( m - 2 ) ] ] },
              { tol = Max[ 2 Quantile[ Table[ rse[ i, i + k0 - 1 ], { i, 1, k - k0 + 1 } ], 1/4 ], 1.*^-10 ] },
              SelectFirst[
                Catenate @ Table[ { i, i + len - 1 }, { len, k, k0, -1 }, { i, 1, k - len + 1 } ],
                p |-> rse[ p[[ 1 ]], p[[ 2 ]] ] <= tol,
                { 1, k } ] ] ] },
        Append[
          DimensionCurvatureFit[ Transpose[ { r[[ sel ]], q[[ sel ]] } ], "Probe" -> probe, "Dimension" -> dimOpt ],
          "Window" -> MinMax @ r[[ sel ]] ] ] },
    { vs = If[ listed, Replace[ vertices, All :> VertexList @ g ], { vertices } ] },
    { radii = Range[ 0, VertexEccentricity[ g, # ] ] & /@ vs },
    { ws = TakeList[ InfraMeasurement[ g, Catenate @ MapThread[ { v, rs } |-> InfraBall[ v, # ] & /@ rs, { vs, radii } ], measure ],
        Length /@ radii ],
      as = TakeList[ InfraMeasurement[ g, Catenate @ MapThread[ { v, rs } |-> InfraShell[ v, # ] & /@ rs, { vs, radii } ], "CountingMeasure" ],
        Length /@ radii ] },
    { fits = MapThread[
        { w, a } |-> With[
          { peak = If[ window === Automatic, First @ Ordering[ a, -1 ], Length @ a ] },
          { ballFit = windowedFit[ radialQuotients @ Take[ w, UpTo[ peak ] ], "Ball" ],
            sphFit = windowedFit[ radialQuotients @ Take[ a, peak ], "Sphere" ] },
          { bd = ballFit[ "Dimension" ], sd = sphFit[ "Dimension" ] },
          <|
            "BallVolumes"                  -> w,
            "ShellAreas"                   -> a,
            "BallLogDifferenceQuotients"   -> radialQuotients @ w,
            "SphereLogDifferenceQuotients" -> radialQuotients @ a,
            "BallDimension"                -> bd,
            "SphereDimension"              -> sd,
            "BallScalarCurvature"          -> ballFit[ "ScalarCurvature" ],
            "SphereScalarCurvature"        -> sphFit[ "ScalarCurvature" ],
            "BallCurvatureByRadius"        ->
              Table[ N[ 6 ( bd + 2 ) / r^2 ( 1 - w[[ r + 1 ]] Gamma[ bd / 2 + 1 ] / ( Pi^( bd / 2 ) r^bd ) ) ], { r, 1, Length @ w - 1 } ],
            "SphereCurvatureByRadius"      ->
              Table[ N[ 6 sd / r^2 ( 1 - a[[ r + 1 ]] Gamma[ sd / 2 + 1 ] / ( sd Pi^( sd / 2 ) r^( sd - 1 ) ) ) ], { r, 1, Length @ a - 1 } ],
            "SphereMeanCurvatureByRadius"  -> Differences @ Log @ N @ a,
            "BallWindow"                   -> ballFit[ "Window" ],
            "SphereWindow"                 -> sphFit[ "Window" ] |> ],
        { ws, as } ] },
    If[ listed, fits, First @ fits ] ]

(* DimensionCurvatureFit[{{r, q(r)}, ...}]: fit dimension d and scalar curvature R to log-difference
   quotients q(r) (each the discrete d Log f / d Log r at radius r) by Bishop-Gromov regression on
   x = r (r+1) -- the squared geometric-mean radius Sqrt[r(r+1)] at which a finite difference quotient
   lives.  DimensionCurvatureFit[{q(0), q(1), ...}] takes a bare quotient list at radii 0, 1, 2, ....
   probe table (dimension = intercept + shift, curvature factor = intercept + offset):
     "Ball"       (V ~ r^d,      shift 0, offset 2):  R = -3(d+2) slope;
     "Sphere"     (A ~ r^(d-1),  shift 1, offset 1):  R = -3 d slope;
     "Tube"       (T ~ s^(d-1),  shift 1, offset 2):  tau + Ric(v,v) = -3(d+1) slope (Gray);
     "TubeMantle" (dT ~ s^(d-2), shift 2, offset 1):  tau + Ric(v,v) = -3(d-1) slope.
   For the tube probes "ScalarCurvature" holds the tube reading tau + Ric(v,v), the Ricci
   projection plus the scalar; subtract a same-window ball tau to isolate Ric(v,v).
   Fits every supplied point (the caller windows by slicing the quotients); the fit uses
   closed-form normal equations (not LeastSquares) so Around-valued quotients carry their
   spread to Around dimension and curvature.  The caller supplies the quotients, so the
   convention is its choice: LogDifferenceQuotients (index-based) of a counting-measure profile,
   the radius-consistent quotients VolumeGrowthObservables takes of a Riemannian-measure profile, ... *)

Options[ DimensionCurvatureFit ] = { "Probe" -> "Ball", "Dimension" -> Automatic }

DimensionCurvatureFit[ q : { Except[ _List ] .. }, opts : OptionsPattern[] ] :=
	DimensionCurvatureFit[ Transpose[ { Range[ 0, Length[ q ] - 1 ], q } ], opts ]

DimensionCurvatureFit[ data : { { _, _ } .. }, OptionsPattern[] ] :=
  With[
  	{ probe = OptionValue[ "Probe" ], dimOpt = OptionValue[ "Dimension" ] },
  	{ shift = Switch[ probe, "Ball", 0, "Sphere" | "Tube", 1, "TubeMantle", 2 ],
  	 offset = Switch[ probe, "Ball" | "Tube", 2, "Sphere" | "TubeMantle", 1 ],
  	 x = N[ data[[ All, 1 ]] (data[[ All, 1 ]] + 1) ], q = data[[ All, 2 ]] },
  	{ dimScalar = If[ dimOpt === Automatic,
  		With[ { m = Length[ x ], sx = Total[ x ], sxx = Total[ x^2 ], sq = Total[ q ], sxq = Total[ x q ] },
  			{ den = m sxx - sx^2 },
  			{ c2 = (m sxq - sx sq) / den, c1 = (sxx sq - sx sxq) / den },
  			{ c1 + shift, -3 (c1 + offset) c2 }
  		],
  		With[ { sx = Total[ x ], sxx = Total[ x^2 ], sxq = Total[ x q ] },
  			{ slope = (sxq - (dimOpt - shift) sx) / sxx },
  			{ N[ dimOpt ], -3 (dimOpt - shift + offset) slope }
  		]
  	] },
  	<| "Dimension" -> dimScalar[[ 1 ]], "ScalarCurvature" -> dimScalar[[ 2 ]] |>
  ]
