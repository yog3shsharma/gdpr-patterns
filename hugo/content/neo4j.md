---
title   : Neo4J visualisation
type    : neo4j
layout  : simple
cypher  : MATCH (n)-[r]->(m) RETURN n,r,m Limit 5
gravity : -80
labels  :
    Data_Journey:
        caption: "key"
#    Data_Source:
#        caption: "key"
#    IT_System:
#        caption: "key"

relationships:
    Data_touches :
        caption: "key"
    Data_sources :
        caption: "key"

---

This is a Neovis graph on GDPR  (with options from defined in an
hugo markdown file )