import numpy as np
import plotly.graph_objs as go
import plotly.offline as offline

""" histogram """
x = np.random.randn(500)
# frqeuency
data = [go.Histogram(x=x, xbins=dict(start=-3.2, end=3.2, size=0.2))]
offline.plot(data, auto_open=True)
# density
data = [go.Histogram(x=x, histnorm='probability')]
offline.plot(data, auto_open=True)
# cumulative count
range = [x.min(), x.max()]
values, base = np.histogram(x, range=range, bins=40)
cumulative = np.cumsum(values)
data = [go.Scatter(x=base, y=cumulative, mode='lines', name='cumcount')]
offline.plot(data, filename='flowratiocumcount.html', auto_open=True)
