# http://www.pjm.com/~/media/etools/data-miner-2/data-miner-2-api-guide.ashx
# curl
# curl --compressed
# "https://api.pjm.com/api/v1/da_hrl_lmps?download=true&rowCount=1500&sort=
# datetime_beginning_ept&order=Asc&startRow=1&datetime_beginning_ept=9/1/2016 00:00to10/31/2016
# 23:00&pnode_id=48592&subscription-key=<yourkeyhere>" -o C:\<yourpath here>
    
import http.client, urllib.request, urllib.parse, urllib.error, base64
headers = {'Ocp-Apim-Subscription-Key': '<key>', 'content-type' : 'application/xml'}
params = urllib.parse.urlencode({})
try:
    conn = http.client.HTTPSConnection('api.pjm.com')
    conn.request("GET", "/api/v1/act_sch_interchange/metadata?%s" % params, "{body}", headers)
    response = conn.getresponse()
    print(response.status, response.reason)
    data = response.read()
    conn.close()
    file = open('output.txt', 'wb')
    file.write(data)
    file.close()
    print("Go to output.txt")
except Exception as e:
    print("[Errno {0}] {1}".format(e.errno, e.strerror))
