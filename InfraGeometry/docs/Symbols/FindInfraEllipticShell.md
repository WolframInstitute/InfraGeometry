---
Template: Symbol
Name: FindInfraEllipticShell
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraEllipticShell
---

## Usage

`FindInfraEllipticShell[graph, {p1, p2}, c]` returns {InfraEllipticShell[{levelSet}]} for the elliptic shell { v : d(p1,v) + d(p2,v) == c } (c may be {cMin, cMax}).

`FindInfraEllipticShell[graph, {p1, p2}, c, n]` returns exactly n or $Failed; UpTo[n] returns up to n; All returns all. Under the default Properties -> {} the level set is the one realisation; under {"Separating"} the count-less call is one minimal separating subset.

## Details & Options

Options:

| Option | Values |
|---|---|
| `Properties` | "Separating", "Connected" |
| `"NextVertexFunction"` | `Identity` (default), `RandomSample`, `RandomSample[#, UpTo[n]] &`, any function | the function sees the vertices that can be peeled next and gives the ones to try, in order: `Identity` the canonical peel, so the count-less call is one minimal subset, deterministic; `RandomSample` a random peel under an ambient `SeedRandom`; `RandomSample[#, UpTo[n]] &` at most *n* branches per node. The class is the same under every value |
