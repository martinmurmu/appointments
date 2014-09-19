#!/bin/bash

git pull
sudo service nginx stop
kill -6 `cat tmp/pids/unicorn.pid`
rm -rf /tmp/sockets/unicorn.sock
unicorn_rails -c config/unicorn.rb -D
sudo service nginx start

echo 'The End!!!'

