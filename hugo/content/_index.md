---
title: home page
menu: home
---
<base target="_blank">

This is the home page


## API

Here are some working API links (will work when acessing this site via the proxy)

#### Neo4J


 - [match (n) return n](/api/neo4j/cypher?pretty&query=match+(n)+return+n)
 - [match (n:Movie) return n](/api/neo4j/cypher?pretty&query=match (n:Movie) return n)
 - [create node](/api/neo4j/create/ABCAAA?a=123)
 - [create nodes for issue](/api/neo4j/nodes/create/GDPR-223') (GDPR-223)
 - [create nodes using regex](/api/neo4j/nodes/create-regex/GDPR-22?pretty) (GDPR-22)

**reset db**

 - [delete all nodes](/api/neo4j/delete/all?pretty)

#### Issues

 - [all ids](/api/jira/issues/ids)
 - [id:files](/api/jira/issues/files)
 - [RISK-1](/api/jira/issue/RISK-1?pretty)
 - [Fields Schema](/api/jira/fields/schema)

#### Debug

 - [ping](/api/debug/ping)
