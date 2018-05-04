
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
                shape: 'box'
            },
            edges: {
                color: {color: "black"},
                //physics: true
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
}