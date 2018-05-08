---
title     : List of Risks
type      : neo4j
cypher    : MATCH (a)-[to]-(b) return * Limit 50
#cypher    : "MATCH (a {key : 'RISK-221'})-[to:is_parent_of*0..5]-(b) return * Limit 50"
#height    : 100
#width     : 100
#layout    : hierarchical
labels    :
    RISK:
        caption: key
        image  : /img/osa/osa_warning.png
    Risk_Service:
        caption: key
relationships:
---

Here are all the risk

{{< cypher-query height="80">}}

{{</ cypher-query >}}