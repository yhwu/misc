# http://www.pjm.com/~/media/etools/data-miner-2/data-miner-2-api-guide.ashx
import configparser
import gzip
import http.client
import os
import urllib.error

import pandas as pd
pd.set_option('display.width', 150)

headers = {'Ocp-Apim-Subscription-Key': '{subscription key}'}

inifile = os.getenv('CONFIG')
config = configparser.ConfigParser()
config.read(inifile)
headers['Ocp-Apim-Subscription-Key'] = config.get('pjmdataminer2', 'key')

params = urllib.parse.urlencode({
    'download': True,
    'rowCount': 50000,
    'startRow': 1,
    'datetime_beginning_ept': '2018-05-13 00:00',
    'type': 'ZONE; RESIDUAL_METERED_EDC',
    'row_is_current': True,
})

try:
    conn = http.client.HTTPSConnection('api.pjm.com')
    conn.request(method="GET", url="/api/v1/da_hrl_lmps?%s" % params, body=None, headers=headers)
    response = conn.getresponse()
    data = response.read()
    conn.close()
    if response.getheader(name='Content-Encoding') == 'gzip':
        r = gzip.decompress(data)
        df = pd.read_json(r)
    else:
        df = pd.read_json(data)
except Exception as e:
    print("[Errno {0}] {1}".format(e.errno, e.strerror))

print(df)
