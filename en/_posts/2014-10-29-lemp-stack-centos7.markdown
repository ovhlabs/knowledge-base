---
layout: post
title:  "Lemp stack on Centos 7"
categories: Instances
author: vchanakoski
lang: en
---

#LEMP STACK - Centos7

Lets begin..

**INSTALL NGINX**
*important! this is a package for the stable version, not the mainline version.*
```
sudo rpm -Uvh http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
sudo yum install nginx
```
You can check your nginx version with the following command
```
nginx -v
```
Lets start nginx and check if it is running in the background
```
sudo systemctl start nginx.service
systemctl status nginx
```
Head on to your server ip and you should be able to see the nginx welcome page.

----
**INSTALL MARIADB (mysql drop-in replacement)**
```
sudo yum install mariadb-server mariadb
```
Lets start it up
```
sudo systemctl start mariadb
```
Next step is to setup mysql
```
sudo mysql_secure_installation
```
You are going to be asked for a root password but since this is our first installation just leave it blank and press enter.
```
Enter current password for root (enter for none):
OK, successfully used password, moving on...
```
Next you will be asked to to set a new root password. Enter one, confirm it and use the same action as below on the following options
```
Remove anonymous users? [Y/n] y                                            
 ... Success!
 
 Disallow root login remotely? [Y/n] y
 ... Success!
 
Remove test database and access to it? [Y/n] y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!
 
 Reload privilege tables now? [Y/n] y
 ... Success!
```
All done.

----
**INSTALL PHP FPM**
```
sudo yum install php php-mysql php-fpm
```
Now lets set up and secure our php/php-fpm, open the configuration with a text editor
```
/etc/php.ini
```
scroll down to the line where it says cgi.fix_pathinfo=1, uncomment it (if its commented) and change the value from 1 to 0, so it should look like this
```
cgi.fix_pathinfo=0
```

The next step is to tell php-fpm to listen to nginx instead of apahce, you have two options here
```
//using sockets
listen = /var/run/php-fpm/php-fpm.sock
```
This is not really recommended for high load and you might get some errors in the log that look like this 
```
connect() to unix:/var/run/php5-fpm.sock failed or **apr_socket_recv: Connection reset by peer (104)**
```
so lets leave it as it is by default, using tcp port
```
listen = 127.0.0.1:9000
```
Just make sure to change these two options as they are below
```
; RPM: apache Choosed to be able to access some dir as httpd
user = nginx
; RPM: Keep a group allowed to write in log dir.
group = nginx
```
You can now start php-fpm
```
sudo systemctl start php-fpm
```

----
**NGINX TEMPLATE**
After setting up php we need to edit the nginx config so that we can process php files trough nginx
```
etc/nginx/conf.d/default.conf
```
our template should look like this (dont forget to edit the server_name below)
*note! the root directory below is where nginx will be looking for your web files*
```
server {
    listen       80;
    server_name  www.our-domain.com or ip; //<- swap with yours

    root   /usr/share/nginx/html; //<- upload your web files here
    index index.php index.html index.htm;

    location / {
        index index.php index.html index.htm;
    }
    
    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /usr/share/nginx/html;
    }

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ \.php$ {
        root           /usr/share/nginx/html;
        fastcgi_pass   127.0.0.1:9000;
        fastcgi_index  index.php;
        fastcgi_param  SCRIPT_FILENAME   $document_root$fastcgi_script_name;
        include        fastcgi_params;
    }
}
```
lets restart nginx for our changes to take effect
```
sudo systemctl restart nginx
```

----
**AUTOSTART**
The final step is to set auto-start on reboot for everything that we have installed so far
```
sudo systemctl enable nginx.service
sudo systemctl enable mariadb.service
sudo systemctl enable php-fpm.service
```

Now you have a lemp stack running on your instance, time for coding ;)