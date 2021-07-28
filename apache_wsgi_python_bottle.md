### python bottle app behind apache server

Apache + mod_wsgi + python + bottle

```
yum install httpd-devel
pip install mod_wsgi
pip install -U matplotlib
```

#### 1. LoadModule wsgi_module

The defalt wsgi_module is insatlled for python 2.7. In order to use your own version, look for something like ```10-wsgi.conf``` under ```/etc/httpd/conf.modules.d``` . Modify it according to the version you installed like the following.

```
LoadModule wsgi_module /home/ec2-user/miniconda3/lib/python3.6/site-packages/mod_wsgi/server/mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so
WSGIPythonHome /home/ec2-user/miniconda3
```

In case of permission error, give whatever the user the permissions.

```
sudo chmod 755 -R /home/ec2-user/miniconda3
```

Start the apache server and make sure there is no error loading the module.
```
sudo systemctl restart httpd
sudo cat /var/log/httpd/error_log
```

#### 2. configure

Put your config file under /etc/httpd/conf.d
```
Listen 5555
<VirtualHost *:5555>
    ServerName example.com

    WSGIDaemonProcess myapp user=ec2-user group=ec2-user processes=1 threads=5
    WSGIProcessGroup myapp

    Alias /static/ /home/ec2-user/myapp/static/
    <Directory  /home/ec2-user/myapp/static>
        Require all granted
    </Directory>

    WSGIScriptAlias / /var/www/myapp/wsgi.py

    <Directory /var/www/myapp>
        WSGIProcessGroup myapp
        WSGIApplicationGroup %{GLOBAL}
        Require all granted
    </Directory>
</VirtualHost>
```

Test and restart the server.
```
apachectl configtest
httpd -t
sudo systemctl restart httpd
```

Please note that you have to grant permissions to the static files, css, js, etc. Also note that for this virtualhost, it is the ```ec2-user``` who's running it. The ```mod_wsgi-py36.cpython-36m-x86_64-linux-gnu.so``` however, is loaded by another user by the system. So, it is necessary to grant permissions to the python installation.


Although python can run multiple threads under linux, it doesn't do that through httpd. In order to use all the cores, you need to tell httpd to use multiple processes like ```processes=4 threads=20``` . 


#### 3. wsgi.py
Assume the app is defined in /home/ec2-user/myapp/app.py, and you can run it

```bottle.run(server=server, host=HOST, port=PORT, reloader=True)```

in a console, put the following in ```/var/www/myapp/wsgi.py```

```
import os, sys, bottle
os.chdir('/home/ec2-user/myapp')
os.environ["MYAPPCONFIG"] = "/home/ec2-user/myapp/config.ini"
sys.path.append('/home/ec2-user/myapp')
import app
application = bottle.default_app()
```


#### 4. restart httpd, hit localhost:5555
```
sudo systemctl restart httpd
```

After that, if you change your code, just touch the wsgi.py and do a refresh from your browser to inspect the difference.
