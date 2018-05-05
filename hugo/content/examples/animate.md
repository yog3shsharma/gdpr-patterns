---
title     : Example - Animate
type      : neo4j
menu      : main
cypher    : MATCH (a)-[to]-(b) return * Limit 40
labels    :
relationships:
---

Here is an example of animating nodes movements

<script>

function afterLoad() {
    neo.viz._network.on('stabilized' , async function ()
    {
        for (i = 0; i < 5; i++)
        {
            //neo.viz._network.fit()  // will reset view
            await neo.go_to_node(i)
        }

    });
}
</script>