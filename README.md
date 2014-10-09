# README #

Below is the procedure for deploying the code on environments.  

## Deploying Code on Staging ENV ##

At the time of creation of this document the staging environment is setup on server 
104.131.244.21. Below are the steps for first deployment.
  
* Please add your public key to server for authentication by the following command ssh-copy-id deploy@104.131.244.21 
* Now enter cap staging deploy

You are done with deployment. 

## Staging Unicorn Location ##

This server is running unicorn as application server and automated script is located in /etc/init.d/unicorn . Below are the common commands.

* /etc/init.d/unicorn stop
* /etc/init.d/unicorn start

Configuration file is located in config/unicorn.rb. 

## Staging Nginx Location ##

The http entertainer is used is nginx and common commands are below.

*sudo /etc/init.d/nginx stop
*sudo /etc/init.d/nginx start

### There is a branch of staging, Use that branch to push to staging server. ###

## Deploying Code on Production ENV ##

At the time of creation of this document the production environment is setup on server 
104.131.226.86. Below are the steps for first deployment.
  
* Please add your public key to server for authentication by the following command ssh-copy-id deploy@104.131.226.86 
* Now enter cap production deploy

You are done with deployment.

## Production Unicorn Location ##

This server is running unicorn as application server and automated script is located in /etc/init.d/unicorn . Below are the common commands.

* /etc/init.d/unicorn stop
* /etc/init.d/unicorn start

Configuration file is located in config/unicorn.rb. 

## Production Nginx Location ##

The http entertainer is used is nginx and common commands are below.

*sudo /etc/init.d/nginx stop
*sudo /etc/init.d/nginx start

The conf file is located on the server for mapping domains /etc/nginx/conf/nginx.conf.

### There is a branch of production, Use that branch to push to staging server. ###
