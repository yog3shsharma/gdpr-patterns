---
title     : Simple cypher query
type      : neo4j
menu      : main
layout    : query-in-md
gravity   : -500
root_node: 'RISK-855'
labels   :
    RISK :
        caption: key
        image : /img/osa/osa_warning.png
    Risk_Service:
        shape: box
        caption: key
relationships:
---

Here are multiple queries of cypher `MATCH (a)-[to]-(b)` with different values of `Limit`



<div class='row'>

    {{< cypher id="limit_5" height="200" >}}
        MATCH (a)-[to]-(b)
        return * Limit 5
    {{</ cypher >}}


    {{< cypher id="limit_20" height="200"  >}}
        //call db.schema()
        MATCH (a)-[to]-(b)
            return * Limit 20
    {{</ cypher >}}

</div>

<div class='row'>

    {{< cypher id="limit_50" height="200" >}}
        MATCH (a)-[to]-(b)
        return * Limit 50
    {{</ cypher >}}


    {{< cypher id="limit_100" height="200" >}}
        MATCH (a)-[to]-(b)
            return * Limit 100
    {{</ cypher >}}

</div>
