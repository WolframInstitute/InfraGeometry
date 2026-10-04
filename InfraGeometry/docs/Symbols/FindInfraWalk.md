---
Template: Symbol
Name: FindInfraWalk
Context: WolframInstitute`InfraGeometry`
ContextPath: [WolframInstitute`DiscreteGeometry`]
Paclet: WolframInstitute/InfraGeometry
URI: WolframInstitute/InfraGeometry/ref/FindInfraWalk
---

## Usage

`FindInfraWalk[graph, p1, kspec]` grows the walks from p1 in the class cut by the Properties rules (default {"Simple"}) until a stopping condition or the budget kspec (UpTo[k], {k}, {lo, hi}, Infinity) stops them; FindInfraWalk[graph, p1, p2, kspec] keeps those ending at p2.

## Details & Options

Each walk is a path graph on position pairs.

Options "InfraScale", Properties, "StoppingCondition", "NextVertexFunction". The next-vertex function sees the candidate windows -- the window with one admissible candidate appended -- and gives the ones to pursue, in the order to try: Identity (default) the canonical order, RandomSample a random order, RandomChoice the random walk, MinimalBy[f] the candidates least by f[window], RandomSample[#, UpTo[n]] & a pruning to n branches per node.
