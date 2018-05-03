
var viz;
var root_Node_Id = '{{ .Params.root_Node}}';
var cypher       = params_Data.cypher;

class neo4j_Util {

    async draw(cypher, container_id) {
        var config = {
            container_id    : container_id,
            server_url      : server_url,
            server_user     : server_user,
            server_password : server_password,
            labels          : params_Data.labels,
            relationships   : params_Data.relationships,
            initial_cypher  : cypher
        };

        viz = new NeoVis.default(config);
        viz.setup();
        await viz.render_async();

        let options = {
            nodes: {
                shape: 'box'
            },
            edges: {
                color: {color: "black"},
                physics: true
            },
            physics: {
                barnesHut: {
                    gravitationalConstant: params_Data.options.gravitationalConstant,
                    //centralGravity : 0.5
                }
            }
        }
        viz._network.setOptions(options)
    }

    run_query(value) {

        cypher = value
        //cypher = document.getElementById("cypher").value
        draw()
    }
}