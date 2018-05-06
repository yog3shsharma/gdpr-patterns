---
title     : Example - Direct Data
type      : neo4j
menu      : main
cypher    : ""
height    : 300
labels    :
relationships:
---

Example of providing direct data (below)

{{< repl mode="JavaScript" height="300">}}
let vis     = neo.viz._vis
network = neo.viz._network

nodes = new vis.DataSet([
    {id: 1, label: 'Node 1'},
    {id: 2, label: 'Node 2'},
    {id: 3, label: 'Node 3'},
    {id: 4, label: 'Node 4'},
    {id: 5, label: 'Node 5'}
  ]);

edges = new vis.DataSet([
    {from: 1, to: 3},
    {from: 1, to: 2},
    {from: 2, to: 4},
    {from: 2, to: 5},
    {from: 3, to: 3}
  ]);

options = {}
network.setData({ nodes:nodes , edges: edges}, options)

{{</ repl >}}