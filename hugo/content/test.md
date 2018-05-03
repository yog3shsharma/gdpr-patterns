---
title     : this is a test
type      : neo4j
layout    : query-in-md
#cypher    : MATCH (m)-[r]-(b) return * Limit 40
cypher    : MATCH (m:IT_System)-[r2]-(m2) RETURN * Limit 100
gravity   : -1500
root_node: 'RISK-855'
labels   :
    RISK :
        caption: key
        image : /img/osa/osa_warning.png

 #   IT_System:
 #       caption: key
 #   Data_Journey:
 #       caption: key

relationships:
 #   relates_to:
 #       color : red
 #       label : relates
 #       size  : 5
 #       arrow : true

---

This is a test for Ann-Marie
