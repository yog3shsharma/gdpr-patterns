---
title   : Neo4J visualisation
type    : neo4j
layout  : simple
cypher  : MATCH (n)-[r]->(m) RETURN n,r,m Limit 30
gravity : -8000
labels  :
    Data_Journey:
        mass   : 3
        caption: key
        shape  : square
        #size   : 10
    Data_Source:
        #mass   : 1
        caption: key
        shape  : box
        color   : "#FFA807"
        #size   : 10
    IT_System:
        #mass    : 0.5
    RISK:
        caption : "key"
        label   : "an risk"
        shape   : triangle
        #size    : 10
        color   : red

relationships:

    Data_touches :
        caption  : key
        size     : 1
    Data_sources :
        size     : 5
        color    : green
        dashes   : true
        arrow    : true
    Missing_High:
        label    : "RISK"
        size     : 2
        color    : red
        arrow    : true
        dashes   : true


---

This is a Neovis graph on GDPR  (with options from defined in an
hugo markdown file )