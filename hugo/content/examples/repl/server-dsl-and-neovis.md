---
title : Server DSL and NeoVis
type: neo4j
cypher: match (a) return * limit 10
---


{{< repl-dsl height="100">}}
return new Promise (resolve)=>
    console.log await @.neo4j.nodes_Count()
    await @.neo4j.delete_all_nodes()
    await @.neo4j.add_node("NEW_LABEL3","qweaaa")
    await @.neo4j.add_node("NEW_LABEL1","qweaaa")
    console.log('after')
    console.log await @.neo4j.nodes_Count()
    resolve('all done')
{{</ repl-dsl >}}

<hr/>

{{< cypher-query height="80" autorun="false">}}

{{</ cypher-query >}}



