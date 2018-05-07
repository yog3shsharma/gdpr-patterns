---
title     : Example - run-cypher
type      : neo4j
#cypher    : MATCH (a)-[to]-(b) return * Limit 40
#gravity   : -30000
labels    :
relationships:
---

write your own cypher queries

### Query
{{< cypher-query height="80">}}
MATCH (a)-[to]-(b)
return *
Limit 10
{{</ cypher-query >}}

{{< cypher-query autorun="no" height="80">}}
MATCH (a)-[to]-(b)
return *
Limit 40
{{</ cypher-query >}}

### Graph