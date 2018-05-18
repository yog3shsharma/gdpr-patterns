---
title     : GDPR Data Journey
type      : neo4j
gravity   : -4000
view      : fullscreen
height    : 800
labels    :
    Data_Journey:
        caption: key
        label:  aaaa
    Security_Controls:
        caption : summary
    RISK:
        caption: key
        color: red
relationships:
    Data_touches:
        label: 123
---

GDPR mappings

{{< cypher-query height="80">}}
//MATCH path= (a:Data_Journey)-[]-(b)-[]-(c:RISK)
MATCH path= (a:Data_Journey)-[]-(b)-[]-(c)
//where a.key = "GDPR-513"
return * Limit 10


{{</ cypher-query >}}


