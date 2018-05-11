---
title     : Accepted Risks
type      : neo4j
labels    :
    RISK:
        caption: key
        image  : /img/osa/osa_warning.png
    Risk_Service:
        caption: key
    ISSUE:
        caption: key
    Summary:
        caption: key
        shape  : box
    Risk_Owner:
        caption: key
        mass: 4
    Risk_Rating:
        caption: key
relationships:
---



{{< cypher-query height="80">}}
MATCH (a)-[to]-(b:Risk_Owner)
where a.status = "Risk Approved" return *
{{</ cypher-query >}}