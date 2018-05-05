---
title     : Example - Canvas Draw
type      : neo4j
menu      : main
cypher    : MATCH (a)-[to]-(b) return * Limit 40
labels    :
    RISK:
        shape: 'text'
        label: "."
        #mass: 2
relationships:
---

Here is an example of clustering nodes (click to expand)

<script>

function add_Text_To_Node(nodeId, text)
{
    let network = neo.viz._network
    ctx = neo.viz._network.canvas.getContext()
    var nodeId       = neo.nodes_Ids()[nodeId];
    var nodePosition = network.getPositions([nodeId]);
    var x            = nodePosition[nodeId].x
    var y            = nodePosition[nodeId].y
    ctx.fillText(text, x, y+20)
    ctx.strokeStyle  = '#294475';
    ctx.lineWidth    = 4;
    ctx.fillStyle    = '#A6D5F7';
    ctx.circle(x + 10, y,10);

    ctx.fill();
    ctx.stroke();
    //neo.go_to_node(0)
}

function afterLoad() {
     let network = neo.viz._network
        network.on("afterDrawing", function (ctx) {
            add_Text_To_Node(0,"this is new text", ctx)
            add_Text_To_Node(1,"node 1t", ctx)
        })

}
</script>