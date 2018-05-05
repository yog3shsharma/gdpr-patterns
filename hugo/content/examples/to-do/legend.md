---
title     : Example - Legend (to do)
type      : neo4j
menu      : main
cypher    : MATCH (a)-[to]-(b) return * Limit 40
layout    : hierarchical
labels    :
relationships:
---

Here is an example of adding a Legend to the graph

<div class="badge badge-success">TODO</div>
 (see http://visjs.org/examples/network/exampleApplications/nodeLegend.html for a working example)

```
      nodes.push({id: 1000, x: x, y: y, label: 'Internet', group: 'internet', value: 1, fixed: true, physics:false});
      nodes.push({id: 1001, x: x, y: y + step, label: 'Switch', group: 'switch', value: 1, fixed: true,  physics:false});
      nodes.push({id: 1002, x: x, y: y + 2 * step, label: 'Server', group: 'server', value: 1, fixed: true,  physics:false});
      nodes.push({id: 1003, x: x, y: y + 3 * step, label: 'Computer', group: 'desktop', value: 1, fixed: true,  physics:false});
      nodes.push({id: 1004, x: x, y: y + 4 * step, label: 'Smartphone', group: 'mobile', value: 1, fixed: true,  physics:false});
```

here is how to control the colors of the groups

```
        groups: {
          'switch': {
            shape: 'triangle',
            color: '#FF9900' // orange
          },
          desktop: {
            shape: 'dot',
            color: "#2B7CE9" // blue
          },
          mobile: {
            shape: 'dot',
            color: "#5A1E5C" // purple
          },
          server: {
            shape: 'square',
            color: "#C5000B" // red
          },
          internet: {
            shape: 'square',
            color: "#109618" // green
          }
```