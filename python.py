# imports
## plotly
import plotly.plotly as py
from plotly.graph_objs import Scatter, Figure, Layout
import plotly.offline as offline
from plotly import tools

## time
from datetime import date, datetime, timedelta
import calendar
from dateutil.relativedelta import relativedelta

## load, reload mudule
import importlib
importlib.reload(portval_func); from portval_func import *

# nosetest options
--all-modules -a "!slow,!aws"

# sqlalchemy 
## show full statement
showquery = lambda session, q : str(q.statement.compile(dialect=session.bind.dialect, compile_kwargs={"literal_binds": True}))
showquery(session, q)
## sqlalchemy create one table
Model.__table__.drop(session.connection())
Model.__table__.create(session.connection(), checkfirst=True) 
session.add(Model(a='a', b='b'))
## sqlalchemy column names
[c.name for c in Model.__table__.columns]

# conda enviroment
conda info
conda info -e
activate tensorflow
activate tensorflow-gpu
conda list
# note activate doesn't work in powershell, use cmd or anaconda prompt, or use this
# https://github.com/Liquidmantis/PSCondaEnvs
# update
conda update conda
conda update anaconda
conda search --outdated
conda update --all
# downgrade upgrade python, after that manually modify registry paths
conda search python
conda install python=3.5.0


# show an object
def reprobj(obj):
    print('class:\t%s\n\t' % obj.__class__ + \
               '\n\t'.join([p + '=' + str(obj.__getattribute__(p)) for p in obj.__dir__() if not p.startswith('_')]))

    
# show code of a function
func??

# dataframe to jason, back to pandas and R, orient='records' is needed
hist_cost.to_json('C:\\temp\\hist_cost.jason', orient='records')
pd.read_json('C:\\temp\\hist_cost.jason')
dplyr::rbind_all(fromJSON('C:/temp/hist_cost.jason'))

writeLines(toJSON(x), 'C:/temp/df.jason')
as.data.frame(fromJSON('C:/temp/df.jason'))
pd.read_json('C:\\temp\\hist_cost.jason')

# pycham set pandas numpy display
pd.set_option('display.width', 150)
pd.set_option('display.max_columns', 1000)
pd.set_option('display.max_rows', 20)
np.set_printoptions(linewidth=150)


# igraph, pycairo intall
# source http://www.lfd.uci.edu/~gohlke/pythonlibs/#python-igraph   
pip install .\python_igraph-0.7.1.post6-cp35-none-win_amd64.whl
# source http://www.lfd.uci.edu/~gohlke/pythonlibs/#pycairo
pip install .\pycairo-1.10.0-cp35-cp35m-win_amd64.whl


# date to datetime
pd.Timestamp(date(2014,1,1)).to_datetime()
pd.to_datetime(a.date, format='%m/%d/%Y') # format is needed, otherwise every slow


# arg parser in interactive console
import sys
command="""
C:/a.py --strategy b --pool PJM --firstday 2014-4-1 --lastday 2014-10-1 --forecast_lag 30 --netversion 1 --hist_scenario historical6 
--posfile c:/temp/6m_df.csv --valfile c:/temp/6m_df.val.csv
"""
sys.argv=command.split()


# currency to float
# https://stackoverflow.com/questions/31521526/pandas-column-convert-currency-to-float/31521773#31521773
(df['Currency'].replace('[\$,)]', '', regex=True)
               .replace('[(]', '-',   regex=True).astype(float))


# flattern multilevel column names
x1.columns = ['_'.join(col).strip() for col in x1.columns.values]


# run another py from a script
file1 = 'C:\\Users\\excel.py'
exec(compile(open(file1).read(), file1, 'exec'))


# pickle object, load pickle
import pickle
a = { "lion": "yellow", "kitty": "red" }
b = [1, 2, 3]
pickle.dump([a, b], open( "save.p", "wb" ))
a, b = pickle.load(open( "save.p", "rb" ))


# save and load all objects
# by unutbu from http://stackoverflow.com/questions/2960864/how-can-i-save-all-the-variables-in-the-current-python-session
# __builtins__, my_shelf, and imported modules can not be shelved.
my_shelf = shelve.open('debug.dat','n')  # n for new    
for key in dir():
    try: my_shelf[key] = globals()[key]
    except: pass
my_shelf.close()
# load
my_shelf = shelve.open('debug.dat')
for key in my_shelf:
    globals()[key]=my_shelf[key]
my_shelf.close()


# parallel download
from urllib.request import urlretrieve
from multiprocessing import Pool
def fetch_url(x): return urlretrieve(url=x[0], filename=x[1])
if __name__ == '__main__':
    downlist = [('http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv', '1.csv'),
                ('http://samplecsvs.s3.amazonaws.com/Sacramentorealestatetransactions.csv', '2.csv'),
                ('http://samplecsvs.s3.amazonaws.com/SalesJan2009.csv', '3.csv'),
                ('http://samplecsvs.s3.amazonaws.com/TechCrunchcontinentalUSA.csv', '4.csv')]
    res = Pool(10).map(fetch_url, downlist)
    print(res)
  
