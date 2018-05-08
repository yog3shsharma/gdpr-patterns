---
title     : View Jira Data
type      : neo4j
cypher    : MATCH (a)-[to]-(b) return * Limit 5
labels    :
    RISK:
        caption: key
        image  : /img/osa/osa_warning.png
    Risk_Service:
        caption: key
relationships:
---


### Query
{{< cypher-query>}}

{{</ cypher-query >}}

{{< view-jira-data >}}

### Graph
