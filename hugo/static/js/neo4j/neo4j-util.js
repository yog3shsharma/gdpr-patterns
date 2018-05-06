
var viz;
var root_Node_Id = '{{ .Params.root_Node}}';
var cypher       = params_Data.cypher;

class neo4j_Util {
    constructor() {
        this.viz = null
    }


    async draw(values) {
        let self = this;
        var config = {
            container_id    : values.id,
            server_url      : server_url,
            server_user     : server_user,
            server_password : server_password,
            labels          : params_Data.labels,
            relationships   : params_Data.relationships,
            initial_cypher  : values.cypher,
            layout          : values.layout
        };

        self.viz = new NeoVis.default(config);
        self.viz.setup();
        await self.viz.render_async();

        let options = {
            nodes: {
                shape: 'box',
            },
            edges: {
                //color: {color: "black"},
                //physics: true
            },
            interaction: {
                //navigationButtons: true,
                //keyboard: true
            },
            // physics: {
            //     barnesHut: {
            //         gravitationalConstant: params_Data.options.gravitationalConstant,
            //         //centralGravity : 0.5
            //     }
            // }
        }
        self.viz._network.setOptions(options)

        self.setLayout(config.layout)
    }

    setLayout(layout) {
        let self = this;
        if (layout === 'hierarchical')
        {
            let options = {
                layout: {
                    hierarchical: {
                        direction: "UD",
                        sortMethod: "directed"
                    }
                }
            }
            self.viz._network.setOptions(options)
        }

    }

    run_query(value) {

        cypher = value
        //cypher = document.getElementById("cypher").value
        draw()
    }

    nodes_Ids () {
        return Object.keys(neo.viz._nodes);
    }

    // these are experiment methods for the examples
    cluster_By_Group(name) {
        //new Promise()
        let network = neo.viz._network
        var clusterOptionsByData = {
            joinCondition:function(childOptions) {
                return childOptions.group == name;
            },
            clusterNodeProperties: {id:'cidCluster', borderWidth:3, shape:'circle', label:name}
        };
        neo.viz._network.cluster(clusterOptionsByData);


        network.on("selectNode", function(params) {
            console.log(params)
            if (params.nodes.length == 1) {
                if (network.isCluster(params.nodes[0]) == true) {
                    network.openCluster(params.nodes[0]);
                }
            }
        });
    }

    go_to_node (nodeId, speed) {

        let network = neo.viz._network
        var options = {
            scale: 1.0,
            offset: {x:0,y:0},
            animation: {
                duration: speed ? speed : 1000,
                easingFunction: "easeInOutQuad"
            }
        };

        if( ! neo.viz._nodes[nodeId])
            nodeId = this.nodes_Ids()[nodeId]

        network.selectNodes([nodeId])
        network.focus(nodeId, options)
        return new Promise( resolve =>{
            network.once('animationFinished', function() {
                resolve()
            })
        })
    }

}