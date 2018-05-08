---
title     : View Jira Data
type      : neo4j
layout    : with-jira-view
cypher    : MATCH (a)-[to]-(b) return * Limit 20
menu      : main
weight    : 10
labels    :
    RISK:
        caption: key
        image  : /img/osa/osa_warning.png
    Risk_Service:
        caption: key
    Data_Journey:
        caption: key
    Security_Controls:
        caption: key
relationships:
---



{{< cypher-query>}}
{{</ cypher-query >}}

### legend:

{{< img src="/img/osa/osa_warning.png" height="20" >}} RISK

