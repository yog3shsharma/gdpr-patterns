import json
import time
import requests

#server="10.8.0.17"
server="localhost"

# REMOVE DB
r = requests.get("http://" + server + ":3000/api/neo4j/delete/all?pretty")
print "0,", r.status_code

# REMOVE JIRA
r = requests.delete("http://" + server + ":3000/api/admin/datafolder")
print "0,", r.status_code


while True:
    r = requests.get("http://" + server + ":3000/api/admin/countfiles")
    requestMaded=False
    if r.status_code==200:
        data = json.loads(r.content)
        if data['files']>8501:
            print 'JIRA tickets: ' + str(data['files'])
            break
        elif data['files']<=10:
            if requestMaded==False:
                r = requests.get( "http://" + server + ":3000/api/jira-server/all_issues?jql=project=GDPR%20%20or%20project%20=%20TM%20OR%20project%20=%20SEC%20or%20project%20=%20RISK%20or%20project%20=%20VULN")
                print r.status_code
                requestMaded=True
            time.sleep(3)
        else:
            print 'Waiting JIRA download: ' + str(data['files'])
            time.sleep(3)


r = requests.get("http://" + server + ":3000/api/jira-server/setup?pretty")
print "1,", r.status_code


r = requests.get("http://" + server + ":3000/api/jira-server/issue/RISK-2?pretty")
print "2,", r.status_code

r = requests.get("http://" + server + ":3000/api/jira-server/track-queries/create/open-projects?jql=project=SEC%20and%20issuetype%20=Project%20and%20status%20=%20Open")
print "3,", r.status_code

r = requests.get("http://" + server + ":3000/api/jira-server/track-queries/update/open-projects")
print "4,", r.status_code

r = requests.get("http://" + server + ":3000/api/jira-server/mappings/issues/files?pretty")
print "5,", r.status_code

r = requests.get("http://" + server + ":3000/api/jira-server/mappings/create?pretty")
print "6,", r.status_code

r = requests.get("http://" + server + ":3000/api/jira/fields/schema?pretty")
print "7,", r.status_code

for x in range(1, 2):
    print "Round: ", x
    try:
        r = requests.get("http://" + server + ":3000/api/neo4j/nodes/create-regex/VULN-?pretty", timeout=30)
        print "8,", r.status_code
    except:
        print "8, "

    try:
        r = requests.get("http://" + server + ":3000/api/neo4j/nodes/create-regex/SEC-?pretty", timeout=30)
        print "9,", r.status_code
    except:
        print "9, "

    try:
        r = requests.get("http://" + server + ":3000/api/neo4j/nodes/create-regex/GDPR-?pretty", timeout=30)
        print "10,", r.status_code
    except:
        print "10, "

    try:
        r = requests.get("http://" + server + ":3000/api/neo4j/nodes/create-regex/RISK-?pretty", timeout=30)
        print "11,", r.status_code
    except:
        print "11, "

    try:
        r = requests.get("http://" + server + ":3000/api/neo4j/nodes/create-regex/TM-?pretty", timeout=30)
        print "12,", r.status_code
    except:
        print "12, "

