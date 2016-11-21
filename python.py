# sqlalchemy show full statement
showquery = lambda session, q : str(q.statement.compile(dialect=session.bind.dialect, compile_kwargs={"literal_binds": True}))
showquery(session, q)


# update
conda update conda
conda update anaconda


# show an object
def reprobj(obj):
    print('class:\t%s\n\t' % obj.__class__ + \
               '\n\t'.join([p + '=' + str(obj.__getattribute__(p)) for p in obj.__dir__() if not p.startswith('_')]))

    
# tricky behaviours
1. sum of NaN is 0 by default
nn = pd.DataFrame({
    'a' : [np.nan] * 10,
    'b' : [np.nan] * 10
})
nn.sum()
Out[81]: 
a    0.0
b    0.0
dtype: float64
In[83]: nn.sum(skipna=False)
Out[83]: 
a   NaN
b   NaN
dtype: float64

# show code of a function
func??

# dataframe to jason, back to pandas and R, orient='records' is needed
hist_cost.to_json('C:\\temp\\hist_cost.jason', orient='records')
pd.read_json('C:\\temp\\hist_cost.jason')
dplyr::rbind_all(fromJSON('C:/temp/hist_cost.jason'))

writeLines(toJSON(x), 'C:/temp/df.jason')
as.data.frame(fromJSON('C:/temp/df.jason'))
pd.read_json('C:\\temp\\hist_cost.jason')

# pycham set pandas display.width
pd.set_option('display.width', 150)
pd.set_option('display.max_columns', 1000)
pd.set_option('display.max_rows', 20)


# pycham set numpy display.width
np.set_printoptions(linewidth=150)


# date to datetime
pd.Timestamp(date(2014,1,1)).to_datetime()


# index, reference to multiindexed pandas dataframe
idx = CC_diff.loc[~CC_diff.CC2].index[0] #idx = ('CIN.GIBSON.5', 'HE.RATTS1'), an index of an indexed pd
needed = ['source', 'sink', 'avg_congestion', 'CC1', 'CC2', 'CC3']
analysis[needed].set_index(keys=['source', 'sink']).loc[idx]
analysis[needed].set_index(keys=['source', 'sink']).loc[('CIN.GIBSON.5', 'HE.RATTS1')]
analysis[needed].set_index(keys=['source', 'sink']).loc[0] # wrong
analysis[needed].set_index(keys=['source', 'sink'])[0]     # wrong
analysis[needed].set_index(keys=['source', 'sink'])['CC1'] # works, upmost level index


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


# run another py from a script
file1 = 'C:\\Users\\excel.py'
exec(compile(open(file1).read(), file1, 'exec'))


# pickle object, load pickle
import pickle
favorite_color = { "lion": "yellow", "kitty": "red" }
pickle.dump( favorite_color,  open( "save.p", "wb" ) )
favorite_color = pickle.load( open( "save.p", "rb" ) )


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


# load, reload mudule
import importlib
importlib.reload(portval_func); from portval_func import *

