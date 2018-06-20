import requests

#server="10.8.0.17"
server="http://localhost:3000"
#server="http://ec2-35-177-200-108.eu-west-2.compute.amazonaws.com:9004"

# REMOVE DB
r = requests.get(server + "/api/neo4j/delete/all?pretty")
print "0,", r.status_code


#r = requests.get( server + "/api/admin/git/clone",  timeout=60)
#print "6,", r.status_code

r = requests.get( server + "/api/admin/git/pull",  timeout=60)
print "7,", r.status_code

r = requests.get( server + "/api/neo4j/nodes/create-regex/VULN-?pretty", timeout=60)
print "8,", r.status_code

try:
    r = requests.get(server + "/api/neo4j/nodes/create-regex/TM-?pretty", timeout=60)
    print "12,", r.status_code
except:
    print "12, "

try:
    r = requests.get( server + "/api/neo4j/nodes/create-regex/RISK-?pretty", timeout=60)
    print "11,", r.status_code
except:
    print "11, "

try:
    r = requests.get( server + "/api/neo4j/nodes/create-regex/GDPR-?pretty", timeout=60)
    print "10,", r.status_code
except:
    print "10, "

try:
    r = requests.get(server + "/api/neo4j/nodes/create-regex/SEC-?pretty", timeout=60)
    print "9,", r.status_code
except:
    print "9, "

try:
    r = requests.get(server + "/api/neo4j/nodes/create-regex/SYS-?pretty", timeout=60)
    print "9.sys,", r.status_code
except:
    print "9.sys, "
