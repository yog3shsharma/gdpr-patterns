---
title     : by Risk Owner
type      : neo4j
#gravity   : -4000
view      : fullscreen
height    : 300
labels    :
    Risk_Owners:
        caption: key
        size   : 40
        mass: 3
    Critical:
        caption: key
        color : darkred
        size: 1
        mass: 2
    High:
        caption: key
        color : red
        size: 10
        mass: 2
    Medium:
        caption: key
        color : Orange
        size: 7
        mass: 1
    Low:
        caption: key
        color : LightBlue
        size: 3
        mass: 0.5
    To_be_determined:
        caption: key
        color : Gray
        size: 1

relationships:
    owns_risk:
        label:
---

Risks mapped to owners:
{{< repl-dsl height="100" autorun="no">}}
return new Promise (resolve)=>
    await @.neo4j_Import.clear()
    result = await @.neo4j_Import.all_Issues_by_Filter('RISK','Risk Rating', 'risk_Owners')
    resolve result

{{</ repl-dsl >}}

{{< cypher-query height="40">}}
MATCH path=(a)-[to]-(b) return path Limit 50

{{</ cypher-query >}}


