> ⚠️ **Experimental research code.** The language and API are actively developing.

# 📐 Infrageometry

This repository contains experimental code and a developing language for geometry emerging as an effective description of large graphs at a large observer scale, aligned with the vision of Stephen Wolfram.

![The emergent triangle: three colored InfraSegment families on Small, Medium, and Large square tessellation substrates, with interior corners and automatic graph layouts.](assets/emergent-triangle.png)

Our goal is to demonstrate how **Euclidean, Riemannian, and symplectic geometry** emerge in limits of graphs. We view a graph as a webbing of paths and seek the essence of geometry in this webbing. An essential element is an observer who determines properties of the observed geometry.

The eventual goal of infrageometry is to explain the emergence of space in hypergraph rewriting models of the universe, as described in the [Wolfram Physics Project technical introduction](https://www.wolframphysics.org/technical-introduction/). Note that hyperedges are not needed to recover the classical geometries.

## 🧩 From subdivision to aggregation

Classical geometry allows infinite subdivision at every scale. This idealization gives us thin objects, infinitesimal linearization, geometric properties stored in linear objects, and constructions in which uniqueness plays a central role. An indivisible minimal unit — an edge — instead gives us puffed objects, multi-constructions, and aggregated measurements.

The language must therefore change. We want to develop it from basic constructions and measurements, following the foundational spirit of Euclid, Riemann, and Hamilton. The aim is to deduce and design a geometric language native to graphs, and to understand when its classical counterparts emerge.

## 📏 Synthetic (Euclidean) Infrageometry

Synthetic Infrageometry studies the moduli spaces of synthetic objects on arbitrary graph substrates, their mutual positions, and constructions with them. Its goal is the emergence of configurations of idealized objects, including those of Euclidean geometry.

Without infinite subdivision, a construction need not have a unique result. We therefore work with **multi-constructions**: a fixed sequence of construction steps generates a multiway system that branches at each non-unique choice. We seek causal invariance of this construction process, with the same construction steps represented across its branches.

To each multi-object we associate a **vertex density**, given by normalized occupation counts over its possible realizations. Under suitable refinement and rescaling, we aim for these densities, interpreted as measures, to converge weakly to measures supported on classical thin objects.

## 🌐 Riemannian Infrageometry

Riemannian Infrageometry studies the graph substrate itself: the **infra-Riemannian metric** and the **emergence of linearity** at large observer scales.

Riemann described curve length in an infinitesimal webbing of paths on a manifold through a symmetric metric tensor. On a graph, we begin with measurements aggregated at a chosen observer scale: volumes of synthetic objects based at a point, distributions of distances between points, and dimension estimates from ball covering numbers or maximal orthogonal systems.

We also develop graph analogues of the **metric tensor and Levi-Civita connection**. The mathematical and experimental questions are whether, and under what assumptions, these measurements and structures converge to their continuous counterparts along sequences of graphs.

## 🌀 Symplectic Infrageometry

Symplectic Infrageometry begins with the **canonical one-form on the cotangent bundle at scale r**. Cotangent data at a point p are represented by inward-pointing rays of length r.

From this starting point, we plan to derive dynamics of paths through an action principle and study how Hamiltonian and symplectic descriptions emerge in the limit.

## 🌱 Infrafibrations

Scale-dependent infra-fiber bundles support this programme. Tangent and cotangent bundles consist of outward- and inward-oriented rays, respectively, encoded in the optimal structure of spray graphs. The displacement bundle consists of their endpoints.

We study fibrations, continuous sections, and connections at scale r, including the canonical one-form and the Levi-Civita connection.

## 🕸️ Infratopology

Infratopology studies global observer-dependent graph topology through the ball intersection complex at scale r and intersection order k. At k = 2, the pairwise-intersection condition gives the Vietoris–Rips complex; at k = ∞, the common-intersection condition gives the Čech complex of the ball covering.

## ∫ Infraanalysis

Infraanalysis develops several forms of aggregation on directed acyclic graphs (DAGs), viewed as fibered graphs over a path graph, together with corresponding derivatives satisfying a fundamental theorem of calculus. Some of these derivatives are nonlocal. This provides a calculus adapted to the same webbing of paths.

## 🔬 Testing the limits

We build minimal models on graph substrates and test their predictions by comparing measurable quantities along sequences of pointed metric measure spaces converging in the pointed measured Gromov–Hausdorff sense.

The central question is which graph constructions and observables converge to the intended geometric objects and quantities, and which assumptions on the substrates, measures, and observer scales make this possible.

## ✨ Usage

Install from the Wolfram Cloud:

```wolfram
PacletInstall["https://www.wolframcloud.com/obj/hajek_pavel/InfraGeometry.paclet", ForceVersionInstall -> True]
Needs["WolframInstitute`InfraGeometry`"]
```

Explore the [research documentation](https://www.wolframcloud.com/obj/hajek_pavel/DeployedResources/Paclet/WolframInstitute/InfraGeometry).

## ⚖️ License

Code: [MIT](https://opensource.org/license/mit). Ideas: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/).
